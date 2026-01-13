// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      telephoneId: fields[2] as String,
      typeTransaction: fields[3] as String,
      clientId: fields[4] as String?,
      clientName: fields[5] as String?,
      fournisseurId: fields[6] as String?,
      fournisseurName: fields[7] as String?,
      montant: fields[8] as double,
      statutPaiementId: fields[9] as String,
      statutPaiementLibelle: fields[10] as String,
      dateTransaction: fields[11] as DateTime,
      notes: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.telephoneId)
      ..writeByte(3)
      ..write(obj.typeTransaction)
      ..writeByte(4)
      ..write(obj.clientId)
      ..writeByte(5)
      ..write(obj.clientName)
      ..writeByte(6)
      ..write(obj.fournisseurId)
      ..writeByte(7)
      ..write(obj.fournisseurName)
      ..writeByte(8)
      ..write(obj.montant)
      ..writeByte(9)
      ..write(obj.statutPaiementId)
      ..writeByte(10)
      ..write(obj.statutPaiementLibelle)
      ..writeByte(11)
      ..write(obj.dateTransaction)
      ..writeByte(12)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
