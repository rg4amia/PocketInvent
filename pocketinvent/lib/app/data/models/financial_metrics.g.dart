// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_metrics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinancialMetricsAdapter extends TypeAdapter<FinancialMetrics> {
  @override
  final int typeId = 3;

  @override
  FinancialMetrics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinancialMetrics(
      totalEntrees: fields[0] as double,
      totalSorties: fields[1] as double,
      profitNet: fields[2] as double,
      margeBeneficiaire: fields[3] as double,
      valeurStock: fields[4] as double,
      nombreEnStock: fields[5] as int,
      nombreVendus: fields[6] as int,
      nombreRetournes: fields[7] as int,
      period: fields[8] as Period,
    );
  }

  @override
  void write(BinaryWriter writer, FinancialMetrics obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.totalEntrees)
      ..writeByte(1)
      ..write(obj.totalSorties)
      ..writeByte(2)
      ..write(obj.profitNet)
      ..writeByte(3)
      ..write(obj.margeBeneficiaire)
      ..writeByte(4)
      ..write(obj.valeurStock)
      ..writeByte(5)
      ..write(obj.nombreEnStock)
      ..writeByte(6)
      ..write(obj.nombreVendus)
      ..writeByte(7)
      ..write(obj.nombreRetournes)
      ..writeByte(8)
      ..write(obj.period);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialMetricsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
