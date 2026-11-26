import 'package:dio/dio.dart';
import 'package:startup_app/core/network/api_endpoints.dart';

abstract class TokenRefresher {
  Future<String?> refresh(String refreshToken);
}

class DioTokenRefresher implements TokenRefresher {
  final Dio _dio;

  DioTokenRefresher({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiEndpoints.baseUrl,
                connectTimeout: ApiEndpoints.connectTimeout,
                receiveTimeout: ApiEndpoints.receiveTimeout,
                headers: const {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  @override
  Future<String?> refresh(String refreshToken) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final token = data['access_token'] ?? data['accessToken'];
        if (token is String && token.isNotEmpty) {
          return token;
        }
      }
      return null;
    } on DioException {
      return null;
    } catch (_) {
      return null;
    }
  }
}
