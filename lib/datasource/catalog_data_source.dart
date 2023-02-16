import 'package:wooapp/api/woo_api_client.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/category.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/screens/featured/featured_sort.dart';

class CatalogDataSourceImpl extends CatalogDataSource {

  final WooApiClient _api = locator<WooApiClient>();

  @override
  Future<List<Category>> getCategories(int page, Sort sort) => _api.dio
      .get('products/categories?hide_empty=true&parent=0&per_page=${WooAppConfig.paginationLimit}&page=$page&$sort')
      .then((response) => (response.data as List).map((item) => Category.fromJson(item)).toList());

  @override
  Future<List<Product>> getCatalogProducts(int category) => _api.dio
      .get('products?status=publish&per_page=10&page=1&category=$category')
      .then((response) => (response.data as List).map((item) => Product.fromJson(item)).toList());
}

abstract class CatalogDataSource {
  Future<List<Category>> getCategories(int page, Sort sort);

  Future<List<Product>> getCatalogProducts(int category);
}
