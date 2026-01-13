import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String telephoneId;

  @HiveField(3)
  String typeTransaction;

  @HiveField(4)
  String? clientId;

  @HiveField(5)
  String? clientName;

  @HiveField(6)
  String? fournisseurId;

  @HiveField(7)
  String? fournisseurName;

  @HiveField(8)
  double montant;

  @HiveField(9)
  String statutPaiementId;

  @HiveField(10)
  String statutPaiementLibelle;

  @HiveField(11)
  DateTime dateTransaction;

  @HiveField(12)
  String? notes;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.telephoneId,
    required this.typeTransaction,
    this.clientId,
    this.clientName,
    this.fournisseurId,
    this.fournisseurName,
    required this.montant,
    required this.statutPaiementId,
    required this.statutPaiementLibelle,
    required this.dateTransaction,
    this.notes,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      telephoneId: json['telephone_id'],
      typeTransaction: json['type_transaction'],
      clientId: json['client_id'],
      clientName: json['client']?['nom'],
      fournisseurId: json['fournisseur_id'],
      fournisseurName: json['fournisseur']?['nom'],
      montant: (json['montant'] as num).toDouble(),
      statutPaiementId: json['statut_paiement_id'],
      statutPaiementLibelle: json['statut_paiement']?['libelle'] ?? '',
      dateTransaction: DateTime.parse(json['date_transaction']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'telephone_id': telephoneId,
      'type_transaction': typeTransaction,
      'client_id': clientId,
      'fournisseur_id': fournisseurId,
      'montant': montant,
      'statut_paiement_id': statutPaiementId,
      'date_transaction': dateTransaction.toIso8601String(),
      'notes': notes,
    };
  }
}
