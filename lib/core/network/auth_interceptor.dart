import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  String? token;

  AuthInterceptor({this.token});

  void setToken(String? newToken) {
    token = newToken;
  }

  void clearToken() {
    token = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (token != null && token!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
