import 'package:hive/hive.dart';

part 'modele.g.dart';

@HiveType(typeId: 8)
class Modele extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String nom;

  @HiveField(2)
  final String marqueId;

  @HiveField(3)
  String? marqueNom;

  Modele({
    required this.id,
    required this.nom,
    required this.marqueId,
    this.marqueNom,
  });

  factory Modele.fromJson(Map<String, dynamic> json) {
    return Modele(
      id: json['id'] as String,
      nom: json['nom'] as String,
      marqueId: json['marque_id'] as String,
      marqueNom: json['marque_nom'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'marque_id': marqueId,
      'marque_nom': marqueNom,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'nom': nom,
      'marque_id': marqueId,
    };
  }
}
