import 'package:equatable/equatable.dart';
import 'package:startup_app/features/organization/domain/entities/organization.dart';

enum OrganizationStatus { initial, loading, loaded, failure }

class OrganizationState extends Equatable {
  final OrganizationStatus status;
  final List<Organization> organizations;
  final Organization? selectedOrganization;
  final String? errorMessage;

  const OrganizationState({
    this.status = OrganizationStatus.initial,
    this.organizations = const [],
    this.selectedOrganization,
    this.errorMessage,
  });

  OrganizationState copyWith({
    OrganizationStatus? status,
    List<Organization>? organizations,
    Organization? selectedOrganization,
    String? errorMessage,
    bool clearSelected = false,
    bool clearError = false,
  }) {
    return OrganizationState(
      status: status ?? this.status,
      organizations: organizations ?? this.organizations,
      selectedOrganization: clearSelected
          ? null
          : (selectedOrganization ?? this.selectedOrganization),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        organizations,
        selectedOrganization,
        errorMessage,
      ];
}
