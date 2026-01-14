import 'package:hive/hive.dart';

part 'capacite.g.dart';

@HiveType(typeId: 10)
class Capacite extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String valeur;

  Capacite({
    required this.id,
    required this.valeur,
  });

  factory Capacite.fromJson(Map<String, dynamic> json) {
    return Capacite(
      id: json['id'] as String,
      valeur: json['valeur'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valeur': valeur,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'valeur': valeur,
    };
  }
}
