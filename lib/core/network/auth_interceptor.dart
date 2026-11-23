import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:startup_app/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final VoidCallback? onUnauthorized;

  AuthInterceptor({
    required this.tokenStorage,
    this.onUnauthorized,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final newAccessToken = await mockRefreshAccessToken(refreshToken);
          if (newAccessToken != null) {
            await tokenStorage.saveTokens(newAccessToken, refreshToken);
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';
            final dio = Dio();
            final response = await dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (_) {
          // Token yangilashda xatolik yuz berdi
        }
      }

      await tokenStorage.clear();
      onUnauthorized?.call();
    }
    super.onError(err, handler);
  }

  @visibleForTesting
  Future<String?> mockRefreshAccessToken(String refreshToken) async {
    if (refreshToken == 'invalid_refresh_token') {
      return null;
    }
    return 'new_mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
  }
}
