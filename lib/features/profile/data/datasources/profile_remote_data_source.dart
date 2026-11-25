import 'package:startup_app/core/error/exceptions.dart';
import 'package:startup_app/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile({required String name});
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
