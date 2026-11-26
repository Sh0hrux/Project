import 'package:startup_app/core/error/error_handler.dart';
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
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }
}
