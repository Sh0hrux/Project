import 'package:startup_app/core/error/exceptions.dart';
import 'package:startup_app/core/network/api_endpoints.dart';
import 'package:startup_app/core/network/dio_client.dart';
import 'package:startup_app/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile({required String name});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient client;

  ProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<UserProfileModel> getProfile() async {
    final response = await client.get(ApiEndpoints.profile);
    if (response.data is Map<String, dynamic>) {
      return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw const ServerException(
      message: "Profil ma'lumotlari noto'g'ri formatda",
    );
  }

  @override
  Future<UserProfileModel> updateProfile({required String name}) async {
    final response = await client.put(
      ApiEndpoints.profile,
      data: {'name': name.trim()},
    );
    if (response.data is Map<String, dynamic>) {
      return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw const ServerException(
      message: "Profilni yangilash javobi noto'g'ri formatda",
    );
  }
}

class MockProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  UserProfileModel _mockProfile = const UserProfileModel(
    id: 'mock_user_1',
    name: 'Shohrux',
    email: 'user@startup.uz',
    avatarUrl: null,
  );

  @override
  Future<UserProfileModel> getProfile() async {
    return _mockProfile;
  }

  @override
  Future<UserProfileModel> updateProfile({required String name}) async {
    if (name.trim().isEmpty) {
      throw const ServerException(
        message: 'Ism bo\'sh bo\'lishi mumkin emas',
        statusCode: 400,
      );
    }

    _mockProfile = UserProfileModel(
      id: _mockProfile.id,
      name: name.trim(),
      email: _mockProfile.email,
      avatarUrl: _mockProfile.avatarUrl,
    );
    return _mockProfile;
  }
}
