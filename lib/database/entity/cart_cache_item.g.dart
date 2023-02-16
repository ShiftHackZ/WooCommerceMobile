// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_cache_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartCacheItemAdapter extends TypeAdapter<CartCacheItem> {
  @override
  final int typeId = 6;

  @override
  CartCacheItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartCacheItem(
      fields[0] as int,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CartCacheItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartCacheItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
