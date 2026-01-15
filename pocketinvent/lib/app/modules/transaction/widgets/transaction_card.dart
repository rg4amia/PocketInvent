import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/telephone_model.dart';
import '../../../core/theme/app_colors.dart';

/// Widget that displays a single transaction in a card format
///
/// Shows:
/// - Transaction type with icon and color
/// - Amount (green for sales, red for purchases)
/// - Phone details (brand, model, IMEI)
/// - Associated party (supplier or client)
/// - Transaction date
///
/// Requirements: 2.2, 2.3, 2.4, 2.5
class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final TelephoneModel? phone;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Type and Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTypeChip(),
                _buildAmount(),
              ],
            ),
            const SizedBox(height: 12),

            // Phone details
            if (phone != null) _buildPhoneDetails(),

            const SizedBox(height: 8),

            // Party (supplier or client)
            _buildParty(),

            const SizedBox(height: 8),

            // Date
            _buildDate(),
          ],
        ),
      ),
    );
  }

  /// Build the transaction type chip with icon and color
  ///
  /// Requirements: 2.2
  Widget _buildTypeChip() {
    final typeData = _getTypeData();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: typeData['color'].withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            typeData['icon'],
            size: 16,
            color: typeData['color'],
          ),
          const SizedBox(width: 6),
          Text(
            typeData['label'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: typeData['color'],
            ),
          ),
        ],
      ),
    );
  }

  /// Get type-specific data (icon, color, label)
  Map<String, dynamic> _getTypeData() {
    final type = transaction.typeTransaction.toLowerCase();

    switch (type) {
      case 'achat':
        return {
          'icon': Icons.shopping_cart_rounded,
          'color': AppColors.deleteAccent,
          'label': 'Achat',
        };
      case 'vente':
        return {
          'icon': Icons.sell_rounded,
          'color': AppColors.successAccent,
          'label': 'Vente',
        };
      case 'retour':
        return {
          'icon': Icons.keyboard_return_rounded,
          'color': Colors.orange,
          'label': 'Retour',
        };
      default:
        return {
          'icon': Icons.receipt_rounded,
          'color': AppColors.textSecondary,
          'label': type,
        };
    }
  }

  /// Build the amount display with color coding
  ///
  /// Green for sales (income), red for purchases/returns (expenses)
  ///
  /// Requirements: 2.3
  Widget _buildAmount() {
    final isIncome = transaction.typeTransaction.toLowerCase() == 'vente';
    final color = isIncome ? AppColors.successAccent : AppColors.deleteAccent;
    final sign = isIncome ? '+' : '-';

    return Text(
      '$sign${_formatAmount(transaction.montant)}',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  /// Format amount with 2 decimals and currency symbol
  String _formatAmount(double amount) {
    return '${amount.toStringAsFixed(2)} €';
  }

  /// Build phone details section
  ///
  /// Shows brand, model, and IMEI
  ///
  /// Requirements: 2.4
  Widget _buildPhoneDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.phone_iphone_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Téléphone',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${phone!.marqueName} ${phone!.modeleName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'IMEI: ${phone!.imei}',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  /// Build party section (supplier or client)
  ///
  /// Requirements: 2.5
  Widget _buildParty() {
    final isSupplier = transaction.fournisseurName != null;
    final partyName =
        isSupplier ? transaction.fournisseurName : transaction.clientName;
    final partyLabel = isSupplier ? 'Fournisseur' : 'Client';
    final icon = isSupplier ? Icons.store_rounded : Icons.person_rounded;

    if (partyName == null) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          '$partyLabel: ',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            partyName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Build date section
  ///
  /// Requirements: 2.5
  Widget _buildDate() {
    final formattedDate =
        DateFormat('dd/MM/yyyy à HH:mm').format(transaction.dateTransaction);

    return Row(
      children: [
        Icon(
          Icons.calendar_today_rounded,
          size: 14,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          formattedDate,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
