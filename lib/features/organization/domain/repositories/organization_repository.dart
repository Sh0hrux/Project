import 'package:startup_app/features/organization/domain/entities/organization.dart';

abstract class OrganizationRepository {
  Future<List<Organization>> getOrganizations();
}
