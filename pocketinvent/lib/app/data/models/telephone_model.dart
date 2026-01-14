import 'package:hive/hive.dart';

part 'telephone_model.g.dart';

@HiveType(typeId: 2)
enum StockStatus {
  @HiveField(0)
  enStock,
  @HiveField(1)
  vendu,
  @HiveField(2)
  retourne,
}

@HiveType(typeId: 0)
class TelephoneModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String imei;

  @HiveField(3)
  String marqueId;

  @HiveField(4)
  String marqueName;

  @HiveField(5)
  String modeleId;

  @HiveField(6)
  String modeleName;

  @HiveField(7)
  String couleurId;

  @HiveField(8)
  String couleurName;

  @HiveField(9)
  String capaciteId;

  @HiveField(10)
  String capaciteValue;

  @HiveField(11)
  String? fournisseurId;

  @HiveField(12)
  String? fournisseurName;

  @HiveField(13)
  double prixAchat;

  @HiveField(14)
  double? prixVente;

  @HiveField(15)
  String statutPaiementId;

  @HiveField(16)
  String statutPaiementLibelle;

  @HiveField(17)
  DateTime dateEntree;

  @HiveField(18)
  String? photoUrl;

  @HiveField(19)
  DateTime createdAt;

  @HiveField(20)
  DateTime updatedAt;

  @HiveField(21)
  StockStatus stockStatus;

  TelephoneModel({
    required this.id,
    required this.userId,
    required this.imei,
    required this.marqueId,
    required this.marqueName,
    required this.modeleId,
    required this.modeleName,
    required this.couleurId,
    required this.couleurName,
    required this.capaciteId,
    required this.capaciteValue,
    this.fournisseurId,
    this.fournisseurName,
    required this.prixAchat,
    this.prixVente,
    required this.statutPaiementId,
    required this.statutPaiementLibelle,
    required this.dateEntree,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.stockStatus = StockStatus.enStock,
  });

  // Calculated properties
  double? get profit => prixVente != null ? prixVente! - prixAchat : null;

  double? get marginPercentage =>
      profit != null && prixAchat > 0 ? (profit! / prixAchat) * 100 : null;

  bool get canBeSold =>
      stockStatus == StockStatus.enStock || stockStatus == StockStatus.retourne;

  factory TelephoneModel.fromJson(Map<String, dynamic> json) {
    return TelephoneModel(
      id: json['id'],
      userId: json['user_id'],
      imei: json['imei'],
      marqueId: json['marque_id'],
      marqueName: json['marque']?['nom'] ?? '',
      modeleId: json['modele_id'],
      modeleName: json['modele']?['nom'] ?? '',
      couleurId: json['couleur_id'],
      couleurName: json['couleur']?['libelle'] ?? '',
      capaciteId: json['capacite_id'],
      capaciteValue: json['capacite']?['valeur'] ?? '',
      fournisseurId: json['fournisseur_id'],
      fournisseurName: json['fournisseur']?['nom'],
      prixAchat: (json['prix_achat'] as num).toDouble(),
      prixVente: json['prix_vente'] != null
          ? (json['prix_vente'] as num).toDouble()
          : null,
      statutPaiementId: json['statut_paiement_id'],
      statutPaiementLibelle: json['statut_paiement']?['libelle'] ?? '',
      dateEntree: DateTime.parse(json['date_entree']),
      photoUrl: json['photo_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      stockStatus: _parseStockStatus(json['stock_status']),
    );
  }

  static StockStatus _parseStockStatus(dynamic value) {
    if (value == null) return StockStatus.enStock;

    final statusStr = value.toString().toLowerCase();
    switch (statusStr) {
      case 'vendu':
        return StockStatus.vendu;
      case 'retourne':
        return StockStatus.retourne;
      case 'enstock':
      default:
        return StockStatus.enStock;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'imei': imei,
      'marque_id': marqueId,
      'modele_id': modeleId,
      'couleur_id': couleurId,
      'capacite_id': capaciteId,
      'fournisseur_id': fournisseurId,
      'prix_achat': prixAchat,
      'prix_vente': prixVente,
      'statut_paiement_id': statutPaiementId,
      'date_entree': dateEntree.toIso8601String(),
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'stock_status': _stockStatusToString(stockStatus),
    };
  }

  static String _stockStatusToString(StockStatus status) {
    switch (status) {
      case StockStatus.enStock:
        return 'enStock';
      case StockStatus.vendu:
        return 'vendu';
      case StockStatus.retourne:
        return 'retourne';
    }
  }
}
