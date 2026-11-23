import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final maskedHeaders = _maskMap(options.headers);
      final maskedData = _maskData(options.data);
      debugPrint('[DIO Request] ${options.method} ${options.uri}');
      debugPrint('[DIO Headers] $maskedHeaders');
      if (maskedData != null) {
        debugPrint('[DIO Body] $maskedData');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[DIO Response] ${response.statusCode} ${response.requestOptions.uri}',
      );
      debugPrint('[DIO Response Body] ${_maskData(response.data)}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[DIO Error] ${err.type} ${err.requestOptions.uri}');
      debugPrint('[DIO Error Message] ${err.message}');
    }
    super.onError(err, handler);
  }

  dynamic _maskData(dynamic data) {
    if (data is Map) {
      return _maskMap(data);
    }
    return data;
  }

  Map<dynamic, dynamic> _maskMap(Map<dynamic, dynamic> map) {
    final result = Map<dynamic, dynamic>.from(map);
    for (final key in result.keys) {
      final keyLower = key.toString().toLowerCase();
      if (keyLower.contains('authorization')) {
        result[key] = 'Bearer ***';
      } else if (keyLower.contains('password') ||
          keyLower.contains('token') ||
          keyLower.contains('secret')) {
        result[key] = '***MASKED***';
      } else if (result[key] is Map) {
        result[key] = _maskMap(result[key] as Map);
      }
    }
    return result;
  }
}
