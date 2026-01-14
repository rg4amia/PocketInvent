import 'package:hive/hive.dart';

part 'fournisseur.g.dart';

@HiveType(typeId: 5)
class Fournisseur extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  String nom;

  @HiveField(3)
  String? telephone;

  @HiveField(4)
  String? email;

  @HiveField(5)
  String? photoIdentiteUrl;

  Fournisseur({
    required this.id,
    required this.userId,
    required this.nom,
    this.telephone,
    this.email,
    this.photoIdentiteUrl,
  });

  factory Fournisseur.fromJson(Map<String, dynamic> json) {
    return Fournisseur(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      nom: json['nom'] as String,
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
      photoIdentiteUrl: json['photo_identite_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nom': nom,
      'telephone': telephone,
      'email': email,
      'photo_identite_url': photoIdentiteUrl,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'nom': nom,
      'telephone': telephone,
      'email': email,
      'photo_identite_url': photoIdentiteUrl,
    };
  }
}
