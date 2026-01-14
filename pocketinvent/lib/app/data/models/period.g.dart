// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PeriodAdapter extends TypeAdapter<Period> {
  @override
  final int typeId = 5;

  @override
  Period read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Period(
      type: fields[0] as PeriodType,
      startDate: fields[1] as DateTime?,
      endDate: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Period obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PeriodTypeAdapter extends TypeAdapter<PeriodType> {
  @override
  final int typeId = 4;

  @override
  PeriodType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PeriodType.today;
      case 1:
        return PeriodType.thisWeek;
      case 2:
        return PeriodType.thisMonth;
      case 3:
        return PeriodType.thisYear;
      case 4:
        return PeriodType.all;
      case 5:
        return PeriodType.custom;
      default:
        return PeriodType.today;
    }
  }

  @override
  void write(BinaryWriter writer, PeriodType obj) {
    switch (obj) {
      case PeriodType.today:
        writer.writeByte(0);
        break;
      case PeriodType.thisWeek:
        writer.writeByte(1);
        break;
      case PeriodType.thisMonth:
        writer.writeByte(2);
        break;
      case PeriodType.thisYear:
        writer.writeByte(3);
        break;
      case PeriodType.all:
        writer.writeByte(4);
        break;
      case PeriodType.custom:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
