// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marque.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MarqueAdapter extends TypeAdapter<Marque> {
  @override
  final int typeId = 7;

  @override
  Marque read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Marque(
      id: fields[0] as String,
      nom: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Marque obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarqueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
