import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:untitled/api/interceptor_logger.dart';

class WpApiClient {
  final Dio dio = Dio();

  WpApiClient() {
    dio.options.baseUrl = dotenv.env['WP_BASE_URL'].toString();
    //dio.interceptors.add(CoCartAuthInterceptor());
    dio.interceptors.add(PrinterInterceptor());
  }
}
