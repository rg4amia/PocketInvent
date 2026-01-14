import 'package:hive/hive.dart';
import 'period.dart';

part 'financial_metrics.g.dart';

@HiveType(typeId: 3)
class FinancialMetrics extends HiveObject {
  @HiveField(0)
  final double totalEntrees;

  @HiveField(1)
  final double totalSorties;

  @HiveField(2)
  final double profitNet;

  @HiveField(3)
  final double margeBeneficiaire;

  @HiveField(4)
  final double valeurStock;

  @HiveField(5)
  final int nombreEnStock;

  @HiveField(6)
  final int nombreVendus;

  @HiveField(7)
  final int nombreRetournes;

  @HiveField(8)
  final Period period;

  FinancialMetrics({
    required this.totalEntrees,
    required this.totalSorties,
    required this.profitNet,
    required this.margeBeneficiaire,
    required this.valeurStock,
    required this.nombreEnStock,
    required this.nombreVendus,
    required this.nombreRetournes,
    required this.period,
  });

  factory FinancialMetrics.fromJson(Map<String, dynamic> json) {
    return FinancialMetrics(
      totalEntrees: (json['total_entrees'] as num).toDouble(),
      totalSorties: (json['total_sorties'] as num).toDouble(),
      profitNet: (json['profit_net'] as num).toDouble(),
      margeBeneficiaire: (json['marge_beneficiaire'] as num).toDouble(),
      valeurStock: (json['valeur_stock'] as num).toDouble(),
      nombreEnStock: json['nombre_en_stock'] as int,
      nombreVendus: json['nombre_vendus'] as int,
      nombreRetournes: json['nombre_retournes'] as int,
      period: Period.fromJson(json['period']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_entrees': totalEntrees,
      'total_sorties': totalSorties,
      'profit_net': profitNet,
      'marge_beneficiaire': margeBeneficiaire,
      'valeur_stock': valeurStock,
      'nombre_en_stock': nombreEnStock,
      'nombre_vendus': nombreVendus,
      'nombre_retournes': nombreRetournes,
      'period': period.toJson(),
    };
  }

  FinancialMetrics copyWith({
    double? totalEntrees,
    double? totalSorties,
    double? profitNet,
    double? margeBeneficiaire,
    double? valeurStock,
    int? nombreEnStock,
    int? nombreVendus,
    int? nombreRetournes,
    Period? period,
  }) {
    return FinancialMetrics(
      totalEntrees: totalEntrees ?? this.totalEntrees,
      totalSorties: totalSorties ?? this.totalSorties,
      profitNet: profitNet ?? this.profitNet,
      margeBeneficiaire: margeBeneficiaire ?? this.margeBeneficiaire,
      valeurStock: valeurStock ?? this.valeurStock,
      nombreEnStock: nombreEnStock ?? this.nombreEnStock,
      nombreVendus: nombreVendus ?? this.nombreVendus,
      nombreRetournes: nombreRetournes ?? this.nombreRetournes,
      period: period ?? this.period,
    );
  }
}
