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
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }
    return UserModel(id: 'mock_user_1', email: email, name: 'Startup Foydalanuvchi');
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
}
