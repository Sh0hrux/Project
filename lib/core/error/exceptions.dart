class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException(message: $message, statusCode: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = "Internet bilan aloqa yo'q"});

  @override
  String toString() => 'NetworkException(message: $message)';
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = "Kesh xatoligi"});

  @override
  String toString() => 'CacheException(message: $message)';
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({this.message = "Avtorizatsiyadan o'tilmagan"});

  @override
  String toString() => 'UnauthorizedException(message: $message)';
}
