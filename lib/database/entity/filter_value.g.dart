// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_value.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilterValueAdapter extends TypeAdapter<FilterValue> {
  @override
  final int typeId = 4;

  @override
  FilterValue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FilterValue(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FilterValue obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slug);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterValueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
