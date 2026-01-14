import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/telephone_model.dart';
import '../models/transaction_model.dart';
import '../models/client.dart';
import '../models/fournisseur.dart';
import 'transaction_exceptions.dart';
import 'supabase_service.dart';

/// Service responsible for managing transactions (purchases, sales, returns)
/// and ensuring proper workflow enforcement (e.g., return before resale).
class TransactionService extends GetxService {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  SupabaseClient get _supabase => _supabaseService.client;
  String? get _userId => _supabaseService.userId;

  /// Creates a purchase transaction for a phone from a supplier.
  ///
  /// This method:
  /// - Creates a transaction record with type "achat"
  /// - Updates the phone status to "enStock"
  /// - Caches the transaction locally
  ///
  /// Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 4.2, 4.3, 4.4
  Future<TransactionModel> createPurchase({
    required TelephoneModel phone,
    required Fournisseur fournisseur,
    required double montant,
    required String statutPaiementId,
    String? notes,
  }) async {
    if (_userId == null) {
      throw InsufficientDataException('User must be authenticated');
    }

    // Create transaction data
    final transactionData = {
      'user_id': _userId,
      'telephone_id': phone.id,
      'type_transaction': 'achat',
      'fournisseur_id': fournisseur.id,
      'montant': montant,
      'statut_paiement_id': statutPaiementId,
      'date_transaction': DateTime.now().toIso8601String(),
      'notes': notes,
    };

    // Insert transaction into Supabase
    final response = await _supabase
        .from('historique_transaction')
        .insert(transactionData)
        .select('''
          *,
          client:client_id(nom),
          fournisseur:fournisseur_id(nom),
          statut_paiement:statut_paiement_id(libelle)
        ''').single();

    final transaction = TransactionModel.fromJson(response);

    // Update phone status to "enStock"
    await _updatePhoneStatus(phone.id, StockStatus.enStock);

    // Cache the transaction
    await _cacheTransaction(transaction);

    return transaction;
  }

  /// Creates a sale transaction for a phone to a client.
  ///
  /// This method validates that the phone can be sold (status must be
  /// "enStock" or "retourne"). If the phone is already sold, it throws
  /// a SaleBlockedException.
  ///
  /// Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 4.2, 4.3, 4.4
  Future<TransactionModel> createSale({
    required TelephoneModel phone,
    required Client client,
    required double montant,
    required String statutPaiementId,
    String? notes,
  }) async {
    if (_userId == null) {
      throw InsufficientDataException('User must be authenticated');
    }

    // Validate that the phone can be sold
    if (!phone.canBeSold) {
      throw SaleBlockedException(
        'Ce téléphone ne peut pas être vendu. '
        'Il doit d\'abord être marqué comme retourné.',
      );
    }

    // Create transaction data
    final transactionData = {
      'user_id': _userId,
      'telephone_id': phone.id,
      'type_transaction': 'vente',
      'client_id': client.id,
      'montant': montant,
      'statut_paiement_id': statutPaiementId,
      'date_transaction': DateTime.now().toIso8601String(),
      'notes': notes,
    };

    // Insert transaction into Supabase
    final response = await _supabase
        .from('historique_transaction')
        .insert(transactionData)
        .select('''
          *,
          client:client_id(nom),
          fournisseur:fournisseur_id(nom),
          statut_paiement:statut_paiement_id(libelle)
        ''').single();

    final transaction = TransactionModel.fromJson(response);

    // Update phone status to "vendu"
    await _updatePhoneStatus(phone.id, StockStatus.vendu);

    // Cache the transaction
    await _cacheTransaction(transaction);

    return transaction;
  }

  /// Creates a return transaction for a sold phone.
  ///
  /// This method validates that the phone is currently sold before
  /// allowing a return. After creating the return transaction, it
  /// updates the phone status to "retourne", making it available
  /// for resale.
  ///
  /// Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 4.2, 4.3, 4.4
  Future<TransactionModel> createReturn({
    required TelephoneModel phone,
    required Client client,
    required double montantRemboursement,
    required String statutPaiementId,
    String? notes,
  }) async {
    if (_userId == null) {
      throw InsufficientDataException('User must be authenticated');
    }

    // Validate that the phone is sold
    if (phone.stockStatus != StockStatus.vendu) {
      throw InvalidReturnException(
        'Ce téléphone n\'est pas marqué comme vendu.',
      );
    }

    // Create transaction data
    final transactionData = {
      'user_id': _userId,
      'telephone_id': phone.id,
      'type_transaction': 'retour',
      'client_id': client.id,
      'montant': montantRemboursement,
      'statut_paiement_id': statutPaiementId,
      'date_transaction': DateTime.now().toIso8601String(),
      'notes': notes,
    };

    // Insert transaction into Supabase
    final response = await _supabase
        .from('historique_transaction')
        .insert(transactionData)
        .select('''
          *,
          client:client_id(nom),
          fournisseur:fournisseur_id(nom),
          statut_paiement:statut_paiement_id(libelle)
        ''').single();

    final transaction = TransactionModel.fromJson(response);

    // Update phone status to "retourne"
    await _updatePhoneStatus(phone.id, StockStatus.retourne);

    // Cache the transaction
    await _cacheTransaction(transaction);

    return transaction;
  }

  /// Updates the stock status of a phone in the database.
  ///
  /// This is a private helper method used by createPurchase, createSale,
  /// and createReturn to maintain the phone's status.
  Future<void> _updatePhoneStatus(String phoneId, StockStatus status) async {
    if (_userId == null) {
      throw InsufficientDataException('User must be authenticated');
    }

    final statusString = _stockStatusToString(status);

    await _supabase
        .from('telephone')
        .update({
          'stock_status': statusString,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', phoneId)
        .eq('user_id', _userId!);
  }

  /// Converts a StockStatus enum to its string representation.
  String _stockStatusToString(StockStatus status) {
    switch (status) {
      case StockStatus.enStock:
        return 'enStock';
      case StockStatus.vendu:
        return 'vendu';
      case StockStatus.retourne:
        return 'retourne';
    }
  }

  /// Caches a transaction in the local Hive database for offline access.
  ///
  /// This method stores the transaction in a Hive box to enable
  /// quick access and offline functionality.
  Future<void> _cacheTransaction(TransactionModel transaction) async {
    try {
      final box = await Hive.openBox<TransactionModel>('transactions');
      await box.put(transaction.id, transaction);
    } catch (e) {
      // Log error but don't fail the transaction
      print('Failed to cache transaction: $e');
    }
  }

  /// Retrieves all transactions for a specific phone from the database.
  ///
  /// Returns transactions ordered by date in descending order (newest first).
  Future<List<TransactionModel>> getTransactionHistory(String phoneId) async {
    if (_userId == null) {
      throw InsufficientDataException('User must be authenticated');
    }

    final response = await _supabase
        .from('historique_transaction')
        .select('''
          *,
          client:client_id(nom),
          fournisseur:fournisseur_id(nom),
          statut_paiement:statut_paiement_id(libelle)
        ''')
        .eq('telephone_id', phoneId)
        .eq('user_id', _userId!)
        .order('date_transaction', ascending: false);

    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  /// Retrieves all transactions for the current user from the database.
  ///
  /// Returns transactions ordered by date in descending order (newest first).
  Future<List<TransactionModel>> getAllTransactions() async {
    if (_userId == null) {
      throw InsufficientDataException('User must be authenticated');
    }

    final response = await _supabase
        .from('historique_transaction')
        .select('''
          *,
          client:client_id(nom),
          fournisseur:fournisseur_id(nom),
          statut_paiement:statut_paiement_id(libelle)
        ''')
        .eq('user_id', _userId!)
        .order('date_transaction', ascending: false);

    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }
}
