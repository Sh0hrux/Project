import 'package:dio/dio.dart';
import 'package:startup_app/core/error/failures.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure(
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
          return UnauthorizedFailure(
            message: message.isNotEmpty ? message : "Avtorizatsiyadan o'tilmagan",
            statusCode: 401,
          );
        }

        if (statusCode != null && statusCode >= 500 && statusCode < 600) {
          return ServerFailure(
            message: message,
            statusCode: statusCode,
          );
        }

        return ServerFailure(
          message: message,
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return const ServerFailure(message: "So'rov bekor qilindi");
      default:
        return UnknownFailure(
          message: error.message ?? "Kutilmagan tarmoq xatosi",
        );
    }
  }

  static Failure handleException(Object exception) {
    if (exception is DioException) {
      return handleDioError(exception);
    }
    if (exception is Failure) {
      return exception;
    }
    return UnknownFailure(message: exception.toString());
  }
}
