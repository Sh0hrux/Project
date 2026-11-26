import 'package:equatable/equatable.dart';
import 'package:startup_app/features/organization/domain/entities/organization.dart';

abstract class OrganizationEvent extends Equatable {
  const OrganizationEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrganizationsEvent extends OrganizationEvent {
  const LoadOrganizationsEvent();
}

class SelectOrganizationEvent extends OrganizationEvent {
  final Organization organization;

  const SelectOrganizationEvent({required this.organization});

  @override
  List<Object?> get props => [organization];
}

class ClearOrganizationEvent extends OrganizationEvent {
  const ClearOrganizationEvent();
}
