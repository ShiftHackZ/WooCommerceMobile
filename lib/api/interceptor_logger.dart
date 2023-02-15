import 'package:dio/dio.dart';

class PrinterInterceptor extends Interceptor {

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('''------------------- START REQUEST
Method: ${options.method}
Headers: ${options.headers}
Path: ${options.path}
Query parameters: ${options.queryParameters}
Data: ${options.data}
Content type: ${options.contentType}
------------------- END HTTP REQUEST''');
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    print('''------------------- START RESPONSE
Status code: ${response.statusCode}
Response data: ${response.data}
------------------- END RESPONSE''');
    super.onResponse(response, handler);//Headers: ${response.headers}
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print('''------------------- START ERROR
Response: ${err.response}
Error type: ${err.type}
Error message: ${err.message}
------------------- END ERROR''');
    super.onError(err, handler);
  }
}
