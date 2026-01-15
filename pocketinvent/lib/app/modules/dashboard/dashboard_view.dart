import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/animation_utils.dart';
import '../widgets/main_nav_bar.dart';
import '../widgets/skeleton_loader.dart';
import 'widgets/period_selector.dart';
import 'widgets/financial_metrics_card.dart';
import 'widgets/quick_stats_grid.dart';
import 'widgets/charts_section.dart';
import 'widgets/sync_indicator.dart';

/// Main dashboard view displaying financial metrics and statistics
///
/// Assembles all dashboard widgets:
/// - PeriodSelector: For filtering data by time period
/// - FinancialMetricsCard: Main financial metrics
/// - QuickStatsGrid: Quick statistics
/// - ChartsSection: Visual charts and graphs
///
/// Handles loading states and empty period messages.
///
/// Requirements: 1.1, 7.6, 8.7
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        centerTitle: false,
        actions: [
          // Sync indicator
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(child: SyncIndicator()),
          ),
          // Export menu button
          PopupMenuButton<String>(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Exporter',
            onSelected: (value) {
              if (value == 'csv') {
                controller.exportToCSV();
              } else if (value == 'pdf') {
                controller.exportToPDF();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'csv',
                child: Row(
                  children: [
                    Icon(Icons.table_chart, size: 20),
                    SizedBox(width: 12),
                    Text('Exporter en CSV'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, size: 20),
                    SizedBox(width: 12),
                    Text('Exporter en PDF'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.metrics.value == null) {
          return const SkeletonDashboard();
        }

        final metrics = controller.metrics.value;
        if (metrics == null) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            // Offline banner
            if (!controller.isOnline.value)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: const Color(0xFFFF9800),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.cloud_off,
                      size: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Mode hors ligne - Affichage des données en cache',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            // Main content
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refresh,
                color: AppColors.primaryBlue,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Period Selector with fade-in animation
                      AnimatedSlideUpFadeIn(
                        delay: const Duration(milliseconds: 0),
                        child: PeriodSelector(
                          selectedPeriod: controller.selectedPeriod.value,
                          onPeriodChanged: controller.changePeriod,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Financial Metrics Card with slide-up animation
                      AnimatedSlideUpFadeIn(
                        delay: const Duration(milliseconds: 100),
                        child: FinancialMetricsCard(metrics: metrics),
                      ),
                      const SizedBox(height: 16),

                      // Quick Stats Grid with staggered animation
                      AnimatedSlideUpFadeIn(
                        delay: const Duration(milliseconds: 200),
                        child: QuickStatsGrid(metrics: metrics),
                      ),
                      const SizedBox(height: 16),

                      // Charts Section with delayed animation
                      AnimatedSlideUpFadeIn(
                        delay: const Duration(milliseconds: 300),
                        child: ChartsSection(
                          transactions: controller.transactions,
                          phones: controller.phones,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() => MainNavBar(
            currentIndex: controller.currentNavIndex.value,
            onTap: controller.onNavTap,
            transactionBadgeCount: controller.transactionBadgeCount.value,
          )),
    );
  }

  /// Build empty state when no data is available
  ///
  /// Requirements: 7.6, 8.7
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSlideUpFadeIn(
              delay: Duration.zero,
              child: Icon(
                Icons.inbox_outlined,
                size: 80,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSlideUpFadeIn(
              delay: const Duration(milliseconds: 100),
              child: Text(
                'Aucune donnée disponible',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSlideUpFadeIn(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Commencez par ajouter des téléphones et des transactions pour voir vos statistiques financières.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            AnimatedSlideUpFadeIn(
              delay: const Duration(milliseconds: 300),
              child: ElevatedButton.icon(
                onPressed: () => controller.refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Actualiser'),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
