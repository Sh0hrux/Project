import 'package:startup_app/core/error/error_handler.dart';
import 'package:startup_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:startup_app/features/profile/domain/entities/user_profile.dart';
import 'package:startup_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> getProfile() async {
    try {
      return await remoteDataSource.getProfile();
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }

  @override
  Future<UserProfile> updateProfile({required String name}) async {
    try {
      return await remoteDataSource.updateProfile(name: name);
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }
}
