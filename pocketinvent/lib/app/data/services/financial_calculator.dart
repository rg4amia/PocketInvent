import 'dart:isolate';
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
  ///
  /// For large datasets (>100 transactions), calculations are performed
  /// in a separate isolate to avoid blocking the UI thread.
  ///
  /// Requirements: 9.2
  Future<FinancialMetrics> calculateMetrics({
    required List<TransactionModel> transactions,
    required List<TelephoneModel> phones,
    required Period period,
  }) async {
    // For small datasets, calculate directly
    if (transactions.length <= 100) {
      return _calculateMetricsSync(
        transactions: transactions,
        phones: phones,
        period: period,
      );
    }

    // For large datasets, use isolate
    return await _calculateMetricsInIsolate(
      transactions: transactions,
      phones: phones,
      period: period,
    );
  }

  /// Calculate metrics in a separate isolate for better performance
  ///
  /// Requirements: 9.2
  Future<FinancialMetrics> _calculateMetricsInIsolate({
    required List<TransactionModel> transactions,
    required List<TelephoneModel> phones,
    required Period period,
  }) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _isolateCalculateMetrics,
      _IsolateData(
        sendPort: receivePort.sendPort,
        transactions: transactions,
        phones: phones,
        period: period,
      ),
    );

    final result = await receivePort.first as FinancialMetrics;
    return result;
  }

  /// Isolate entry point for metrics calculation
  static void _isolateCalculateMetrics(_IsolateData data) {
    final calculator = FinancialCalculator();
    final metrics = calculator._calculateMetricsSync(
      transactions: data.transactions,
      phones: data.phones,
      period: data.period,
    );
    data.sendPort.send(metrics);
  }

  /// Synchronous calculation of metrics (used by both direct and isolate methods)
  FinancialMetrics _calculateMetricsSync({
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

/// Data class for passing data to isolate
class _IsolateData {
  final SendPort sendPort;
  final List<TransactionModel> transactions;
  final List<TelephoneModel> phones;
  final Period period;

  _IsolateData({
    required this.sendPort,
    required this.transactions,
    required this.phones,
    required this.period,
  });
}
