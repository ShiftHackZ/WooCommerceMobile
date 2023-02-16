import 'package:wooapp/api/woo_api_client.dart';
import 'package:wooapp/api/wp_api_client.dart';
import 'package:wooapp/core/pair.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/model/wish_list_entry.dart';

class WishListDataSourceImpl extends WishListDataSource {
  final AppDb _db = locator<AppDb>();
  final WpApiClient _wp = locator<WpApiClient>();
  final WooApiClient _woo = locator<WooApiClient>();

  @override
  Future<List<WishListEntry>> getWishListEntries() => _db
      .getUserId()
      .then((userId) => _woo.dio.get('wishlist/get_by_user/$userId'))
      .then((response) => (response.data as List)[0]['share_key'])
      .then((shareKey) => _woo.dio.get('wishlist/$shareKey/get_products'))
      .then(
        (response) => (response.data as List)
            .map((e) => WishListEntry.fromJson(e))
            .toList(),
      );

  @override
  Future<List<Pair<WishListEntry, Product>>> getWishListWithProducts() =>
      getWishListEntries().then((entries) async {
        var ids = entries.map((e) => '${e.productId},')
            .toList()
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '');
        var products =
            await _woo.dio.get('products?status=publish&include=$ids').then(
                  (response) => (response.data as List)
                      .map((item) => Product.fromJson(item))
                      .toList(),
                );
        var data =
            await _mapWishEntriesToProducts(entries, products);

        return data;
      });

  @override
  Future addProduct(int productId) => _db
      .getUserId()
      .then((userId) => _woo.dio.get('wishlist/get_by_user/$userId'))
      .then((response) => (response.data as List)[0]['share_key'])
      .then(
        (shareKey) => _woo.dio.post(
          'wishlist/$shareKey/add_product',
          data: {
            'product_id': '$productId',
          },
        ),
      )
      .then((response) => (response.data as List)[0]['item_id'].toString())
      .then((itemId) => _db.addToWishList(itemId, productId));

  @override
  Future removeProductByItemId(itemId) => _woo.dio
      .get('wishlist/remove_product/$itemId')
      .then((_) => _db.deleteFromWishList(itemId));

  @override
  Future removeProductByProductId(int productId) => _db
      .getWishListItemIdByProductId(productId)
      .then((itemId) => removeProductByItemId(itemId));

  List<Pair<WishListEntry, Product>> _mapWishEntriesToProducts(
    List<WishListEntry> entries,
    List<Product> products,
  ) {
    var result = <Pair<WishListEntry, Product>>[];
    var raw = <Pair<String, int>>[];
    for (var entry in entries) {
      var product = products.firstWhere((p) => p.id == entry.productId, orElse: null);
      result.add(Pair(entry, product));
      raw.add(Pair(entry.itemId.toString(), product.id));
      _db.addToWishList(entry.itemId.toString(), entry.productId);
    }
    // await _db.insertWishList(raw);
    return result;
  }

  @override
  Future<bool> isInWishList(String itemId) =>
      _db.isInWishList(itemId);

  @override
  Future<bool> isInWishListByProductId(int productId) =>
      _db.isInWishListByProductId(productId);
}

abstract class WishListDataSource {
  Future<List<WishListEntry>> getWishListEntries();
  Future<List<Pair<WishListEntry, Product>>> getWishListWithProducts();
  Future addProduct(int productId);
  Future removeProductByItemId(String itemId);
  Future removeProductByProductId(int productId);
  Future<bool> isInWishList(String itemId);
  Future<bool> isInWishListByProductId(int productId);
}
