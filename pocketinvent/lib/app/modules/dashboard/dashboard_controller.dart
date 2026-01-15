import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/financial_metrics.dart';
import '../../data/models/period.dart';
import '../../data/models/telephone_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/services/financial_calculator.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/export_service.dart';
import '../../routes/app_pages.dart';

/// Controller for the financial dashboard
///
/// Manages the state and business logic for displaying financial metrics,
/// handling period selection, and synchronizing data with Supabase.
///
/// Requirements: 1.1, 1.6, 9.1, 9.4, 9.5
class DashboardController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final StorageService _storageService = Get.find<StorageService>();
  final FinancialCalculator _calculator = FinancialCalculator();
  final ExportService _exportService = ExportService();
  late final NotificationService _notificationService;

  // Observables
  final Rx<Period> selectedPeriod = Period.thisMonth().obs;
  final Rx<FinancialMetrics?> metrics = Rx<FinancialMetrics?>(null);
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxList<TelephoneModel> phones = <TelephoneModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSyncing = false.obs;

  // Navigation
  final RxInt currentNavIndex = 0.obs;
  final RxInt transactionBadgeCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _notificationService = Get.find<NotificationService>();
    _loadSavedPeriod();
    loadData();

    // Recalculate metrics whenever period changes
    ever(selectedPeriod, (_) {
      calculateMetrics();
      _savePeriod();
    });

    // Update badge count
    _updateBadgeCount();
  }

  /// Update the transaction badge count
  ///
  /// Requirements: 5.6
  void _updateBadgeCount() {
    transactionBadgeCount.value = _notificationService.getNewTransactionCount();
  }

  /// Load the last saved period from local storage
  ///
  /// Requirements: 7.5
  void _loadSavedPeriod() {
    try {
      final savedPeriodJson = _storageService.getUserData('selected_period');
      if (savedPeriodJson != null) {
        selectedPeriod.value = Period.fromJson(savedPeriodJson);
      }
    } catch (e) {
      // If loading fails, keep default period (thisMonth)
      print('Failed to load saved period: $e');
    }
  }

  /// Save the current period to local storage
  ///
  /// Requirements: 7.5
  Future<void> _savePeriod() async {
    try {
      await _storageService.saveUserData(
        'selected_period',
        selectedPeriod.value.toJson(),
      );
    } catch (e) {
      print('Failed to save period: $e');
    }
  }

  /// Load all data (transactions and phones) from cache and Supabase
  ///
  /// This method:
  /// 1. Loads cached data first for immediate display
  /// 2. Calculates metrics from cached data
  /// 3. Syncs with Supabase in the background
  /// 4. Updates metrics with fresh data
  ///
  /// Requirements: 1.1, 9.1, 9.4, 9.5
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Load from cache first (offline support)
      await _loadCachedData();

      // Calculate metrics from cached data
      calculateMetrics();

      // Sync with Supabase in background
      await _syncWithSupabase();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load transactions and phones from local cache
  ///
  /// Requirements: 9.4, 9.5
  Future<void> _loadCachedData() async {
    try {
      transactions.value = _storageService.getAllTransactions();
      phones.value = _storageService.getAllTelephones();
    } catch (e) {
      print('Failed to load cached data: $e');
      transactions.value = [];
      phones.value = [];
    }
  }

  /// Synchronize data with Supabase
  ///
  /// Fetches fresh data from the server and updates the local cache.
  /// Shows a sync indicator while syncing.
  ///
  /// Requirements: 9.3, 9.6, 9.7
  Future<void> _syncWithSupabase() async {
    try {
      isSyncing.value = true;

      // Fetch transactions from Supabase
      final remoteTransactions = await _fetchTransactionsFromSupabase();
      await _storageService.saveTransactions(remoteTransactions);
      transactions.value = remoteTransactions;

      // Fetch phones from Supabase
      final remotePhones = await _supabaseService.getTelephones();
      await _storageService.saveTelephones(remotePhones);
      phones.value = remotePhones;

      // Recalculate metrics with fresh data
      calculateMetrics();
    } catch (e) {
      // If sync fails, continue with cached data
      print('Sync failed: $e');
      Get.snackbar(
        'Synchronisation',
        'Impossible de synchroniser. Affichage des données en cache.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isSyncing.value = false;
    }
  }

  /// Fetch all transactions from Supabase
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

  /// Calculate financial metrics for the selected period
  ///
  /// Uses the FinancialCalculator service to compute all metrics
  /// and caches the result in Hive for offline access.
  ///
  /// Requirements: 1.6, 9.1, 9.4
  void calculateMetrics() {
    try {
      final calculatedMetrics = _calculator.calculateMetrics(
        transactions: transactions,
        phones: phones,
        period: selectedPeriod.value,
      );

      metrics.value = calculatedMetrics;

      // Cache the calculated metrics
      _cacheMetrics(calculatedMetrics);
    } catch (e) {
      print('Failed to calculate metrics: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de calculer les métriques: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Cache the calculated metrics in Hive
  ///
  /// Requirements: 9.4
  Future<void> _cacheMetrics(FinancialMetrics metrics) async {
    try {
      final box = await Hive.openBox<FinancialMetrics>('financial_metrics');
      await box.put('current_metrics', metrics);
    } catch (e) {
      print('Failed to cache metrics: $e');
    }
  }

  /// Change the selected period and recalculate metrics
  ///
  /// The metrics will be automatically recalculated due to the
  /// `ever` listener set up in onInit.
  ///
  /// Requirements: 1.6, 7.2
  void changePeriod(Period newPeriod) {
    selectedPeriod.value = newPeriod;
  }

  /// Refresh data by reloading from Supabase
  ///
  /// This is typically called by pull-to-refresh gestures.
  ///
  /// Requirements: 9.1, 9.3
  Future<void> refresh() async {
    await loadData();
  }

  /// Handle navigation bar tap
  ///
  /// Requirements: 5.3, 5.4
  void onNavTap(int index) {
    if (index == currentNavIndex.value) return;

    currentNavIndex.value = index;
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Get.offNamed(Routes.HOME);
        break;
      case 2:
        Get.offNamed(Routes.TRANSACTIONS);
        break;
      case 3:
        Get.offNamed(Routes.HUB);
        break;
    }
  }

  /// Export transactions to CSV file
  ///
  /// Creates a CSV file with all transactions for the selected period
  /// and shares it via the system share dialog.
  ///
  /// Requirements: 10.1, 10.2, 10.4, 10.5, 10.6
  Future<void> exportToCSV() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Generate CSV file
      final File csvFile = await _exportService.exportToCSV(
        transactions: transactions,
        period: selectedPeriod.value,
      );

      // Close loading dialog
      Get.back();

      // Share the file
      await Share.shareXFiles(
        [XFile(csvFile.path)],
        subject: 'Export PocketInvent - Transactions',
      );

      // Show success notification
      Get.snackbar(
        'Export réussi',
        'Le fichier CSV a été généré avec succès',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Erreur',
        'Impossible d\'exporter les données: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  /// Export financial report to PDF file
  ///
  /// Creates a PDF report with financial metrics, statistics, and transaction summary
  /// for the selected period and shares it via the system share dialog.
  ///
  /// Requirements: 10.3, 10.4, 10.5, 10.6
  Future<void> exportToPDF() async {
    try {
      // Validate that metrics are available
      if (metrics.value == null) {
        Get.snackbar(
          'Erreur',
          'Aucune donnée disponible pour l\'export',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Generate PDF file
      final File pdfFile = await _exportService.exportToPDF(
        transactions: transactions,
        metrics: metrics.value!,
        period: selectedPeriod.value,
      );

      // Close loading dialog
      Get.back();

      // Share the file
      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        subject: 'Rapport PocketInvent',
      );

      // Show success notification
      Get.snackbar(
        'Export réussi',
        'Le rapport PDF a été généré avec succès',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Erreur',
        'Impossible de générer le rapport: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }
}
