import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:untitled/api/interceptor_cocart_auth.dart';

import 'interceptor_logger.dart';

class CoCartApiClient {
  final Dio dio = Dio();

  CoCartApiClient() {
    dio.options.baseUrl = dotenv.env['CO_CART_BASE_URL'].toString();
    // dio.interceptors.add(CoCartAuthInterceptor());
    dio.interceptors.add(PrinterInterceptor());
  }

  Dio withHeaders(Map<String, dynamic> headers) {
    dio.options.headers.clear();
    dio.options.headers.addAll(headers);
    return dio;
  }
}
