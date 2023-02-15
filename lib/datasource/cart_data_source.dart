import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wooapp/api/cocart_api_client.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/cart_response.dart';

class CartDataSourceImpl extends CartDataSource {
  final CoCartApiClient _api = locator<CoCartApiClient>();
  final AppDb _db = locator<AppDb>();

  Future<Dio> _sendUserRequest() => _db.getUser()
      .then((user) => _api.withHeaders({
    'Authorization': 'Basic ${base64Encode(utf8.encode('${user.login}:${user.password}'))}'
  }));

  @override
  Future<CartResponse> getCart() => _sendUserRequest()
      .then((dio) => dio.get('cart'))
      .then((response) {
        if (response.data is List<dynamic>) {
          return CartResponse.empty();
        }
        var data = CartResponse.fromJson(response.data);
        for (var cartItem in data.items) _db.addToCart(cartItem.id);
        return data;
      });

  @override
  Future<Response> addItem(int id, int count) => _sendUserRequest()
      .then((dio) => dio.post('cart/add-item', data: {
        'id': id,
        'quantity': count,
      })).then((response) {
        if (response.statusCode == 200) _db.addToCart(id);
        return response;
      });

  @override
  Future<Response> addVariableItem(
    int id,
    int count,
    Map<String, dynamic> variation,
  ) =>
      _sendUserRequest().then(
        (dio) => dio.post(
          'cart/add-item',
          data: {
            'id': id,
            'quantity': count,
            'variation': variation,
          },
        ),
      ).then((response) {
        if (response.statusCode == 200) _db.addToCart(id);
        return response;
      });

  @override
  Future<Response> updateQuantity(String itemKey, int count) => _sendUserRequest()
      .then((dio) => dio.post('cart/item/$itemKey', data: {
        'quantity': count
      }));

  @override
  Future<CartResponse> deleteItem(String itemKey, int originalId) => _sendUserRequest()
      .then((dio) => dio.delete('cart/item/$itemKey'))
      .then((response) {
        if (response.statusCode == 200) _db.deleteFromCart(originalId);
        if (response.data is List<dynamic>) return CartResponse.empty();
        return CartResponse.fromJson(response.data);
      });

  @override
  Future<CartItem> getItem(String itemKey) => _sendUserRequest()
      .then((dio) => dio.get('cart/item/$itemKey'))
      .then((response) => CartItem.fromJson(response.data));

  @override
  Future<Response> clearCart() => _sendUserRequest()
      .then((dio) => dio.post('cart/clear'))
      .then((response) {
        _db.clearCart();
        return response;
      });
}

abstract class CartDataSource {
  Future<CartResponse> getCart();

  Future<Response> addItem(int id, int count);

  Future<Response> addVariableItem(int id, int count, Map<String, dynamic> variation);

  Future<Response> updateQuantity(String itemKey, int count);

  Future<CartResponse> deleteItem(String itemKey, int originalId);

  Future<CartItem> getItem(String itemKey);

  Future<Response> clearCart();
}
