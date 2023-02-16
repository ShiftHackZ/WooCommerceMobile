import 'package:hive/hive.dart';

part 'wish_list_cache_item.g.dart';

@HiveType(typeId: 7)
class WishListCacheItem {
  @HiveField(0)
  String itemId;
  @HiveField(1)
  int productId;

  WishListCacheItem(this.itemId, this.productId);
}
