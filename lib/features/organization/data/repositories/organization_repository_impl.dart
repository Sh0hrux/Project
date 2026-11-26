import 'package:startup_app/core/error/exceptions.dart';
import 'package:startup_app/core/error/failures.dart';
import 'package:startup_app/features/organization/data/datasources/organization_remote_data_source.dart';
import 'package:startup_app/features/organization/domain/entities/organization.dart';
import 'package:startup_app/features/organization/domain/repositories/organization_repository.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  final OrganizationRemoteDataSource remoteDataSource;

  OrganizationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Organization>> getOrganizations() async {
    try {
      return await remoteDataSource.getOrganizations();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }
}
