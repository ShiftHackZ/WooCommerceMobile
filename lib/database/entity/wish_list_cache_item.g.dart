// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_list_cache_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishListCacheItemAdapter extends TypeAdapter<WishListCacheItem> {
  @override
  final int typeId = 7;

  @override
  WishListCacheItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishListCacheItem(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WishListCacheItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.productId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishListCacheItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
