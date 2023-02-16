
import 'package:wooapp/api/woo_api_client.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/product.dart';
import 'package:wooapp/model/category.dart';
import 'package:wooapp/screens/featured/featured_filter.dart';
import 'package:wooapp/screens/featured/featured_sort.dart';

class ProductsHomeDataSourceImpl extends ProductsHomeDataSource {
  final WooApiClient _api = locator<WooApiClient>();

  @override
  Future<List<Product>> getProducts(int page, Sort sort, FeaturedFilter filter) => _api.dio
    .get('products?status=publish&per_page=${WooAppConfig.paginationLimit}&page=$page&$sort$filter')
    .then((response) => (response.data as List).map((item) => Product.fromJson(item)).toList());

  @override
  Future<List<Category>> getCategories(int page) => _api.dio
    .get('products/categories?per_page=${WooAppConfig.paginationLimit}&page=$page')
    .then((response) => (response.data as List).map((item) => Category.fromJson(item)).toList());


  @override
  Future<double> getMostExpensiveProduct() => _api.dio
    .get('products?status=publish&per_page=1&page=1&order=desc&orderby=price')
    .then((response) => double.tryParse((response.data as List).map((item) => Product.fromJson(item)).toList()[0].price) ?? 1000);
}

abstract class ProductsHomeDataSource {
  Future<List<Product>> getProducts(int page, Sort sort, FeaturedFilter filter);

  Future<double> getMostExpensiveProduct();

  Future<List<Category>> getCategories(int page);
}
