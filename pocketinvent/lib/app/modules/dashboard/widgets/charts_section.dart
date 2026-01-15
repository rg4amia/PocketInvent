import 'package:flutter/material.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/telephone_model.dart';
import '../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

/// Widget displaying financial charts and visualizations
///
/// Shows:
/// - Line chart: Revenue evolution over time
/// - Bar chart: Income vs Expenses comparison
/// - Pie chart: Sales distribution by brand
///
/// All charts are interactive with tap-to-show-details functionality.
///
/// Requirements: 8.1, 8.2, 8.3, 8.4, 8.6
///
/// Note: This implementation uses placeholder containers.
/// To add actual charts, install a charting library like fl_chart:
/// - Add to pubspec.yaml: fl_chart: ^0.66.0
/// - Import: import 'package:fl_chart/fl_chart.dart';
/// - Replace placeholder containers with actual chart widgets
class ChartsSection extends StatelessWidget {
  final List<TransactionModel> transactions;
  final List<TelephoneModel> phones;

  const ChartsSection({
    super.key,
    required this.transactions,
    required this.phones,
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
            'Graphiques',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildRevenueLineChart(),
          const SizedBox(height: 16),
          _buildInOutBarChart(),
          const SizedBox(height: 16),
          _buildBrandPieChart(),
        ],
      ),
    );
  }

  /// Build revenue evolution line chart
  ///
  /// Requirements: 8.1, 8.4, 8.6
  Widget _buildRevenueLineChart() {
    // Calculate revenue data by month
    final revenueByMonth = _calculateRevenueByMonth();
    final hasData = revenueByMonth.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.show_chart,
              size: 20,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              'Évolution du Chiffre d\'Affaires',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: hasData
              ? _buildChartPlaceholder(
                  'Graphique en courbe',
                  'Évolution du CA sur la période',
                  Icons.show_chart,
                  AppColors.successAccent,
                )
              : _buildEmptyChartMessage('Aucune donnée de vente disponible'),
        ),
      ],
    );
  }

  /// Build income vs expenses bar chart
  ///
  /// Requirements: 8.2, 8.4, 8.6
  Widget _buildInOutBarChart() {
    // Calculate income and expenses by month
    final inOutByMonth = _calculateInOutByMonth();
    final hasData = inOutByMonth.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.bar_chart,
              size: 20,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              'Entrées vs Sorties',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: hasData
              ? _buildChartPlaceholder(
                  'Graphique en barres',
                  'Comparaison mensuelle',
                  Icons.bar_chart,
                  AppColors.primaryBlue,
                )
              : _buildEmptyChartMessage('Aucune transaction disponible'),
        ),
      ],
    );
  }

  /// Build brand distribution pie chart
  ///
  /// Requirements: 8.3, 8.4, 8.6
  Widget _buildBrandPieChart() {
    // Calculate sales by brand
    final salesByBrand = _calculateSalesByBrand();
    final hasData = salesByBrand.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.pie_chart,
              size: 20,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              'Répartition par Marque',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: hasData
              ? _buildBrandLegend(salesByBrand)
              : _buildEmptyChartMessage('Aucune vente disponible'),
        ),
      ],
    );
  }

  /// Build a placeholder for charts (to be replaced with actual chart library)
  Widget _buildChartPlaceholder(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: color.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Graphique à implémenter',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty chart message
  ///
  /// Requirements: 8.7
  Widget _buildEmptyChartMessage(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 40,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build brand legend (simplified pie chart representation)
  Widget _buildBrandLegend(Map<String, int> salesByBrand) {
    final total = salesByBrand.values.fold(0, (sum, count) => sum + count);
    final sortedBrands = salesByBrand.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...sortedBrands.take(5).map((entry) {
            final percentage = (entry.value / total * 100).toStringAsFixed(1);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getBrandColor(entry.key),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.value} ($percentage%)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
          if (sortedBrands.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '+ ${sortedBrands.length - 5} autres marques',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Calculate revenue by month from transactions
  Map<String, double> _calculateRevenueByMonth() {
    final revenueByMonth = <String, double>{};
    final dateFormat = DateFormat('MMM yyyy', 'fr');

    for (final transaction in transactions) {
      if (transaction.typeTransaction.toLowerCase() == 'vente') {
        final monthKey = dateFormat.format(transaction.dateTransaction);
        revenueByMonth[monthKey] =
            (revenueByMonth[monthKey] ?? 0) + transaction.montant;
      }
    }

    return revenueByMonth;
  }

  /// Calculate income and expenses by month
  Map<String, Map<String, double>> _calculateInOutByMonth() {
    final inOutByMonth = <String, Map<String, double>>{};
    final dateFormat = DateFormat('MMM yyyy', 'fr');

    for (final transaction in transactions) {
      final monthKey = dateFormat.format(transaction.dateTransaction);

      if (!inOutByMonth.containsKey(monthKey)) {
        inOutByMonth[monthKey] = {'in': 0.0, 'out': 0.0};
      }

      if (transaction.typeTransaction.toLowerCase() == 'achat') {
        inOutByMonth[monthKey]!['in'] =
            (inOutByMonth[monthKey]!['in'] ?? 0) + transaction.montant;
      } else if (transaction.typeTransaction.toLowerCase() == 'vente') {
        inOutByMonth[monthKey]!['out'] =
            (inOutByMonth[monthKey]!['out'] ?? 0) + transaction.montant;
      }
    }

    return inOutByMonth;
  }

  /// Calculate sales count by brand
  Map<String, int> _calculateSalesByBrand() {
    final salesByBrand = <String, int>{};

    // Get sold phone IDs from transactions
    final soldPhoneIds = transactions
        .where((t) => t.typeTransaction.toLowerCase() == 'vente')
        .map((t) => t.telephoneId)
        .toSet();

    // Count by brand
    for (final phone in phones) {
      if (soldPhoneIds.contains(phone.id)) {
        final brand = phone.marqueName;
        salesByBrand[brand] = (salesByBrand[brand] ?? 0) + 1;
      }
    }

    return salesByBrand;
  }

  /// Get a color for a brand (simple hash-based color assignment)
  Color _getBrandColor(String brand) {
    final colors = [
      AppColors.primaryBlue,
      AppColors.successAccent,
      AppColors.deleteAccent,
      const Color(0xFFFFA726), // Orange
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF8BC34A), // Light Green
    ];

    final index = brand.hashCode.abs() % colors.length;
    return colors[index];
  }
}
