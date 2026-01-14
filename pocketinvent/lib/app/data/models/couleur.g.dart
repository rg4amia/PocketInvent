// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couleur.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CouleurAdapter extends TypeAdapter<Couleur> {
  @override
  final int typeId = 9;

  @override
  Couleur read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Couleur(
      id: fields[0] as String,
      libelle: fields[1] as String,
      codeCouleur: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Couleur obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.libelle)
      ..writeByte(2)
      ..write(obj.codeCouleur);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouleurAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
