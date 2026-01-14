import 'package:hive/hive.dart';

part 'statut_paiement.g.dart';

@HiveType(typeId: 11)
class StatutPaiement extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String libelle;

  StatutPaiement({
    required this.id,
    required this.libelle,
  });

  factory StatutPaiement.fromJson(Map<String, dynamic> json) {
    return StatutPaiement(
      id: json['id'] as String,
      libelle: json['libelle'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'libelle': libelle,
    };
  }
}
