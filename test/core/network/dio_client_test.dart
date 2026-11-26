import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/core/error/failures.dart';
import 'package:startup_app/core/network/api_endpoints.dart';
import 'package:startup_app/core/network/dio_client.dart';
import 'package:startup_app/core/network/mock_token_refresher.dart';
import 'package:startup_app/core/storage/organization_storage.dart';
import 'package:startup_app/core/storage/token_storage.dart';
import 'package:startup_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:startup_app/features/organization/data/datasources/organization_remote_data_source.dart';
import 'package:startup_app/features/organization/data/repositories/organization_repository_impl.dart';
import 'package:startup_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:startup_app/features/profile/data/repositories/profile_repository_impl.dart';

class _FakeTokenStorage implements TokenStorage {
  final String? accessToken;
  final String? refreshToken;

  _FakeTokenStorage({this.accessToken, this.refreshToken});

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {}

  @override
  Future<String?> getAccessToken() async => accessToken;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<void> clear() async {}
}

class _FakeOrganizationStorage implements OrganizationStorage {
  final String? orgId;

  _FakeOrganizationStorage({this.orgId});

  @override
  Future<void> saveOrganizationId(String organizationId) async {}

  @override
  Future<String?> getOrganizationId() async => orgId;

  @override
  Future<void> clear() async {}
}

class _FakeHttpClientAdapter implements HttpClientAdapter {
  RequestOptions? lastRequestOptions;
  final Future<ResponseBody> Function(RequestOptions options)? onFetch;

  _FakeHttpClientAdapter({this.onFetch});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequestOptions = options;
    if (onFetch != null) {
      return onFetch!(options);
    }
    return ResponseBody.fromString(
      jsonEncode({'status': 'ok'}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonResponse(Object data, {int statusCode = 200}) {
  return ResponseBody.fromString(
    jsonEncode(data),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  DioClient createTestClient(
    _FakeHttpClientAdapter adapter, {
    String? accessToken = 'secret_access_123',
    String? refreshToken,
    String? orgId = 'org_99',
  }) {
    final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl))
      ..httpClientAdapter = adapter;

    return DioClient(
      dio: dio,
      tokenStorage: _FakeTokenStorage(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
      organizationStorage: _FakeOrganizationStorage(orgId: orgId),
      tokenRefresher: MockTokenRefresher(),
    );
  }

  group('DioClient & RemoteDataSource Integration Tests', () {
    test(
      '1. DioClient so\'rovida Authorization va X-Organization-Id headerlari yuboriladi',
      () async {
        final adapter = _FakeHttpClientAdapter();
        final client = createTestClient(adapter);

        final response = await client.get(ApiEndpoints.organizations);

        expect(response.statusCode, 200);
        expect(adapter.lastRequestOptions?.path, ApiEndpoints.organizations);
        expect(
          adapter.lastRequestOptions?.headers['Authorization'],
          'Bearer secret_access_123',
        );
        expect(
          adapter.lastRequestOptions?.headers['X-Organization-Id'],
          'org_99',
        );
      },
    );

    test(
      '2. AuthRemoteDataSourceImpl login to\'g\'ri yo\'lga yuboradi va UserModel qaytaradi',
      () async {
        final adapter = _FakeHttpClientAdapter(
          onFetch: (options) async => _jsonResponse({
            'id': 'u_1',
            'email': 'shohrux@startup.uz',
            'name': 'Shohrux',
          }),
        );
        final client = createTestClient(adapter, accessToken: null, orgId: null);
        final dataSource = AuthRemoteDataSourceImpl(client: client);

        final user = await dataSource.login(
          email: 'shohrux@startup.uz',
          password: 'password123',
        );

        expect(adapter.lastRequestOptions?.method, 'POST');
        expect(adapter.lastRequestOptions?.path, ApiEndpoints.login);
        expect(user.id, 'u_1');
        expect(user.email, 'shohrux@startup.uz');
        expect(user.name, 'Shohrux');
      },
    );

    test(
      '3. ProfileRemoteDataSourceImpl to\'g\'ri yo\'l va headerlar bilan UserProfileModel qaytaradi',
      () async {
        final adapter = _FakeHttpClientAdapter(
          onFetch: (options) async => _jsonResponse({
            'id': 'u_1',
            'name': 'Shohrux',
            'email': 'shohrux@startup.uz',
            'avatar_url': 'https://example.com/avatar.png',
          }),
        );
        final client = createTestClient(adapter);
        final dataSource = ProfileRemoteDataSourceImpl(client: client);

        final profile = await dataSource.getProfile();

        expect(adapter.lastRequestOptions?.method, 'GET');
        expect(adapter.lastRequestOptions?.path, ApiEndpoints.profile);
        expect(
          adapter.lastRequestOptions?.headers['Authorization'],
          'Bearer secret_access_123',
        );
        expect(
          adapter.lastRequestOptions?.headers['X-Organization-Id'],
          'org_99',
        );
        expect(profile.id, 'u_1');
        expect(profile.name, 'Shohrux');
        expect(profile.avatarUrl, 'https://example.com/avatar.png');
      },
    );

    test(
      '4. OrganizationRemoteDataSourceImpl to\'g\'ri yo\'l va headerlar bilan OrganizationModel ro\'yxatini qaytaradi',
      () async {
        final adapter = _FakeHttpClientAdapter(
          onFetch: (options) async => _jsonResponse([
            {'id': 'org_1', 'name': 'TechCorp'},
            {'id': 'org_2', 'name': 'FinSolutions'},
          ]),
        );
        final client = createTestClient(adapter);
        final dataSource = OrganizationRemoteDataSourceImpl(client: client);

        final orgs = await dataSource.getOrganizations();

        expect(adapter.lastRequestOptions?.method, 'GET');
        expect(adapter.lastRequestOptions?.path, ApiEndpoints.organizations);
        expect(
          adapter.lastRequestOptions?.headers['Authorization'],
          'Bearer secret_access_123',
        );
        expect(
          adapter.lastRequestOptions?.headers['X-Organization-Id'],
          'org_99',
        );
        expect(orgs.length, 2);
        expect(orgs[0].id, 'org_1');
        expect(orgs[0].name, 'TechCorp');
        expect(orgs[1].id, 'org_2');
      },
    );

    test(
      '5. Dio xatolari (timeout, 401, 5xx) repozitoriyda mos Failure turlariga aylanadi',
      () async {
        // Timeout -> NetworkFailure
        final timeoutAdapter = _FakeHttpClientAdapter(
          onFetch: (options) async => throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          ),
        );
        final timeoutRepo = ProfileRepositoryImpl(
          remoteDataSource: ProfileRemoteDataSourceImpl(
            client: createTestClient(timeoutAdapter),
          ),
        );
        await expectLater(
          timeoutRepo.getProfile(),
          throwsA(isA<NetworkFailure>()),
        );

        // 401 -> UnauthorizedFailure
        final unauthAdapter = _FakeHttpClientAdapter(
          onFetch: (options) async => _jsonResponse(
            {'message': 'Token yaroqsiz'},
            statusCode: 401,
          ),
        );
        final unauthRepo = OrganizationRepositoryImpl(
          remoteDataSource: OrganizationRemoteDataSourceImpl(
            client: createTestClient(unauthAdapter),
          ),
        );
        await expectLater(
          unauthRepo.getOrganizations(),
          throwsA(isA<UnauthorizedFailure>()),
        );

        // 500 -> ServerFailure
        final serverAdapter = _FakeHttpClientAdapter(
          onFetch: (options) async => _jsonResponse(
            {'message': 'Server xatosi'},
            statusCode: 500,
          ),
        );
        final serverRepo = ProfileRepositoryImpl(
          remoteDataSource: ProfileRemoteDataSourceImpl(
            client: createTestClient(serverAdapter),
          ),
        );
        await expectLater(
          serverRepo.getProfile(),
          throwsA(
            isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 500),
          ),
        );
      },
    );
  });
}
