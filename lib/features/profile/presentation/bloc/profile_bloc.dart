import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_app/core/error/failures.dart';
import 'package:startup_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:startup_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:startup_app/features/profile/presentation/bloc/profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(const ProfileState()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));
    try {
      final profile = await profileRepository.getProfile();
      emit(state.copyWith(status: ProfileStatus.loaded, profile: profile));
    } on Failure catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'Profil ma\'lumotlarini yuklashda xatolik yuz berdi',
        ),
      );
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.updating, clearError: true));
    try {
      final updatedProfile =
          await profileRepository.updateProfile(name: event.name);
      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          profile: updatedProfile,
        ),
      );
    } on Failure catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'Profilni yangilashda xatolik yuz berdi',
        ),
      );
    }
  }
}
