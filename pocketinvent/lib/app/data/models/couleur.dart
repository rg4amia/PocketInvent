import 'package:hive/hive.dart';

part 'couleur.g.dart';

@HiveType(typeId: 9)
class Couleur extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String libelle;

  @HiveField(2)
  String? codeCouleur;

  Couleur({
    required this.id,
    required this.libelle,
    this.codeCouleur,
  });

  factory Couleur.fromJson(Map<String, dynamic> json) {
    return Couleur(
      id: json['id'] as String,
      libelle: json['libelle'] as String,
      codeCouleur: json['code_couleur'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'code_couleur': codeCouleur,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'libelle': libelle,
      'code_couleur': codeCouleur,
    };
  }
}
