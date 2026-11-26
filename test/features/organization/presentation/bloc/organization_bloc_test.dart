import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:startup_app/core/error/failures.dart';
import 'package:startup_app/core/storage/organization_storage.dart';
import 'package:startup_app/features/organization/domain/entities/organization.dart';
import 'package:startup_app/features/organization/domain/repositories/organization_repository.dart';
import 'package:startup_app/features/organization/presentation/bloc/organization_bloc.dart';

class MockOrganizationRepository extends Mock
    implements OrganizationRepository {}

class FakeOrganizationStorage implements OrganizationStorage {
  String? _orgId;

  @override
  Future<void> saveOrganizationId(String organizationId) async {
    _orgId = organizationId;
  }

  @override
  Future<String?> getOrganizationId() async => _orgId;

  @override
  Future<void> clear() async {
    _orgId = null;
  }
}

void main() {
  late MockOrganizationRepository mockRepository;
  late FakeOrganizationStorage fakeStorage;

  const orgs = [
    Organization(id: 'org_1', name: 'TechCorp'),
    Organization(id: 'org_2', name: 'StartupHub'),
  ];

  setUp(() {
    mockRepository = MockOrganizationRepository();
    fakeStorage = FakeOrganizationStorage();
  });

  group('OrganizationBloc Unit Tests', () {
    blocTest<OrganizationBloc, OrganizationState>(
      '1. LoadOrganizationsEvent muvaffaqiyatli yuklanganda [loading, loaded] chiqaradi',
      build: () {
        when(() => mockRepository.getOrganizations())
            .thenAnswer((_) async => orgs);
        return OrganizationBloc(
          organizationRepository: mockRepository,
          organizationStorage: fakeStorage,
        );
      },
      act: (bloc) => bloc.add(const LoadOrganizationsEvent()),
      expect: () => [
        const OrganizationState(status: OrganizationStatus.loading),
        const OrganizationState(
          status: OrganizationStatus.loaded,
          organizations: orgs,
        ),
      ],
    );

    blocTest<OrganizationBloc, OrganizationState>(
      '2. SelectOrganizationEvent tashkilotni tanlaydi va storage ga saqlaydi',
      build: () => OrganizationBloc(
        organizationRepository: mockRepository,
        organizationStorage: fakeStorage,
      ),
      seed: () => const OrganizationState(
        status: OrganizationStatus.loaded,
        organizations: orgs,
      ),
      act: (bloc) =>
          bloc.add(SelectOrganizationEvent(organization: orgs[0])),
      expect: () => [
        OrganizationState(
          status: OrganizationStatus.loaded,
          organizations: orgs,
          selectedOrganization: orgs[0],
        ),
      ],
      verify: (_) async {
        expect(await fakeStorage.getOrganizationId(), 'org_1');
      },
    );

    blocTest<OrganizationBloc, OrganizationState>(
      '3. ClearOrganizationEvent tanlangan tashkilotni va storage ni tozalaydi',
      build: () => OrganizationBloc(
        organizationRepository: mockRepository,
        organizationStorage: fakeStorage,
      ),
      seed: () => OrganizationState(
        status: OrganizationStatus.loaded,
        organizations: orgs,
        selectedOrganization: orgs[0],
      ),
      act: (bloc) => bloc.add(const ClearOrganizationEvent()),
      expect: () => [
        const OrganizationState(
          status: OrganizationStatus.loaded,
          organizations: orgs,
          selectedOrganization: null,
        ),
      ],
      verify: (_) async {
        expect(await fakeStorage.getOrganizationId(), isNull);
      },
    );

    blocTest<OrganizationBloc, OrganizationState>(
      '4. Xatolik bo\'lganda [loading, failure] chiqaradi',
      build: () {
        when(() => mockRepository.getOrganizations()).thenThrow(
          const NetworkFailure(message: 'Internet aloqasi yo\'q'),
        );
        return OrganizationBloc(
          organizationRepository: mockRepository,
          organizationStorage: fakeStorage,
        );
      },
      act: (bloc) => bloc.add(const LoadOrganizationsEvent()),
      expect: () => [
        const OrganizationState(status: OrganizationStatus.loading),
        const OrganizationState(
          status: OrganizationStatus.failure,
          errorMessage: 'Internet aloqasi yo\'q',
        ),
      ],
    );
  });
}
