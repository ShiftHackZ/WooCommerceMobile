import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoCartAuthInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var publicToken = dotenv.env['CO_CART_PUBLIC_TOKEN'].toString();
    var secretToken = dotenv.env['CO_CART_SECRET_TOKEN'].toString();
    String basic = 'Basic ' + base64Encode(utf8.encode('$publicToken:$secretToken'));
    options.headers = ({'Authorization': '$basic'});
    super.onRequest(options, handler);
  }
}
