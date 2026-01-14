// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capacite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CapaciteAdapter extends TypeAdapter<Capacite> {
  @override
  final int typeId = 10;

  @override
  Capacite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Capacite(
      id: fields[0] as String,
      valeur: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Capacite obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.valeur);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CapaciteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
