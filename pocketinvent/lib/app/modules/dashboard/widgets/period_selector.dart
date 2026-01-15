import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/period.dart';
import '../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

/// Widget for selecting time periods for financial data filtering
///
/// Displays predefined periods (Today, This Week, This Month, This Year, All)
/// and allows custom period selection with date pickers.
///
/// Requirements: 7.1, 7.2, 7.3
class PeriodSelector extends StatelessWidget {
  final Period selectedPeriod;
  final Function(Period) onPeriodChanged;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
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
            'Période',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPeriodChip(
                label: 'Aujourd\'hui',
                period: Period.today(),
                isSelected: selectedPeriod.type == PeriodType.today,
              ),
              _buildPeriodChip(
                label: 'Cette semaine',
                period: Period.thisWeek(),
                isSelected: selectedPeriod.type == PeriodType.thisWeek,
              ),
              _buildPeriodChip(
                label: 'Ce mois',
                period: Period.thisMonth(),
                isSelected: selectedPeriod.type == PeriodType.thisMonth,
              ),
              _buildPeriodChip(
                label: 'Cette année',
                period: Period.thisYear(),
                isSelected: selectedPeriod.type == PeriodType.thisYear,
              ),
              _buildPeriodChip(
                label: 'Tout',
                period: Period.all(),
                isSelected: selectedPeriod.type == PeriodType.all,
              ),
              _buildCustomPeriodChip(),
            ],
          ),
          if (selectedPeriod.type == PeriodType.custom)
            _buildCustomPeriodDisplay(),
        ],
      ),
    );
  }

  /// Build a period selection chip
  Widget _buildPeriodChip({
    required String label,
    required Period period,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onPeriodChanged(period),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.cardBackground,
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
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Build the custom period chip that opens date picker
  Widget _buildCustomPeriodChip() {
    final isSelected = selectedPeriod.type == PeriodType.custom;

    return GestureDetector(
      onTap: _showCustomPeriodDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              'Personnalisé',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Display the selected custom period dates
  Widget _buildCustomPeriodDisplay() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startDateStr = selectedPeriod.startDate != null
        ? dateFormat.format(selectedPeriod.startDate!)
        : 'N/A';
    final endDateStr = selectedPeriod.endDate != null
        ? dateFormat.format(selectedPeriod.endDate!)
        : 'N/A';

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.date_range,
              size: 20,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Du $startDateStr au $endDateStr',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 20,
                color: AppColors.primaryBlue,
              ),
              onPressed: _showCustomPeriodDialog,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  /// Show dialog to select custom date range
  ///
  /// Requirements: 7.3
  Future<void> _showCustomPeriodDialog() async {
    DateTime? startDate = selectedPeriod.startDate ?? DateTime.now();
    DateTime? endDate = selectedPeriod.endDate ?? DateTime.now();

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Période personnalisée',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              _buildDateSelector(
                label: 'Date de début',
                date: startDate,
                onDateSelected: (date) {
                  startDate = date;
                },
              ),
              const SizedBox(height: 16),
              _buildDateSelector(
                label: 'Date de fin',
                date: endDate,
                onDateSelected: (date) {
                  endDate = date;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Annuler',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (startDate != null && endDate != null) {
                        if (startDate!.isAfter(endDate!)) {
                          Get.snackbar(
                            'Erreur',
                            'La date de début doit être avant la date de fin',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.deleteAccent,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        onPeriodChanged(Period.custom(startDate!, endDate!));
                        Get.back();
                      }
                    },
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
                    child: const Text(
                      'Appliquer',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a date selector button
  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required Function(DateTime) onDateSelected,
  }) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: Get.context!,
              initialDate: date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primaryBlue,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: AppColors.textPrimary,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 12),
                Text(
                  dateFormat.format(date),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
