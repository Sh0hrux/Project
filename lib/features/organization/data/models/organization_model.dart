import 'package:startup_app/features/organization/domain/entities/organization.dart';

class OrganizationModel extends Organization {
  const OrganizationModel({
    required super.id,
    required super.name,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
