import 'package:startup_app/core/error/exceptions.dart';
import 'package:startup_app/core/network/api_endpoints.dart';
import 'package:startup_app/core/network/dio_client.dart';
import 'package:startup_app/features/organization/data/models/organization_model.dart';

abstract class OrganizationRemoteDataSource {
  Future<List<OrganizationModel>> getOrganizations();
}

class OrganizationRemoteDataSourceImpl implements OrganizationRemoteDataSource {
  final DioClient client;

  OrganizationRemoteDataSourceImpl({required this.client});

  @override
  Future<List<OrganizationModel>> getOrganizations() async {
    final response = await client.get(ApiEndpoints.organizations);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(OrganizationModel.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(OrganizationModel.fromJson)
          .toList();
    }
    throw const ServerException(
      message: "Tashkilotlar ro'yxati noto'g'ri formatda",
    );
  }
}

class MockOrganizationRemoteDataSourceImpl
    implements OrganizationRemoteDataSource {
  @override
  Future<List<OrganizationModel>> getOrganizations() async {
    return const [
      OrganizationModel(id: 'org_1', name: 'TechCorp Uzbekistan'),
      OrganizationModel(id: 'org_2', name: 'StartupHub'),
      OrganizationModel(id: 'org_3', name: 'FinSolutions'),
      OrganizationModel(id: 'org_4', name: 'EduLab'),
    ];
  }
}
