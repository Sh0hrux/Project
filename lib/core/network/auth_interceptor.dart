import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:startup_app/core/network/token_refresher.dart';
import 'package:startup_app/core/storage/organization_storage.dart';
import 'package:startup_app/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final TokenRefresher tokenRefresher;
  final OrganizationStorage? organizationStorage;
  final VoidCallback? onUnauthorized;
  Dio? dio;

  Completer<String?>? _refreshCompleter;

  AuthInterceptor({
    required this.tokenStorage,
    required this.tokenRefresher,
    this.organizationStorage,
    this.onUnauthorized,
    this.dio,
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
    final orgId = await organizationStorage?.getOrganizationId();
    if (orgId != null && orgId.isNotEmpty) {
      options.headers['X-Organization-Id'] = orgId;
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      if (err.requestOptions.extra['retried'] == true) {
        await _clearSessionAndNotify();
        return handler.next(err);
      }

      final newAccessToken = await _refreshTokenLocked();
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        final options = err.requestOptions;
        options.extra['retried'] = true;
        options.headers['Authorization'] = 'Bearer $newAccessToken';

        if (dio != null) {
          try {
            final response = await dio!.fetch<dynamic>(options);
            return handler.resolve(response);
          } on DioException catch (retryErr) {
            return handler.next(retryErr);
          }
        }
      }

      return handler.next(err);
    }
    super.onError(err, handler);
  }

  Future<String?> _refreshTokenLocked() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<String?>();
    _refreshCompleter = completer;

    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _clearSessionAndNotify();
        completer.complete(null);
        return null;
      }

      final newAccessToken = await tokenRefresher.refresh(refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await tokenStorage.saveTokens(newAccessToken, refreshToken);
        completer.complete(newAccessToken);
        return newAccessToken;
      }

      await _clearSessionAndNotify();
      completer.complete(null);
      return null;
    } catch (_) {
      await _clearSessionAndNotify();
      if (!completer.isCompleted) {
        completer.complete(null);
      }
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<void> _clearSessionAndNotify() async {
    await tokenStorage.clear();
    await organizationStorage?.clear();
    onUnauthorized?.call();
  }
}
