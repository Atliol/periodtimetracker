// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuideModelAdapter extends TypeAdapter<GuideModel> {
  @override
  final int typeId = 0;

  @override
  GuideModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuideModel(
      title: fields[0] as String,
      content: fields[1] as String,
      category: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GuideModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuideModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
