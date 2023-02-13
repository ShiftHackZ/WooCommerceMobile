import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/database/cart_cache_item.dart';
import 'package:untitled/database/filter.dart';
import 'package:untitled/database/filter_active.dart';
import 'package:untitled/database/filter_value.dart';
import 'package:untitled/database/product.dart';
import 'package:untitled/database/user.dart';
import 'package:untitled/model/attribute.dart';
import 'package:untitled/model/product.dart';

class AppDb {

  static const String boxUser = 'box_user';
  static const String boxViewedProduct = 'box_viewed';
  static const String boxFilters = 'box_filters';
  static const String boxApplied = 'box_applied';
  static const String boxCartCache = 'box_cart_cache';

  static const String keyUser = 'key_user';
  static const String keyViewedProduct = 'key_viewed';
  static const String keyFilter = 'key_viewed';
  static const String keyApplied = 'key_applied';
  static const String keyCart = 'key_cart';

  Future<void> clear() async {
    var box1 = await Hive.openBox(boxUser);
    var box2 = await Hive.openBox(boxViewedProduct);
    await box1.clear();
    await box2.clear();
    box1.close();
    return box2.close();
  }

  Future<bool> isActiveFilter(int filterId, int valueId) async {
    var box = await Hive.openBox(boxApplied);
    if (box.containsKey('$keyApplied$filterId')) {
      var applied = box.get('$keyApplied$filterId') as ActiveFilter;
      if (applied.termIds.contains(valueId)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
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
            terms.map((term) => FilterValue(term.id, term.name, term.slug)).toList()
        )
    );
  }

  Future<List<Filter>> getFilters() async {
    var box = await Hive.openBox(boxFilters);
    print('filters = ${box.values}');
    return box.values.toList().cast();
  }

  Future<void> addToCart(int id, {String name = ''}) async {
    var box = await Hive.openBox(boxCartCache);
    if (box.containsKey('$keyCart$id}')) return box.close();
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

  Future<void> saveProductView(Product product) async {
    var box = await Hive.openBox(boxViewedProduct);
    if (box.containsKey('$keyViewedProduct${product.id}')) return box.close();
    box.put(
        '$keyViewedProduct${product.id}',
        ViewedProduct(
            product.id,
            product.name,
            product.price,
            product.images[0].src
        )
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
