import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wooapp/api/interceptor_logger.dart';

class WpApiClient {
  final Dio dio = Dio();

  WpApiClient() {
    dio.options.baseUrl = dotenv.env['WP_BASE_URL'].toString();
    dio.interceptors.add(PrinterInterceptor());
  }
}
