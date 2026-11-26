import 'package:startup_app/core/error/exceptions.dart';
import 'package:startup_app/core/network/api_endpoints.dart';
import 'package:startup_app/core/network/dio_client.dart';
import 'package:startup_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<void> sendResetCode({required String email});

  Future<void> verifyCode({required String email, required String code});

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final userJson = data['user'] is Map<String, dynamic>
          ? data['user'] as Map<String, dynamic>
          : data;
      return UserModel.fromJson(userJson);
    }
    throw const ServerException(
      message: "Login javobi noto'g'ri formatda",
    );
  }

  @override
  Future<void> logout() async {
    await client.post(ApiEndpoints.logout);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final response = await client.get(ApiEndpoints.profile);
    if (response.data is Map<String, dynamic>) {
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<void> sendResetCode({required String email}) async {
    await client.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }

  @override
  Future<void> verifyCode({required String email, required String code}) async {
    await client.post(
      ApiEndpoints.verifyCode,
      data: {'email': email, 'code': code},
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await client.post(
      ApiEndpoints.resetPassword,
      data: {
        'email': email,
        'code': code,
        'new_password': newPassword,
      },
    );
  }
}
