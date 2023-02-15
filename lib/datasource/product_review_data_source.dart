import 'package:wooapp/api/woo_api_client.dart';
import 'package:wooapp/constants/config.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/product_rewiew.dart';

class ProductReviewDataSourceImpl extends ProductReviewDataSource {
  final AppDb _db = locator<AppDb>();
  final WooApiClient _api = locator<WooApiClient>();

  @override
  Future<List<ProductReview>> getReviews(int productId, int page) => _api.dio
      .get('products/reviews?per_page=${AppConfig.paginationLimit}&product=$productId&page=$page')
      .then((response) => (response.data as List).map((item) => ProductReview.fromJson(item)).toList());

  @override
  Future<ProductReview> addReview(int productId, double rating, String review) => _db.getUser()
      .then((user) => _api.dio.post('products/reviews', data: {
        'product_id': productId,
        'review': review,
        'reviewer': user.name,
        'reviewer_email': user.email,
        'rating': rating
      }))
      .then((response) => ProductReview.fromJson(response.data));
}

abstract class ProductReviewDataSource {
  Future<List<ProductReview>> getReviews(int productId, int page);
  
  Future<ProductReview> addReview(int productId, double rating, String review);
}
