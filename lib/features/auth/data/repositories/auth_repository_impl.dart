import 'package:startup_app/core/error/error_handler.dart';
import 'package:startup_app/core/storage/organization_storage.dart';
import 'package:startup_app/core/storage/token_storage.dart';
import 'package:startup_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:startup_app/features/auth/domain/entities/user_entity.dart';
import 'package:startup_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage? tokenStorage;
  final OrganizationStorage? organizationStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    this.tokenStorage,
    this.organizationStorage,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(email: email, password: password);
      await tokenStorage?.saveTokens(
        'access_token_placeholder',
        'refresh_token_placeholder',
      );
      return user;
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      throw ErrorHandler.handleException(e);
    } finally {
      await tokenStorage?.clear();
      await organizationStorage?.clear();
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> sendResetCode({required String email}) async {
    try {
      await remoteDataSource.sendResetCode(email: email);
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }

  @override
  Future<void> verifyCode({required String email, required String code}) async {
    try {
      await remoteDataSource.verifyCode(email: email, code: code);
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }
}
