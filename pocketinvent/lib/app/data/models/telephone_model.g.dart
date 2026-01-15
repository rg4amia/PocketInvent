// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telephone_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TelephoneModelAdapter extends TypeAdapter<TelephoneModel> {
  @override
  final int typeId = 0;

  @override
  TelephoneModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TelephoneModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      imei: fields[2] as String,
      marqueId: fields[3] as String,
      marqueName: fields[4] as String,
      modeleId: fields[5] as String,
      modeleName: fields[6] as String,
      couleurId: fields[7] as String,
      couleurName: fields[8] as String,
      capaciteId: fields[9] as String,
      capaciteValue: fields[10] as String,
      fournisseurId: fields[11] as String?,
      fournisseurName: fields[12] as String?,
      prixAchat: fields[13] as double,
      prixVente: fields[14] as double?,
      statutPaiementId: fields[15] as String,
      statutPaiementLibelle: fields[16] as String,
      dateEntree: fields[17] as DateTime,
      photoUrl: fields[18] as String?,
      createdAt: fields[19] as DateTime,
      updatedAt: fields[20] as DateTime,
      stockStatus: fields[21] as StockStatus? ?? StockStatus.enStock,
    );
  }

  @override
  void write(BinaryWriter writer, TelephoneModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.imei)
      ..writeByte(3)
      ..write(obj.marqueId)
      ..writeByte(4)
      ..write(obj.marqueName)
      ..writeByte(5)
      ..write(obj.modeleId)
      ..writeByte(6)
      ..write(obj.modeleName)
      ..writeByte(7)
      ..write(obj.couleurId)
      ..writeByte(8)
      ..write(obj.couleurName)
      ..writeByte(9)
      ..write(obj.capaciteId)
      ..writeByte(10)
      ..write(obj.capaciteValue)
      ..writeByte(11)
      ..write(obj.fournisseurId)
      ..writeByte(12)
      ..write(obj.fournisseurName)
      ..writeByte(13)
      ..write(obj.prixAchat)
      ..writeByte(14)
      ..write(obj.prixVente)
      ..writeByte(15)
      ..write(obj.statutPaiementId)
      ..writeByte(16)
      ..write(obj.statutPaiementLibelle)
      ..writeByte(17)
      ..write(obj.dateEntree)
      ..writeByte(18)
      ..write(obj.photoUrl)
      ..writeByte(19)
      ..write(obj.createdAt)
      ..writeByte(20)
      ..write(obj.updatedAt)
      ..writeByte(21)
      ..write(obj.stockStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TelephoneModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StockStatusAdapter extends TypeAdapter<StockStatus> {
  @override
  final int typeId = 2;

  @override
  StockStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StockStatus.enStock;
      case 1:
        return StockStatus.vendu;
      case 2:
        return StockStatus.retourne;
      default:
        return StockStatus.enStock;
    }
  }

  @override
  void write(BinaryWriter writer, StockStatus obj) {
    switch (obj) {
      case StockStatus.enStock:
        writer.writeByte(0);
        break;
      case StockStatus.vendu:
        writer.writeByte(1);
        break;
      case StockStatus.retourne:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
