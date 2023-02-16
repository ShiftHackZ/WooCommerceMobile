import 'package:wooapp/api/woo_api_client.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/order.dart';

class OrdersDataSourceImpl extends OrdersDataSource {
  final WooApiClient _api = locator<WooApiClient>();
  final AppDb _db = locator<AppDb>();

  @override
  Future<List<Order>> getOrders(int page) => _db.getUserId()
      .then((userId) => _api.dio.get('orders?per_page=${WooAppConfig.paginationLimit}&page=$page&customer=$userId'))
      .then((response) => (response.data as List).map((item) => Order.fromJson(item)).toList());

}

abstract class OrdersDataSource {
  Future<List<Order>> getOrders(int page);
}
