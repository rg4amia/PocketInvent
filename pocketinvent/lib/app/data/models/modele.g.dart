// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modele.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModeleAdapter extends TypeAdapter<Modele> {
  @override
  final int typeId = 8;

  @override
  Modele read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Modele(
      id: fields[0] as String,
      nom: fields[1] as String,
      marqueId: fields[2] as String,
      marqueNom: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Modele obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.marqueId)
      ..writeByte(3)
      ..write(obj.marqueNom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModeleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
