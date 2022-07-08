import 'package:dio/dio.dart';
import 'package:newsapi/app_setup/dio/interceptors/error_interceptors.dart';
import 'package:newsapi/app_setup/dio/interceptors/request_interceptors.dart';
import 'package:newsapi/app_setup/dio/interceptors/response_interceptors.dart';

Dio dioClient() {
  final _dio = Dio();
  final options = BaseOptions(
    connectTimeout: 30000, //30 sec
    receiveTimeout: 30000,
    contentType: Headers.jsonContentType,
    headers: <String, dynamic>{
      'Accept': Headers.jsonContentType,
    },
    baseUrl: 'https://newsapi.org/v2',
    queryParameters: {},
  );
  _dio.options = options;
  _dio.interceptors.addAll([
    LogInterceptor(),
    RequestInterceptor(),
    ResponseInterceptor(),
    ErrorInterceptor(),
  ]);
  return _dio;
}
