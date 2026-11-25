import 'package:startup_app/core/error/exceptions.dart';
import 'package:startup_app/core/error/failures.dart';
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
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<UserProfile> updateProfile({required String name}) async {
    try {
      return await remoteDataSource.updateProfile(name: name);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }
}
