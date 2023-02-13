import 'package:untitled/api/woo_api_client.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/datasource/cart_data_source.dart';
import 'package:untitled/locator.dart';
import 'package:untitled/model/cart_response.dart';
import 'package:untitled/model/order.dart';
import 'package:untitled/model/payment_method.dart';
import 'package:untitled/model/shipping_method.dart';
import 'package:untitled/screens/orders/create/create_order_model.dart';

class CreateOrderDataSourceImpl extends CreateOrderDataSource {
  final WooApiClient _api = locator<WooApiClient>();
  final AppDb _db = locator<AppDb>();

  @override
  Future<Order> createOrder(
          List<CartItem> cartItems,
          CreateOrderRecipient recipient,
          CreateOrderShipping shipping,
          ShippingMethod shippingMethod,
          PaymentMethod paymentMethod) =>
      _db.getUserId().then((userId) => _api.dio.post('orders', data: {
            'payment_method': paymentMethod.id,
            'payment_method_title': paymentMethod.title,
            'set_paid': 'false',
            'customer_id': userId,
            'billing': {
              'first_name': recipient.firstName,
              'last_name': recipient.lastName,
              'address_1': shipping.address1,
              'address_2': shipping.address2,
              'city': shipping.city,
              'state': shipping.state,
              'postcode': shipping.index,
              'country': shipping.country,
              'email': recipient.email,
              'phone': recipient.phone
            },
            'shipping': {
              'first_name': recipient.firstName,
              'last_name': recipient.lastName,
              'address_1': shipping.address1,
              'address_2': shipping.address2,
              'city': shipping.city,
              'state': shipping.state,
              'postcode': shipping.index,
              'country': shipping.country,
            },
            'line_items': [
              for (var prd in cartItems)
                {'product_id': prd.id, 'quantity': prd.quantity.value}
            ],
            'shipping_lines': [
              {
                'method_id': shippingMethod.id,
                'method_title': shippingMethod.title,
                // 'total': '0'
              }
            ]
          })
          .then((response) => Order.fromJson(response.data)));
}

abstract class CreateOrderDataSource {
  Future<Order> createOrder(
      List<CartItem> cartItems,
      CreateOrderRecipient recipient,
      CreateOrderShipping shipping,
      ShippingMethod shippingMethod,
      PaymentMethod paymentMethod
  );
}
