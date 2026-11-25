import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:startup_app/core/error/failures.dart';
import 'package:startup_app/features/profile/domain/entities/user_profile.dart';
import 'package:startup_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:startup_app/features/profile/presentation/bloc/profile_bloc.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockProfileRepository;

  const testProfile = UserProfile(
    id: 'user_1',
    name: 'Shohrux',
    email: 'user@startup.uz',
  );

  const updatedProfile = UserProfile(
    id: 'user_1',
    name: 'Shohruxbek',
    email: 'user@startup.uz',
  );

  setUp(() {
    mockProfileRepository = MockProfileRepository();
  });

  group('ProfileBloc Unit Tests', () {
    blocTest<ProfileBloc, ProfileState>(
      '1. LoadProfileEvent muvaffaqiyatli yuklanganda [loading, loaded] chiqaradi',
      build: () {
        when(() => mockProfileRepository.getProfile())
            .thenAnswer((_) async => testProfile);
        return ProfileBloc(profileRepository: mockProfileRepository);
      },
      act: (bloc) => bloc.add(const LoadProfileEvent()),
      expect: () => [
        const ProfileState(status: ProfileStatus.loading),
        const ProfileState(status: ProfileStatus.loaded, profile: testProfile),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      '2. UpdateProfileEvent ismni yangilaganda [updating, loaded] chiqaradi',
      build: () {
        when(() => mockProfileRepository.updateProfile(name: 'Shohruxbek'))
            .thenAnswer((_) async => updatedProfile);
        return ProfileBloc(profileRepository: mockProfileRepository);
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: testProfile,
      ),
      act: (bloc) => bloc.add(const UpdateProfileEvent(name: 'Shohruxbek')),
      expect: () => [
        const ProfileState(
          status: ProfileStatus.updating,
          profile: testProfile,
        ),
        const ProfileState(
          status: ProfileStatus.loaded,
          profile: updatedProfile,
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      '3. Xatolik yuz berganda [loading, failure] chiqaradi',
      build: () {
        when(() => mockProfileRepository.getProfile()).thenThrow(
          const ServerFailure(message: 'Profil topilmadi', statusCode: 404),
        );
        return ProfileBloc(profileRepository: mockProfileRepository);
      },
      act: (bloc) => bloc.add(const LoadProfileEvent()),
      expect: () => [
        const ProfileState(status: ProfileStatus.loading),
        const ProfileState(
          status: ProfileStatus.failure,
          errorMessage: 'Profil topilmadi',
        ),
      ],
    );
  });
}
