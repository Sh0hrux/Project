import 'package:startup_app/core/error/failures.dart';
import 'package:startup_app/core/storage/token_storage.dart';
import 'package:startup_app/features/auth/domain/entities/user_entity.dart';
import 'package:startup_app/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepositoryImpl implements AuthRepository {
  final TokenStorage? _tokenStorage;
  UserEntity? _currentUser;

  MockAuthRepositoryImpl({TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().toLowerCase() == 'error@test.com') {
      throw const ServerFailure(
        message: 'Serverda xatolik yuz berdi. Iltimos keyinroq qayta urining.',
        statusCode: 500,
      );
    }

    _currentUser = UserEntity(
      id: 'mock_user_1',
      email: email,
      name: email.split('@').first,
    );

    await _tokenStorage?.saveTokens(
      'mock_access_token',
      'mock_refresh_token',
    );

    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    await _tokenStorage?.clear();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _currentUser;
  }
}
