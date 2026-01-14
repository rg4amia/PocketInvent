import '../models/financial_metrics.dart';
import '../models/period.dart';
import '../models/telephone_model.dart';
import '../models/transaction_model.dart';

/// Service for calculating financial metrics based on transactions and phones
class FinancialCalculator {
  /// Calculate financial metrics for a given period
  ///
  /// Takes a list of transactions, phones, and a period, and returns
  /// comprehensive financial metrics including revenues, expenses, profit,
  /// margin, and stock statistics.
  FinancialMetrics calculateMetrics({
    required List<TransactionModel> transactions,
    required List<TelephoneModel> phones,
    required Period period,
  }) {
    // Filter transactions by period
    final filteredTransactions = _filterByPeriod(transactions, period);

    // Calculate financial totals
    final totalEntrees = _calculateTotalEntrees(filteredTransactions);
    final totalSorties = _calculateTotalSorties(filteredTransactions);
    final profitNet = totalSorties - totalEntrees;
    final margeBeneficiaire =
        totalEntrees > 0 ? (profitNet / totalEntrees) * 100 : 0.0;

    // Calculate stock statistics
    final valeurStock = _calculateStockValue(phones);
    final nombreEnStock =
        phones.where((p) => p.stockStatus == StockStatus.enStock).length;

    // Count transactions in period
    final nombreVendus = _countSoldInPeriod(filteredTransactions);
    final nombreRetournes = _countReturnsInPeriod(filteredTransactions);

    return FinancialMetrics(
      totalEntrees: totalEntrees,
      totalSorties: totalSorties,
      profitNet: profitNet,
      margeBeneficiaire: margeBeneficiaire,
      valeurStock: valeurStock,
      nombreEnStock: nombreEnStock,
      nombreVendus: nombreVendus,
      nombreRetournes: nombreRetournes,
      period: period,
    );
  }

  /// Calculate total purchases (entrées) from transactions
  ///
  /// Sums all transaction amounts where type is "Achat"
  /// Requirements: 1.2, 6.7
  double _calculateTotalEntrees(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.typeTransaction.toLowerCase() == 'achat')
        .fold(0.0, (sum, t) => sum + t.montant);
  }

  /// Calculate total sales (sorties) from transactions
  ///
  /// Sums all sale transactions and subtracts return transactions
  /// Returns are deducted from total sales as they represent refunds
  /// Requirements: 1.3, 6.3, 6.6
  double _calculateTotalSorties(List<TransactionModel> transactions) {
    final ventes = transactions
        .where((t) => t.typeTransaction.toLowerCase() == 'vente')
        .fold(0.0, (sum, t) => sum + t.montant);

    final retours = transactions
        .where((t) => t.typeTransaction.toLowerCase() == 'retour')
        .fold(0.0, (sum, t) => sum + t.montant);

    // Returns reduce the total sales (refunds)
    return ventes - retours;
  }

  /// Calculate the total value of current stock
  ///
  /// Sums the purchase price (prix_achat) of all phones with status "enStock"
  /// Requirements: 1.10, 6.5
  double _calculateStockValue(List<TelephoneModel> phones) {
    return phones
        .where((p) => p.stockStatus == StockStatus.enStock)
        .fold(0.0, (sum, p) => sum + p.prixAchat);
  }

  /// Filter transactions by the given period
  ///
  /// Returns only transactions whose date falls within the period's date range
  /// Requirements: 7.2, 7.4
  List<TransactionModel> _filterByPeriod(
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

  /// Count the number of sales in the filtered transactions
  int _countSoldInPeriod(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.typeTransaction.toLowerCase() == 'vente')
        .length;
  }

  /// Count the number of returns in the filtered transactions
  int _countReturnsInPeriod(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.typeTransaction.toLowerCase() == 'retour')
        .length;
  }
}
