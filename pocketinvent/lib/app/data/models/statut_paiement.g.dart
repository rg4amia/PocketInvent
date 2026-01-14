// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statut_paiement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatutPaiementAdapter extends TypeAdapter<StatutPaiement> {
  @override
  final int typeId = 11;

  @override
  StatutPaiement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatutPaiement(
      id: fields[0] as String,
      libelle: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StatutPaiement obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.libelle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatutPaiementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
