import 'package:startup_app/features/organization/data/models/organization_model.dart';

abstract class OrganizationRemoteDataSource {
  Future<List<OrganizationModel>> getOrganizations();
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
