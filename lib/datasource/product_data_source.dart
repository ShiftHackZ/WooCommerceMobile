import 'package:wooapp/api/woo_api_client.dart';
import 'package:wooapp/model/product.dart';

import '../locator.dart';

class ProductDataSourceImpl extends ProductDataSource {
  final WooApiClient _api = locator<WooApiClient>();

  @override
  Future<Product> getProducts(int id) => _api.dio
      .get('products/$id')
      .then((response) => Product.fromJson(response.data));

}

abstract class ProductDataSource {
  Future<Product> getProducts(int id);
}
