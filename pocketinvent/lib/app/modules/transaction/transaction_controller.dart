import 'package:get/get.dart';
import '../../data/models/period.dart';
import '../../data/models/transaction_model.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_pages.dart';

/// Controller for the transaction list view
///
/// Manages the state and business logic for displaying, filtering,
/// and searching transactions.
///
/// Requirements: 2.1, 2.6, 2.7, 2.8
class TransactionController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Observables
  final RxList<TransactionModel> allTransactions = <TransactionModel>[].obs;
  final RxList<TransactionModel> filteredTransactions =
      <TransactionModel>[].obs;
  final RxBool isLoading = false.obs;

  // Filter observables
  final Rx<String?> selectedType = Rx<String?>(null);
  final Rx<Period> selectedPeriod = Period.all().obs;
  final RxString searchQuery = ''.obs;

  // Navigation
  final RxInt currentNavIndex = 2.obs;
  final RxInt transactionBadgeCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();

    // Apply filters whenever any filter changes
    ever(selectedType, (_) => _applyFilters());
    ever(selectedPeriod, (_) => _applyFilters());
    ever(searchQuery, (_) => _applyFilters());
  }

  /// Load all transactions from cache and Supabase
  ///
  /// This method:
  /// 1. Loads cached transactions first for immediate display
  /// 2. Syncs with Supabase to get fresh data
  /// 3. Applies current filters to the loaded data
  ///
  /// Requirements: 2.1
  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;

      // Load from cache first
      final cachedTransactions = _storageService.getAllTransactions();
      if (cachedTransactions.isNotEmpty) {
        allTransactions.value = cachedTransactions;
        _applyFilters();
      }

      // Sync with Supabase
      final remoteTransactions = await _fetchTransactionsFromSupabase();
      await _storageService.saveTransactions(remoteTransactions);

      allTransactions.value = remoteTransactions;
      _applyFilters();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les transactions: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all transactions from Supabase
  ///
  /// Returns transactions sorted by date in descending order (newest first)
  ///
  /// Requirements: 2.1
  Future<List<TransactionModel>> _fetchTransactionsFromSupabase() async {
    final userId = _supabaseService.userId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response =
        await _supabaseService.client.from('historique_transaction').select('''
          *,
          client:client_id(nom),
          fournisseur:fournisseur_id(nom),
          statut_paiement:statut_paiement_id(libelle)
        ''').eq('user_id', userId).order('date_transaction', ascending: false);

    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  /// Apply all active filters to the transaction list
  ///
  /// This method combines type filtering, period filtering, and IMEI search
  /// to produce the final filtered list.
  void _applyFilters() {
    var filtered = List<TransactionModel>.from(allTransactions);

    // Apply type filter
    if (selectedType.value != null) {
      filtered = _filterByTypeInternal(filtered, selectedType.value!);
    }

    // Apply period filter
    filtered = _filterByPeriodInternal(filtered, selectedPeriod.value);

    // Apply IMEI search
    if (searchQuery.value.isNotEmpty) {
      filtered = _searchByIMEIInternal(filtered, searchQuery.value);
    }

    filteredTransactions.value = filtered;
  }

  /// Filter transactions by type
  ///
  /// Sets the type filter and triggers a re-filtering of the transaction list.
  ///
  /// Requirements: 2.6
  void filterByType(String? type) {
    selectedType.value = type;
  }

  /// Internal method to filter transactions by type
  ///
  /// Returns only transactions matching the specified type.
  ///
  /// Requirements: 2.6
  List<TransactionModel> _filterByTypeInternal(
    List<TransactionModel> transactions,
    String type,
  ) {
    return transactions
        .where((t) => t.typeTransaction.toLowerCase() == type.toLowerCase())
        .toList();
  }

  /// Filter transactions by period
  ///
  /// Sets the period filter and triggers a re-filtering of the transaction list.
  ///
  /// Requirements: 2.7, 7.2, 7.4
  void filterByPeriod(Period period) {
    selectedPeriod.value = period;
  }

  /// Internal method to filter transactions by period
  ///
  /// Returns only transactions whose date falls within the period's date range.
  ///
  /// Requirements: 2.7, 7.2, 7.4
  List<TransactionModel> _filterByPeriodInternal(
    List<TransactionModel> transactions,
    Period period,
  ) {
    final startDate = period.getStartDate();
    final endDate = period.getEndDate();

    return transactions.where((transaction) {
      final transactionDate = transaction.dateTransaction;
      return transactionDate
              .isAfter(startDate.subtract(const Duration(seconds: 1))) &&
          transactionDate.isBefore(endDate.add(const Duration(seconds: 1)));
    }).toList();
  }

  /// Search transactions by IMEI
  ///
  /// Sets the search query and triggers a re-filtering of the transaction list.
  ///
  /// Requirements: 2.8
  void searchByIMEI(String query) {
    searchQuery.value = query;
  }

  /// Internal method to search transactions by IMEI
  ///
  /// Returns only transactions linked to phones whose IMEI contains the search query.
  /// Note: This requires the phone data to be loaded. In a real implementation,
  /// you might want to join with the phone table or cache phone IMEIs.
  ///
  /// Requirements: 2.8
  List<TransactionModel> _searchByIMEIInternal(
    List<TransactionModel> transactions,
    String query,
  ) {
    if (query.isEmpty) return transactions;

    final lowerQuery = query.toLowerCase();

    // Get all phones from cache to match IMEI
    final phones = _storageService.getAllTelephones();
    final phoneIdsByIMEI = phones
        .where((p) => p.imei.toLowerCase().contains(lowerQuery))
        .map((p) => p.id)
        .toSet();

    return transactions
        .where((t) => phoneIdsByIMEI.contains(t.telephoneId))
        .toList();
  }

  /// Clear all filters
  ///
  /// Resets all filters to their default values and shows all transactions.
  void clearFilters() {
    selectedType.value = null;
    selectedPeriod.value = Period.all();
    searchQuery.value = '';
  }

  /// Refresh transactions by reloading from Supabase
  ///
  /// This is typically called by pull-to-refresh gestures.
  Future<void> refresh() async {
    await loadTransactions();
  }

  /// Get the count of transactions by type
  ///
  /// Useful for displaying statistics or badges.
  int getCountByType(String type) {
    return allTransactions
        .where((t) => t.typeTransaction.toLowerCase() == type.toLowerCase())
        .length;
  }

  /// Get available transaction types from the current data
  ///
  /// Returns a list of unique transaction types present in the data.
  List<String> getAvailableTypes() {
    final types =
        allTransactions.map((t) => t.typeTransaction).toSet().toList();
    types.sort();
    return types;
  }

  /// Handle navigation bar tap
  ///
  /// Requirements: 5.3, 5.4
  void onNavTap(int index) {
    if (index == currentNavIndex.value) return;

    currentNavIndex.value = index;
    switch (index) {
      case 0:
        Get.offNamed(Routes.DASHBOARD);
        break;
      case 1:
        Get.offNamed(Routes.HOME);
        break;
      case 2:
        // Already on transactions
        break;
      case 3:
        Get.offNamed(Routes.HUB);
        break;
    }
  }
}
