import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PrinterInterceptor extends Interceptor {
  static const tag = '[HTTP] ';

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (kDebugMode) {
      var log = '';
      log += '$tag------------------->\n';
      log += '$tag[${options.method}] ${options.baseUrl}${options.path}\n';
      if (options.headers.isNotEmpty) {
        log += '$tag${options.headers}\n';
      }
      if (options.queryParameters.isNotEmpty) {
        log += '$tag${options.queryParameters}\n';
      }
      if (options.data != null) {
        log += '$tag${options.data}\n';
      }
      log += '$tag------------------->\n';
      print(log);
    }
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) {
      var log = '';
      log += '$tag<-------------------\n';
      log += '$tag[${response.statusCode}] ${response.realUri}\n';
      if (response.data != null) {
        log += '$tag${response.data}\n';
      }
      log += '$tag<-------------------\n';
      print(log);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      var log = '';
      log += '$tag<-------------------\n';
      log += '$tag[${err.response?.statusCode}] ${err.response?.realUri}\n';
      if (err.response?.headers != null
          && err.response?.headers.isEmpty == false) {
        log += '$tag${err.response?.headers}\n';
      }
      if (err.response?.data != null) {
        log += '$tag${err.response?.data}\n';
      }
      log += '$tag<-------------------\n';
      print(log);
    }
    super.onError(err, handler);
  }
}
