import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:untitled/api/interceptor_woo_auth.dart';
import 'package:untitled/api/interceptor_logger.dart';

class WooApiClient {
  final Dio dio = Dio();

  WooApiClient() {
    dio.options.baseUrl = dotenv.env['WOO_BASE_URL'].toString();
    dio.interceptors.add(WooAuthInterceptor());
    dio.interceptors.add(PrinterInterceptor());
  }
}
