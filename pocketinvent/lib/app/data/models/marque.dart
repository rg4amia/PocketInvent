import 'package:hive/hive.dart';

part 'marque.g.dart';

@HiveType(typeId: 7)
class Marque extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String nom;

  Marque({
    required this.id,
    required this.nom,
  });

  factory Marque.fromJson(Map<String, dynamic> json) {
    return Marque(
      id: json['id'] as String,
      nom: json['nom'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'nom': nom,
    };
  }
}
