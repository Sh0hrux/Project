import 'package:startup_app/core/error/failures.dart';
import 'package:startup_app/core/storage/token_storage.dart';
import 'package:startup_app/features/auth/domain/entities/user_entity.dart';
import 'package:startup_app/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepositoryImpl implements AuthRepository {
  final TokenStorage? tokenStorage;
  UserEntity? _currentUser;

  MockAuthRepositoryImpl({this.tokenStorage});

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

    await tokenStorage?.saveTokens(
      'mock_access_token',
      'mock_refresh_token',
    );

    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    await tokenStorage?.clear();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await tokenStorage?.getAccessToken();
    if (token != null && token.isNotEmpty) {
      _currentUser ??= const UserEntity(
        id: 'mock_user_1',
        email: 'user@startup.uz',
        name: 'user',
      );
      return _currentUser;
    }
    return null;
  }

  @override
  Future<void> sendResetCode({required String email}) async {
    if (email.trim().toLowerCase() == 'error@test.com') {
      throw const ServerFailure(
        message: 'Tarmoq yoki server xatosi. Kod yuborilmadi.',
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> verifyCode({required String email, required String code}) async {
    if (code.trim() != '123456') {
      throw const ServerFailure(
        message: 'Tasdiqlash kodi noto\'g\'ri. (Mock: 123456)',
        statusCode: 400,
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    if (email.trim().toLowerCase() == 'error@test.com') {
      throw const ServerFailure(
        message: 'Parolni yangilashda server xatoligi yuz berdi.',
        statusCode: 500,
      );
    }
  }
}
