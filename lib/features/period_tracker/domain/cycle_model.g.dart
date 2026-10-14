// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CycleModelAdapter extends TypeAdapter<CycleModel> {
  @override
  final int typeId = 0;

  @override
  CycleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CycleModel(
      startDate: fields[0] as DateTime,
      endDate: fields[1] as DateTime,
      note: fields[2] as String,
      isPeriod: fields[3] as bool,
      isOvulation: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CycleModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.endDate)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.isPeriod)
      ..writeByte(4)
      ..write(obj.isOvulation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CycleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
