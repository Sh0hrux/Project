import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = "Internet bilan aloqa mavjud emas",
    super.statusCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = "Keshdan ma'lumot olishda xatolik yuz berdi",
    super.statusCode,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = "Avtorizatsiyadan o'tilmagan",
    super.statusCode = 401,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = "Kutilmagan xatolik yuz berdi",
    super.statusCode,
  });
}
