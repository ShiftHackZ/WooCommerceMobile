import 'package:untitled/api/woo_api_client.dart';
import 'package:untitled/api/wp_api_client.dart';
import 'package:untitled/constants/config.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/database/filter_active.dart';
import 'package:untitled/locator.dart';
import 'package:untitled/model/attribute.dart';
import 'package:untitled/model/product.dart';

class CategoryAttributeDateSourceImpl extends CategoryAttributeDateSource {
  final WooApiClient _api = locator<WooApiClient>();
  final WpApiClient _wp = locator<WpApiClient>();
  final AppDb _db = locator<AppDb>();

  @override
  Future<List<Attribute>> getAttributes() => _api.dio
      .get('products/attributes')
      .then((response) => (response.data as List).map((item) => Attribute.fromJson(item)).toList());

  @override
  Future<List<Term>> getTerms(int attributeId) => _api.dio
      .get('products/attributes/$attributeId/terms')
      .then((response) => (response.data as List).map((item) => Term.fromJson(item)).toList());

  @override
  Future<List<CategoryProduct>> getProducts(String categorySlug, int page) => _db.getActiveFilters()
      .then((active) => _parseActiveFilters(active))
      .then((query) => _wp.dio.get('wp/v3/filter/products/?per_page=${AppConfig.paginationLimit}&offset=$page&category=$categorySlug$query'))
      .then((response) => (response.data as List).map((item) => CategoryProduct.fromJson(item)).toList());

  String _parseActiveFilters(List<ActiveFilter> filters) {
    var result = '';
    for (var filter in filters) {
      result += '&filter[${filter.slug}]=';
      for (var value in filter.termIds) {
        result += ',$value';
      }
    }
    return result.replaceAll('=,', '=');
  }
}

abstract class CategoryAttributeDateSource {

  Future<List<Attribute>> getAttributes();

  Future<List<Term>> getTerms(int attributeId);

  Future<List<CategoryProduct>> getProducts(String categorySlug, int page);
}
