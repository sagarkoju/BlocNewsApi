import 'package:dio/dio.dart';

class ResponseInterceptor extends Interceptor {
  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    return super.onResponse(response, handler);
  }
}
