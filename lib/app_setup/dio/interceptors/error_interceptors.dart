import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    return super.onError(err, handler);
  }
}
