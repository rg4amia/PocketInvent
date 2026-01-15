import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'transaction_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/period.dart';
import '../../data/services/storage_service.dart';
import '../widgets/main_nav_bar.dart';
import 'widgets/transaction_card.dart';
import 'widgets/transaction_filters.dart';

/// Main view for displaying the transaction list
///
/// Features:
/// - Displays all transactions sorted by date (newest first)
/// - Integrates filters (type and period)
/// - Supports infinite scroll with pagination
/// - Pull-to-refresh functionality
/// - Search by IMEI
///
/// Requirements: 2.1, 2.6, 2.7
class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text(
          'Transactions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        centerTitle: false,
        actions: [
          // Clear filters button
          Obx(() {
            final hasFilters = controller.selectedType.value != null ||
                controller.selectedPeriod.value.type != PeriodType.all ||
                controller.searchQuery.value.isNotEmpty;

            if (!hasFilters) return const SizedBox.shrink();

            return IconButton(
              icon: const Icon(Icons.clear_all_rounded),
              onPressed: controller.clearFilters,
              tooltip: 'Effacer les filtres',
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),

          // Filters
          Obx(() => TransactionFilters(
                selectedType: controller.selectedType.value,
                selectedPeriod: controller.selectedPeriod.value,
                onTypeChanged: controller.filterByType,
                onPeriodChanged: controller.filterByPeriod,
              )),

          const Divider(height: 1),

          // Transaction list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.filteredTransactions.isEmpty) {
                return _buildLoadingState();
              }

              if (controller.filteredTransactions.isEmpty) {
                return _buildEmptyState();
              }

              return _buildTransactionList(storageService);
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => MainNavBar(
            currentIndex: controller.currentNavIndex.value,
            onTap: controller.onNavTap,
            transactionBadgeCount: controller.transactionBadgeCount.value,
          )),
    );
  }

  /// Build the search bar for IMEI search
  ///
  /// Requirements: 2.8
  Widget _buildSearchBar() {
    return Container(
      color: AppColors.backgroundPrimary,
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: controller.searchByIMEI,
        decoration: InputDecoration(
          hintText: 'Rechercher par IMEI...',
          hintStyle: TextStyle(
            color: AppColors.textPlaceholder,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
          ),
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  /// Build the transaction list with pull-to-refresh
  ///
  /// Displays transactions sorted by date in descending order
  ///
  /// Requirements: 2.1
  Widget _buildTransactionList(StorageService storageService) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      color: AppColors.primaryBlue,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = controller.filteredTransactions[index];

          // Get phone data from storage
          final phone = storageService.getTelephone(transaction.telephoneId);

          return TransactionCard(
            transaction: transaction,
            phone: phone,
          );
        },
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement des transactions...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state when no transactions match filters
  ///
  /// Requirements: 7.6
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 80,
              color: AppColors.primaryBlue.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune transaction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aucune transaction ne correspond aux filtres sélectionnés.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              final hasFilters = controller.selectedType.value != null ||
                  controller.selectedPeriod.value.type != PeriodType.all ||
                  controller.searchQuery.value.isNotEmpty;

              if (!hasFilters) return const SizedBox.shrink();

              return ElevatedButton.icon(
                onPressed: controller.clearFilters,
                icon: const Icon(Icons.clear_all_rounded),
                label: const Text('Effacer les filtres'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
