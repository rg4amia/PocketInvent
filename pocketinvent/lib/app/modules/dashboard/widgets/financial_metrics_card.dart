import 'package:flutter/material.dart';
import '../../../data/models/financial_metrics.dart';
import '../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

/// Widget displaying the main financial metrics
///
/// Shows the 4 primary financial metrics:
/// - Total Entrées (purchases) in red
/// - Total Sorties (sales) in green
/// - Profit Net (net profit) with color based on positive/negative
/// - Marge Bénéficiaire (profit margin) with color based on positive/negative
///
/// All amounts are formatted with 2 decimal places and the € symbol.
///
/// Requirements: 1.2, 1.3, 1.4, 1.5, 6.8
class FinancialMetricsCard extends StatelessWidget {
  final FinancialMetrics metrics;

  const FinancialMetricsCard({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Métriques Financières',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  label: 'Entrées',
                  value: metrics.totalEntrees,
                  color: AppColors.deleteAccent, // Red for expenses
                  icon: Icons.arrow_downward,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricItem(
                  label: 'Sorties',
                  value: metrics.totalSorties,
                  color: AppColors.successAccent, // Green for income
                  icon: Icons.arrow_upward,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  label: 'Profit Net',
                  value: metrics.profitNet,
                  color: metrics.profitNet >= 0
                      ? AppColors.successAccent
                      : AppColors.deleteAccent,
                  icon: metrics.profitNet >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMarginItem(
                  label: 'Marge',
                  percentage: metrics.margeBeneficiaire,
                  color: metrics.margeBeneficiaire >= 0
                      ? AppColors.successAccent
                      : AppColors.deleteAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a single metric item with icon, label, and formatted value
  ///
  /// Requirements: 6.8
  Widget _buildMetricItem({
    required String label,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    final formatter = NumberFormat('#,##0.00', 'fr_FR');
    final formattedValue = formatter.format(value.abs());

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${value < 0 ? '-' : ''}$formattedValue €',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the margin percentage item
  ///
  /// Requirements: 1.5, 6.8
  Widget _buildMarginItem({
    required String label,
    required double percentage,
    required Color color,
  }) {
    final formatter = NumberFormat('#,##0.00', 'fr_FR');
    final formattedPercentage = formatter.format(percentage.abs());

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.percent,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage < 0 ? '-' : ''}$formattedPercentage %',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
