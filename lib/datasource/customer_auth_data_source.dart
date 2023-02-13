import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:untitled/api/api_response.dart';
import 'package:untitled/api/cocart_api_client.dart';
import 'package:untitled/api/woo_api_client.dart';
import 'package:untitled/api/wp_api_client.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/database/user.dart';
import 'package:untitled/locator.dart';
import 'package:untitled/model/auth_register_response.dart';
import 'package:untitled/model/customer_profile.dart';
import 'package:untitled/model/user_data.dart';

class CustomerAuthDataSourceImpl extends CustomerAuthDataSource {
  final AppDb _db = locator<AppDb>();

  final CoCartApiClient _apiCoCart = locator<CoCartApiClient>();
  final WpApiClient _apiWp = locator<WpApiClient>();
  final WooApiClient _apiWoo = locator<WooApiClient>();
  
  @override
  Future<UserData> login(String login, String password) => _apiCoCart
      .withHeaders({
        'Authorization': 'Basic ${base64Encode(utf8.encode('$login:$password'))}'
      })
      .post('login')
      .then((response) => UserData.fromJson(response.data))
      .then((data) {
        if (data.id != -1) {
          var user = User(data.id, data.name, data.role, login, password, '');
          _db.saveUser(user);
        }
        return data;
      })
      .then((data) {
        _apiWoo.dio.get('customers/${data.id}')
          .then((response) => CustomerProfile.formJson(response.data))
          .then((customer) {
            var user = User(data.id, data.name, data.role, login, password, customer.email);
            _db.saveUser(user);
          });
        return data;
      });

  @override
  Future<WpRegResponse> register(String username, String email, String password) => _apiWp.dio
      .post(
        'wp/v2/users/register',
        data: jsonEncode({
          'username': username,
          'email': email,
          'password': password
        })
      )
      .then((response) => WpRegResponse.fromJson(response.data));
      // .then((register) {
      //   if (register.code == 200) {
      //     var user = User(register.id, username, '', email, password, '');
      //     _db.saveUser(user);
      //   }
      //   return register;
      // });

  @override
  Future<WpRegResponse> reset(String username) => _apiWp.dio
      .post(
        'wp/v2/users/lost-password',
        data: jsonEncode({
          'user_login': username
        })
      )
      .then((response) => WpRegResponse.fromJson(response.data));
  
}

abstract class CustomerAuthDataSource {
  Future<UserData> login(String login, String password);

  Future<WpRegResponse> reset(String username);

  Future<WpRegResponse> register(String username, String email, String password);
}
