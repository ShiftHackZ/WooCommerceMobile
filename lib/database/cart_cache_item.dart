import 'package:hive/hive.dart';

part 'cart_cache_item.g.dart';

@HiveType(typeId: 6)
class CartCacheItem {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;

  CartCacheItem(this.id, this.name);
}
