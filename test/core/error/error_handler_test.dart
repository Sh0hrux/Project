import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/core/error/error_handler.dart';
import 'package:startup_app/core/error/failures.dart';

void main() {
  group('ErrorHandler Unit Tests', () {
    final requestOptions = RequestOptions(path: '/test');

    test('1. connectionTimeout -> NetworkFailure', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      final failure = ErrorHandler.handleDioError(dioException);

      expect(failure, isA<NetworkFailure>());
      expect(failure.message, "Serverga ulanishda vaqt tugadi yoki internet yo'q");
    });

    test('2. 401 badResponse -> UnauthorizedFailure', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
          data: {'message': 'Token eskirgan'},
        ),
      );

      final failure = ErrorHandler.handleDioError(dioException);

      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, 'Token eskirgan');
      expect(failure.statusCode, 401);
    });

    test('3. 500 badResponse -> ServerFailure', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 500,
          data: {'message': 'Ichki server xatosi'},
        ),
      );

      final failure = ErrorHandler.handleDioError(dioException);

      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Ichki server xatosi');
      expect(failure.statusCode, 500);
    });

    test('4. Boshqa kutilmagan xato -> UnknownFailure', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.unknown,
        message: 'Noma\'lum xatolik',
      );

      final failure = ErrorHandler.handleDioError(dioException);

      expect(failure, isA<UnknownFailure>());
      expect(failure.message, 'Noma\'lum xatolik');
    });
  });
}
