// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_active.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActiveFilterAdapter extends TypeAdapter<ActiveFilter> {
  @override
  final int typeId = 5;

  @override
  ActiveFilter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActiveFilter(
      fields[0] as int,
      fields[1] as String,
      (fields[2] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ActiveFilter obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.slug)
      ..writeByte(2)
      ..write(obj.termIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
