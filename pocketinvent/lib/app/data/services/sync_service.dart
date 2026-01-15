import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/telephone_model.dart';
import '../models/transaction_model.dart';
import 'storage_service.dart';
import 'supabase_service.dart';

/// Service for managing real-time synchronization with Supabase
///
/// Handles:
/// - Real-time data synchronization
/// - Offline mode detection
/// - Conflict resolution
/// - Cache management
///
/// Requirements: 9.3, 9.5, 9.6, 9.7
class SyncService extends GetxService {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final StorageService _storageService = Get.find<StorageService>();
  final Connectivity _connectivity = Connectivity();

  // Observables
  final RxBool isOnline = true.obs;
  final RxBool isSyncing = false.obs;
  final RxDateTime lastSyncTime = DateTime.now().obs;

  // Realtime subscriptions
  RealtimeChannel? _transactionChannel;
  RealtimeChannel? _telephoneChannel;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityListener();
    _checkInitialConnectivity();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _transactionChannel?.unsubscribe();
    _telephoneChannel?.unsubscribe();
    super.onClose();
  }

  /// Initialize connectivity listener
  ///
  /// Requirements: 9.5
  void _initConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final wasOnline = isOnline.value;
        isOnline.value = !results.contains(ConnectivityResult.none);

        // If we just came back online, sync data
        if (!wasOnline && isOnline.value) {
          syncAll();
        }
      },
    );
  }

  /// Check initial connectivity status
  ///
  /// Requirements: 9.5
  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      isOnline.value = !results.contains(ConnectivityResult.none);

      // If online, start real-time listeners
      if (isOnline.value) {
        await startRealtimeSync();
      }
    } catch (e) {
      print('Failed to check connectivity: $e');
      isOnline.value = false;
    }
  }

  /// Start real-time synchronization with Supabase
  ///
  /// Sets up listeners for changes to transactions and telephones tables.
  ///
  /// Requirements: 9.3, 9.6
  Future<void> startRealtimeSync() async {
    if (!isOnline.value) return;

    final userId = _supabaseService.userId;
    if (userId == null) return;

    try {
      // Listen to transaction changes
      _transactionChannel = _supabaseService.client
          .channel('transactions_$userId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'historique_transaction',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: userId,
            ),
            callback: _handleTransactionChange,
          )
          .subscribe();

      // Listen to telephone changes
      _telephoneChannel = _supabaseService.client
          .channel('telephones_$userId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'telephone',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: userId,
            ),
            callback: _handleTelephoneChange,
          )
          .subscribe();

      print('Real-time sync started');
    } catch (e) {
      print('Failed to start real-time sync: $e');
    }
  }

  /// Stop real-time synchronization
  ///
  /// Requirements: 9.3
  Future<void> stopRealtimeSync() async {
    await _transactionChannel?.unsubscribe();
    await _telephoneChannel?.unsubscribe();
    _transactionChannel = null;
    _telephoneChannel = null;
    print('Real-time sync stopped');
  }

  /// Handle transaction change from Supabase
  ///
  /// Requirements: 9.3, 9.6
  Future<void> _handleTransactionChange(PostgresChangePayload payload) async {
    try {
      print('Transaction change detected: ${payload.eventType}');

      switch (payload.eventType) {
        case PostgresChangeEvent.insert:
        case PostgresChangeEvent.update:
          if (payload.newRecord != null) {
            await _syncTransaction(payload.newRecord);
          }
          break;
        case PostgresChangeEvent.delete:
          if (payload.oldRecord != null) {
            await _deleteTransaction(payload.oldRecord['id']);
          }
          break;
        default:
          break;
      }

      lastSyncTime.value = DateTime.now();
    } catch (e) {
      print('Failed to handle transaction change: $e');
    }
  }

  /// Handle telephone change from Supabase
  ///
  /// Requirements: 9.3, 9.6
  Future<void> _handleTelephoneChange(PostgresChangePayload payload) async {
    try {
      print('Telephone change detected: ${payload.eventType}');

      switch (payload.eventType) {
        case PostgresChangeEvent.insert:
        case PostgresChangeEvent.update:
          if (payload.newRecord != null) {
            await _syncTelephone(payload.newRecord);
          }
          break;
        case PostgresChangeEvent.delete:
          if (payload.oldRecord != null) {
            await _deleteTelephone(payload.oldRecord['id']);
          }
          break;
        default:
          break;
      }

      lastSyncTime.value = DateTime.now();
    } catch (e) {
      print('Failed to handle telephone change: $e');
    }
  }

  /// Sync a single transaction to local cache
  ///
  /// Requirements: 9.4, 9.6
  Future<void> _syncTransaction(Map<String, dynamic> data) async {
    try {
      // Fetch full transaction with relations
      final response = await _supabaseService.client
          .from('historique_transaction')
          .select('''
            *,
            client:client_id(nom),
            fournisseur:fournisseur_id(nom),
            statut_paiement:statut_paiement_id(libelle)
          ''')
          .eq('id', data['id'])
          .single();

      final transaction = TransactionModel.fromJson(response);
      await _storageService.saveTransaction(transaction);
      print('Transaction synced: ${transaction.id}');
    } catch (e) {
      print('Failed to sync transaction: $e');
    }
  }

  /// Sync a single telephone to local cache
  ///
  /// Requirements: 9.4, 9.6
  Future<void> _syncTelephone(Map<String, dynamic> data) async {
    try {
      // Fetch full telephone with relations
      final response =
          await _supabaseService.client.from('telephone').select('''
            *,
            marque:marque_id(nom),
            modele:modele_id(nom),
            couleur:couleur_id(libelle),
            capacite:capacite_id(valeur),
            fournisseur:fournisseur_id(nom),
            statut_paiement:statut_paiement_id(libelle)
          ''').eq('id', data['id']).single();

      final telephone = TelephoneModel.fromJson(response);
      await _storageService.saveTelephone(telephone);
      print('Telephone synced: ${telephone.id}');
    } catch (e) {
      print('Failed to sync telephone: $e');
    }
  }

  /// Delete a transaction from local cache
  ///
  /// Requirements: 9.6
  Future<void> _deleteTransaction(String id) async {
    try {
      await _storageService.transactionBox.delete(id);
      print('Transaction deleted: $id');
    } catch (e) {
      print('Failed to delete transaction: $e');
    }
  }

  /// Delete a telephone from local cache
  ///
  /// Requirements: 9.6
  Future<void> _deleteTelephone(String id) async {
    try {
      await _storageService.telephoneBox.delete(id);
      print('Telephone deleted: $id');
    } catch (e) {
      print('Failed to delete telephone: $e');
    }
  }

  /// Sync all data from Supabase
  ///
  /// Fetches all transactions and telephones and updates the local cache.
  /// Used when coming back online or for manual refresh.
  ///
  /// Requirements: 9.3, 9.4, 9.6
  Future<void> syncAll() async {
    if (!isOnline.value) {
      print('Cannot sync: offline');
      return;
    }

    if (isSyncing.value) {
      print('Sync already in progress');
      return;
    }

    try {
      isSyncing.value = true;
      print('Starting full sync...');

      final userId = _supabaseService.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Sync transactions
      final transactionsResponse = await _supabaseService.client
          .from('historique_transaction')
          .select('''
            *,
            client:client_id(nom),
            fournisseur:fournisseur_id(nom),
            statut_paiement:statut_paiement_id(libelle)
          ''')
          .eq('user_id', userId)
          .order('date_transaction', ascending: false);

      final transactions = (transactionsResponse as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();

      await _storageService.saveTransactions(transactions);
      print('Synced ${transactions.length} transactions');

      // Sync telephones
      final telephones = await _supabaseService.getTelephones();
      await _storageService.saveTelephones(telephones);
      print('Synced ${telephones.length} telephones');

      lastSyncTime.value = DateTime.now();
      print('Full sync completed');
    } catch (e) {
      print('Sync failed: $e');
      rethrow;
    } finally {
      isSyncing.value = false;
    }
  }

  /// Get cached data for offline mode
  ///
  /// Requirements: 9.5, 9.7
  Future<Map<String, dynamic>> getCachedData() async {
    return {
      'transactions': _storageService.getAllTransactions(),
      'telephones': _storageService.getAllTelephones(),
    };
  }

  /// Clear all cached data
  ///
  /// Requirements: 9.4
  Future<void> clearCache() async {
    await _storageService.clearAll();
    print('Cache cleared');
  }
}
