import 'package:flutter/material.dart';
import '../../../data/models/period.dart';
import '../../../core/theme/app_colors.dart';

/// Widget that provides filtering options for transactions
///
/// Allows filtering by:
/// - Transaction type (Achat, Vente, Retour)
/// - Period (Today, This Week, This Month, etc.)
///
/// Requirements: 2.6, 2.7
class TransactionFilters extends StatelessWidget {
  final String? selectedType;
  final Period selectedPeriod;
  final Function(String?) onTypeChanged;
  final Function(Period) onPeriodChanged;

  const TransactionFilters({
    super.key,
    required this.selectedType,
    required this.selectedPeriod,
    required this.onTypeChanged,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundPrimary,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type filter
          _buildTypeFilter(),

          const SizedBox(height: 16),

          // Period filter
          _buildPeriodFilter(),
        ],
      ),
    );
  }

  /// Build the transaction type filter
  ///
  /// Shows chips for All, Achat, Vente, Retour
  ///
  /// Requirements: 2.6
  Widget _buildTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type de transaction',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTypeChip('Tous', null),
            _buildTypeChip('Achat', 'achat'),
            _buildTypeChip('Vente', 'vente'),
            _buildTypeChip('Retour', 'retour'),
          ],
        ),
      ],
    );
  }

  /// Build a single type filter chip
  Widget _buildTypeChip(String label, String? value) {
    final isSelected = selectedType == value;

    return GestureDetector(
      onTap: () => onTypeChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue
              : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  /// Build the period filter
  ///
  /// Shows dropdown for period selection
  ///
  /// Requirements: 2.7
  Widget _buildPeriodFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Période',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: DropdownButton<PeriodType>(
            value: selectedPeriod.type,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.arrow_drop_down),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            items: [
              DropdownMenuItem(
                value: PeriodType.today,
                child: Text(_getPeriodLabel(PeriodType.today)),
              ),
              DropdownMenuItem(
                value: PeriodType.thisWeek,
                child: Text(_getPeriodLabel(PeriodType.thisWeek)),
              ),
              DropdownMenuItem(
                value: PeriodType.thisMonth,
                child: Text(_getPeriodLabel(PeriodType.thisMonth)),
              ),
              DropdownMenuItem(
                value: PeriodType.thisYear,
                child: Text(_getPeriodLabel(PeriodType.thisYear)),
              ),
              DropdownMenuItem(
                value: PeriodType.all,
                child: Text(_getPeriodLabel(PeriodType.all)),
              ),
            ],
            onChanged: (PeriodType? newType) {
              if (newType != null) {
                onPeriodChanged(_createPeriod(newType));
              }
            },
          ),
        ),
      ],
    );
  }

  /// Get human-readable label for period type
  String _getPeriodLabel(PeriodType type) {
    switch (type) {
      case PeriodType.today:
        return 'Aujourd\'hui';
      case PeriodType.thisWeek:
        return 'Cette semaine';
      case PeriodType.thisMonth:
        return 'Ce mois';
      case PeriodType.thisYear:
        return 'Cette année';
      case PeriodType.all:
        return 'Toutes les périodes';
      case PeriodType.custom:
        return 'Personnalisée';
    }
  }

  /// Create a Period instance from PeriodType
  Period _createPeriod(PeriodType type) {
    switch (type) {
      case PeriodType.today:
        return Period.today();
      case PeriodType.thisWeek:
        return Period.thisWeek();
      case PeriodType.thisMonth:
        return Period.thisMonth();
      case PeriodType.thisYear:
        return Period.thisYear();
      case PeriodType.all:
        return Period.all();
      case PeriodType.custom:
        // For custom, we'd need date pickers - not implemented in this task
        return Period.all();
    }
  }
}
