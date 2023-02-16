import 'package:hive_flutter/hive_flutter.dart';
import 'package:wooapp/core/pair.dart';
import 'package:wooapp/database/entity/cart_cache_item.dart';
import 'package:wooapp/database/entity/filter.dart';
import 'package:wooapp/database/entity/filter_active.dart';
import 'package:wooapp/database/entity/filter_value.dart';
import 'package:wooapp/database/entity/product.dart';
import 'package:wooapp/database/entity/user.dart';
import 'package:wooapp/database/entity/wish_list_cache_item.dart';
import 'package:wooapp/model/attribute.dart';
import 'package:wooapp/model/product.dart';

/// WooApp local database orchestrator.
/// Docs: https://docs.hivedb.dev/
///
/// To generate adapters, execute:
/// flutter packages pub run build_runner build
class AppDb {
  static const String boxUser = 'box_user';
  static const String boxViewedProduct = 'box_viewed';
  static const String boxFilters = 'box_filters';
  static const String boxApplied = 'box_applied';
  static const String boxCartCache = 'box_cart_cache';
  static const String boxWishListCache = 'box_wish_list_cache';

  static const String keyUser = 'key_user';
  static const String keyViewedProduct = 'key_viewed';
  static const String keyFilter = 'key_viewed';
  static const String keyApplied = 'key_applied';
  static const String keyCart = 'key_cart';
  static const String keyWishList = 'key_wish_list';

  Future<void> clear() async {
    // var box1 = await Hive.openBox(boxUser);
    // var box2 = await Hive.openBox(boxViewedProduct);
    // await box1.clear();
    // await box2.clear();
    // box1.close();
    // return box2.close();
    await Hive.deleteFromDisk();
  }

  Future<bool> isActiveFilter(int filterId, int valueId) async {
    var box = await Hive.openBox(boxApplied);
    if (box.containsKey('$keyApplied$filterId')) {
      var applied = box.get('$keyApplied$filterId') as ActiveFilter;
      if (applied.termIds.contains(valueId)) return true;
      //return false;
    }
    return false;
  }

  Future<List<ActiveFilter>> getActiveFilters() async {
    var box = await Hive.openBox(boxApplied);
    return box.values.toList().cast();
  }

  Future<void> applyFilter(Filter filter, FilterValue value) async {
    var box = await Hive.openBox(boxApplied);
    if (box.containsKey('$keyApplied${filter.id}')) {
      var applied = (box.get('$keyApplied${filter.id}') as ActiveFilter);
      if (!applied.termIds.contains(value.id)) {
        applied.termIds.add(value.id);
      }
      box.put('$keyApplied${filter.id}', applied);
    } else {
      box.put('$keyApplied${filter.id}', ActiveFilter(filter.id, filter.slug, [value.id]));
    }
  }

  Future<void> removeFilter(Filter filter, FilterValue value) async {
    var box = await Hive.openBox(boxApplied);
    if (box.containsKey('$keyApplied${filter.id}')) {
      var applied = (box.get('$keyApplied${filter.id}') as ActiveFilter);
      if (applied.termIds.length <= 1) {
        box.delete('$keyApplied${filter.id}');
      } else {
        applied.termIds.remove(value.id);
        box.put('$keyApplied${filter.id}', applied);
      }
    }
  }

  Future<void> saveFilter(Attribute attribute, List<Term> terms) async {
    var box = await Hive.openBox(boxFilters);
    // if (box.containsKey('$keyFilter${attribute.id}')) return
    box.put(
      '$keyFilter${attribute.id}',
      Filter(
        attribute.id,
        attribute.name,
        attribute.slug,
        attribute.type,
        terms
            .map((term) => FilterValue(term.id, term.name, term.slug))
            .toList(),
      ),
    );
  }

  Future<List<Filter>> getFilters() async {
    var box = await Hive.openBox(boxFilters);
    print('filters = ${box.values}');
    return box.values.toList().cast();
  }

  Future<void> addToCart(int id, {String name = ''}) async {
    var box = await Hive.openBox(boxCartCache);
    if (box.containsKey('$keyCart$id')) return box.close();
    box.put('$keyCart$id', CartCacheItem(id, name));
    return box.close();
  }

  Future<void> deleteFromCart(int id) async {
    var box = await Hive.openBox(boxCartCache);
    if (box.containsKey('$keyCart$id')) {
      box.delete('$keyCart$id');
    }
    return box.close();
  }

  Future<bool> isInCart(int id) async {
    var box = await Hive.openBox(boxCartCache);
    return box.containsKey('$keyCart$id');
  }

  Future<void> clearCart() async {
    var box = await Hive.openBox(boxCartCache);
    box.clear();
    return box.close();
  }

  Future<void> insertWishList(List<Pair<String, int>> raw) async {
    var box = await Hive.openBox(boxWishListCache);
    await box.clear();
    for (var pair in raw) {
      var key = '$keyWishList${pair.first}';
      box.put(key, WishListCacheItem(pair.first, pair.second));
    }
    await box.close();
    return;
  }

  Future<void> addToWishList(String itemId, int productId) async {
    var box = await Hive.openBox(boxWishListCache);
    var key = '$keyWishList$itemId';
    if (box.containsKey(key)) {
      //await box.close();
    }
    box.put(key, WishListCacheItem(itemId, productId));
    //await box.close();
    return;
  }

  Future<String> getWishListItemIdByProductId(int productId) async {
    var box = await Hive.openBox(boxWishListCache);
    for (WishListCacheItem item in box.values) {
      if (item.productId == productId) return item.itemId;
    }
    return '';
  }

  Future<void> deleteFromWishList(String itemId) async {
    var box = await Hive.openBox(boxWishListCache);
    var key = '$keyWishList$itemId';
    if (box.containsKey(key)) {
      await box.delete(key);
    }
    //await box.close();
    return;
  }

  Future<bool> isInWishList(String itemId) async {
    var box = await Hive.openBox(boxWishListCache);
    return box.containsKey('$keyWishList$itemId');
  }

  Future<bool> isInWishListByProductId(int productId) async {
    var box = await Hive.openBox(boxWishListCache);
    for (WishListCacheItem item in box.values) {
      if (item.productId == productId) return true;
    }
    return false;
  }

  Future<void> saveProductView(Product product) async {
    var box = await Hive.openBox(boxViewedProduct);
    if (box.containsKey('$keyViewedProduct${product.id}')) return box.close();
    box.put(
      '$keyViewedProduct${product.id}',
      ViewedProduct(
        product.id,
        product.name,
        product.price,
        product.images[0].src,
      ),
    );
    return box.close();
  }

  Future<List<ViewedProduct>> getViewedProducts() async {
    var box = await Hive.openBox(boxViewedProduct);
    return box.values.toList().cast();
  }

  Future<bool> isAuthenticated() async {
    var box = await Hive.openBox(boxUser);
    return box.isNotEmpty;
  }

  Future<void> saveUser(User user) async {
    var box = await Hive.openBox(boxUser);
    await box.clear();
    await box.put(keyUser, user);
    return box.close();
  }

  Future<User> getUser() async {
    var box = await Hive.openBox(boxUser);
    return (box.get(keyUser) as User);
  }

  Future<int> getUserId() async {
    var box = await Hive.openBox(boxUser);
    return (box.get(keyUser) as User).id;
  }
}
