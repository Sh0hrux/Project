import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_app/core/error/failures.dart';
import 'package:startup_app/core/storage/organization_storage.dart';
import 'package:startup_app/features/organization/domain/entities/organization.dart';
import 'package:startup_app/features/organization/domain/repositories/organization_repository.dart';
import 'package:startup_app/features/organization/presentation/bloc/organization_event.dart';
import 'package:startup_app/features/organization/presentation/bloc/organization_state.dart';

export 'organization_event.dart';
export 'organization_state.dart';

class OrganizationBloc extends Bloc<OrganizationEvent, OrganizationState> {
  final OrganizationRepository organizationRepository;
  final OrganizationStorage organizationStorage;

  OrganizationBloc({
    required this.organizationRepository,
    required this.organizationStorage,
  }) : super(const OrganizationState()) {
    on<LoadOrganizationsEvent>(_onLoadOrganizations);
    on<SelectOrganizationEvent>(_onSelectOrganization);
    on<ClearOrganizationEvent>(_onClearOrganization);
  }

  Future<void> _onLoadOrganizations(
    LoadOrganizationsEvent event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(state.copyWith(status: OrganizationStatus.loading, clearError: true));
    try {
      final organizations = await organizationRepository.getOrganizations();
      final savedId = await organizationStorage.getOrganizationId();
      Organization? selected = state.selectedOrganization;
      if (savedId != null) {
        for (final org in organizations) {
          if (org.id == savedId) {
            selected = org;
            break;
          }
        }
      }
      emit(
        state.copyWith(
          status: OrganizationStatus.loaded,
          organizations: organizations,
          selectedOrganization: selected,
        ),
      );
    } on Failure catch (e) {
      emit(
        state.copyWith(
          status: OrganizationStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: OrganizationStatus.failure,
          errorMessage: 'Tashkilotlarni yuklashda xatolik yuz berdi',
        ),
      );
    }
  }

  Future<void> _onSelectOrganization(
    SelectOrganizationEvent event,
    Emitter<OrganizationState> emit,
  ) async {
    await organizationStorage.saveOrganizationId(event.organization.id);
    emit(
      state.copyWith(
        selectedOrganization: event.organization,
      ),
    );
  }

  Future<void> _onClearOrganization(
    ClearOrganizationEvent event,
    Emitter<OrganizationState> emit,
  ) async {
    await organizationStorage.clear();
    emit(state.copyWith(clearSelected: true));
  }
}
