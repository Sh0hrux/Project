import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:startup_app/core/error/exceptions.dart';
import 'package:startup_app/core/network/api_endpoints.dart';
import 'package:startup_app/core/network/auth_interceptor.dart';
import 'package:startup_app/core/network/logging_interceptor.dart';
import 'package:startup_app/core/storage/token_storage.dart';

class DioClient {
  final Dio _dio;
  final AuthInterceptor authInterceptor;
  final LoggingInterceptor loggingInterceptor;

  DioClient({
    Dio? dio,
    TokenStorage? tokenStorage,
    AuthInterceptor? authInterceptor,
    LoggingInterceptor? loggingInterceptor,
    VoidCallback? onUnauthorized,
  })  : authInterceptor = authInterceptor ??
            AuthInterceptor(
              tokenStorage: tokenStorage ?? SecureTokenStorage(),
              onUnauthorized: onUnauthorized,
            ),
        loggingInterceptor = loggingInterceptor ?? LoggingInterceptor(),
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiEndpoints.baseUrl,
                connectTimeout: ApiEndpoints.connectTimeout,
                receiveTimeout: ApiEndpoints.receiveTimeout,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.addAll([
      this.authInterceptor,
      this.loggingInterceptor,
    ]);
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: "Serverga ulanishda vaqt tugadi yoki internet yo'q",
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = "Serverda xatolik yuz berdi";

        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }

        if (statusCode == 401) {
          return UnauthorizedException(message: message);
        }
        return ServerException(message: message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return const ServerException(message: "So'rov bekor qilindi");
      default:
        return ServerException(
          message: error.message ?? "Kutilmagan tarmoq xatosi",
        );
    }
  }
}
