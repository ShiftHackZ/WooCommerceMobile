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
        return mapWishEntriesToProducts(entries, products);
      });

  @override
  Future addProduct(int id) => _db
      .getUserId()
      .then((userId) => _woo.dio.get('wishlist/get_by_user/$userId'))
      .then((response) => (response.data as List)[0]['share_key'])
      .then(
        (shareKey) => _woo.dio.post(
          'wishlist/$shareKey/add_product',
          data: {
            'product_id': '$id',
          },
        ),
      );
}

abstract class WishListDataSource {
  Future<List<WishListEntry>> getWishListEntries();
  Future<List<Pair<WishListEntry, Product>>> getWishListWithProducts();
  Future addProduct(int id);
}

List<Pair<WishListEntry, Product>> mapWishEntriesToProducts(
  List<WishListEntry> entries,
  List<Product> products,
) {
  var result = <Pair<WishListEntry, Product>>[];
  for (var entry in entries) {
    var product = products.firstWhere((p) => p.id == entry.productId, orElse: null);
    result.add(Pair(entry, product));
  }
  return result;
}
