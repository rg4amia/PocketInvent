import 'dart:io';
import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/transaction_model.dart';
import '../models/period.dart';
import '../models/financial_metrics.dart';

/// Service responsible for exporting transaction data and financial reports
/// to CSV and PDF formats.
///
/// Requirements: 10.1, 10.2, 10.3, 10.5
class ExportService extends GetxService {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  final DateFormat _filenameDateFormat = DateFormat('yyyy-MM');

  /// Exports transactions to a CSV file.
  ///
  /// The CSV includes all relevant columns: date, type, montant, IMEI, and party.
  /// The filename follows the convention: PocketInvent_Transactions_{period}.csv
  ///
  /// Requirements: 10.1, 10.2, 10.5
  Future<File> exportToCSV({
    required List<TransactionModel> transactions,
    required Period period,
  }) async {
    // Prepare CSV data
    final List<List<dynamic>> rows = [];

    // Add header row
    rows.add([
      'Date',
      'Type',
      'Montant (FCFA)',
      'IMEI',
      'Partie (Client/Fournisseur)',
      'Statut Paiement',
      'Notes',
    ]);

    // Add transaction rows
    for (final transaction in transactions) {
      rows.add([
        _dateFormat.format(transaction.dateTransaction),
        _formatTransactionType(transaction.typeTransaction),
        transaction.montant.toStringAsFixed(2),
        transaction.telephoneId, // IMEI would need to be fetched from phone
        _getPartyName(transaction),
        transaction.statutPaiementLibelle,
        transaction.notes ?? '',
      ]);
    }

    // Convert to CSV string
    final String csv = const ListToCsvConverter().convert(rows);

    // Generate filename
    final String filename = _generateFilename(period, 'csv');

    // Save to file
    final File file = await _saveToFile(csv, filename);

    return file;
  }

  /// Exports financial report to a PDF file.
  ///
  /// The PDF includes financial metrics, transaction summary, and charts.
  /// The filename follows the convention: PocketInvent_Report_{period}.pdf
  ///
  /// Requirements: 10.3, 10.5
  Future<File> exportToPDF({
    required List<TransactionModel> transactions,
    required FinancialMetrics metrics,
    required Period period,
  }) async {
    final pdf = pw.Document();

    // Add page with financial report
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title
              pw.Text(
                'PocketInvent - Rapport Financier',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              // Period
              pw.Text(
                'Période: ${_formatPeriod(period)}',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Généré le: ${_dateFormat.format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),

              // Financial Metrics Section
              pw.Text(
                'Métriques Financières',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              _buildMetricsTable(metrics),
              pw.SizedBox(height: 20),

              // Stock Statistics Section
              pw.Text(
                'Statistiques de Stock',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              _buildStockTable(metrics),
              pw.SizedBox(height: 20),

              // Transaction Summary
              pw.Text(
                'Résumé des Transactions',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Text(
                'Total des transactions: ${transactions.length}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Achats: ${transactions.where((t) => t.typeTransaction == 'achat').length}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Ventes: ${transactions.where((t) => t.typeTransaction == 'vente').length}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Retours: ${transactions.where((t) => t.typeTransaction == 'retour').length}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          );
        },
      ),
    );

    // Add transactions page if there are transactions
    if (transactions.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Liste des Transactions',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildTransactionsTable(transactions),
              ],
            );
          },
        ),
      );
    }

    // Generate filename
    final String filename = _generateFilename(period, 'pdf');

    // Save to file
    final bytes = await pdf.save();
    final File file = await _saveBytesToFile(bytes, filename);

    return file;
  }

  /// Builds a table widget for financial metrics in PDF
  pw.Widget _buildMetricsTable(FinancialMetrics metrics) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        _buildTableRow('Total Entrées (Achats)',
            '${metrics.totalEntrees.toStringAsFixed(2)} FCFA'),
        _buildTableRow('Total Sorties (Ventes)',
            '${metrics.totalSorties.toStringAsFixed(2)} FCFA'),
        _buildTableRow(
            'Profit Net', '${metrics.profitNet.toStringAsFixed(2)} FCFA'),
        _buildTableRow('Marge Bénéficiaire',
            '${metrics.margeBeneficiaire.toStringAsFixed(2)} %'),
      ],
    );
  }

  /// Builds a table widget for stock statistics in PDF
  pw.Widget _buildStockTable(FinancialMetrics metrics) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        _buildTableRow('Téléphones en Stock', '${metrics.nombreEnStock}'),
        _buildTableRow('Téléphones Vendus', '${metrics.nombreVendus}'),
        _buildTableRow('Téléphones Retournés', '${metrics.nombreRetournes}'),
        _buildTableRow('Valeur du Stock',
            '${metrics.valeurStock.toStringAsFixed(2)} FCFA'),
      ],
    );
  }

  /// Builds a table widget for transactions list in PDF
  pw.Widget _buildTransactionsTable(List<TransactionModel> transactions) {
    // Limit to first 50 transactions to avoid PDF size issues
    final limitedTransactions = transactions.take(50).toList();

    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('Date', isHeader: true),
            _buildTableCell('Type', isHeader: true),
            _buildTableCell('Montant', isHeader: true),
            _buildTableCell('Partie', isHeader: true),
          ],
        ),
        // Data rows
        ...limitedTransactions.map((transaction) {
          return pw.TableRow(
            children: [
              _buildTableCell(_dateFormat.format(transaction.dateTransaction)),
              _buildTableCell(
                  _formatTransactionType(transaction.typeTransaction)),
              _buildTableCell('${transaction.montant.toStringAsFixed(2)} FCFA'),
              _buildTableCell(_getPartyName(transaction)),
            ],
          );
        }),
      ],
    );
  }

  /// Helper to build a table row for metrics/stats
  pw.TableRow _buildTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value),
        ),
      ],
    );
  }

  /// Helper to build a table cell
  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  /// Formats transaction type for display
  String _formatTransactionType(String type) {
    switch (type.toLowerCase()) {
      case 'achat':
        return 'Achat';
      case 'vente':
        return 'Vente';
      case 'retour':
        return 'Retour';
      default:
        return type;
    }
  }

  /// Gets the party name (client or fournisseur) from transaction
  String _getPartyName(TransactionModel transaction) {
    if (transaction.clientName != null && transaction.clientName!.isNotEmpty) {
      return transaction.clientName!;
    }
    if (transaction.fournisseurName != null &&
        transaction.fournisseurName!.isNotEmpty) {
      return transaction.fournisseurName!;
    }
    return 'N/A';
  }

  /// Formats period for display in PDF
  String _formatPeriod(Period period) {
    switch (period.type) {
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
        if (period.startDate != null && period.endDate != null) {
          return '${DateFormat('dd/MM/yyyy').format(period.startDate!)} - ${DateFormat('dd/MM/yyyy').format(period.endDate!)}';
        }
        return 'Période personnalisée';
    }
  }

  /// Generates filename based on period and extension
  ///
  /// Format: PocketInvent_Transactions_{period}.csv or PocketInvent_Report_{period}.pdf
  ///
  /// Requirements: 10.5
  String _generateFilename(Period period, String extension) {
    final String prefix = extension == 'csv' ? 'Transactions' : 'Report';
    final String periodStr = _getPeriodString(period);

    return 'PocketInvent_${prefix}_$periodStr.$extension';
  }

  /// Gets period string for filename
  String _getPeriodString(Period period) {
    final now = DateTime.now();

    switch (period.type) {
      case PeriodType.today:
        return DateFormat('yyyy-MM-dd').format(now);
      case PeriodType.thisWeek:
        return '${_filenameDateFormat.format(now)}_Week${_getWeekNumber(now)}';
      case PeriodType.thisMonth:
        return _filenameDateFormat.format(now);
      case PeriodType.thisYear:
        return '${now.year}';
      case PeriodType.all:
        return 'All';
      case PeriodType.custom:
        if (period.startDate != null && period.endDate != null) {
          return '${DateFormat('yyyy-MM-dd').format(period.startDate!)}_to_${DateFormat('yyyy-MM-dd').format(period.endDate!)}';
        }
        return 'Custom';
    }
  }

  /// Gets week number of the year
  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil() + 1;
  }

  /// Saves string content to a file in the app's documents directory
  Future<File> _saveToFile(String content, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsString(content);
    return file;
  }

  /// Saves bytes to a file in the app's documents directory
  Future<File> _saveBytesToFile(List<int> bytes, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
