import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PrinterInterceptor extends Interceptor {

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (kDebugMode) print('''-------------------> HTTP REQUEST
Method: ${options.method}
Headers: ${options.headers}
Path: ${options.baseUrl}${options.path}
Query parameters: ${options.queryParameters}
Data: ${options.data}
Content type: ${options.contentType}
-------------------> END HTTP REQUEST''');
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) print('''<------------------- HTTP RESPONSE
Status code: ${response.statusCode}
Headers: ${response.headers}
Response data: ${response.data}
Path: ${response.realUri}
<------------------- END HTTP RESPONSE''');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) print('''<------------------- HTTP ERROR
Headers: ${err.response?.headers.map ?? {}}
Response: ${err.response}
Error type: ${err.type}
Error message: ${err.message}
Path: ${err.response?.realUri}
<------------------- END HTTP ERROR''');
    super.onError(err, handler);
  }
}
