import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/core/network/auth_interceptor.dart';
import 'package:startup_app/core/storage/organization_storage.dart';
import 'package:startup_app/core/storage/token_storage.dart';

class FakeTokenStorage implements TokenStorage {
  String? _accessToken;
  String? _refreshToken;
  bool clearCalled = false;

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  Future<String?> getAccessToken() async => _accessToken;

  @override
  Future<String?> getRefreshToken() async => _refreshToken;

  @override
  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    clearCalled = true;
  }
}

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

class _TestRequestInterceptorHandler extends RequestInterceptorHandler {
  @override
  void next(RequestOptions requestOptions) {}
}

class _TestErrorInterceptorHandler extends ErrorInterceptorHandler {
  bool nextCalled = false;
  bool resolveCalled = false;

  @override
  void next(DioException err) {
    nextCalled = true;
  }

  @override
  void resolve(Response response) {
    resolveCalled = true;
  }
}

void main() {
  group('AuthInterceptor 401 & Session Tests', () {
    late FakeTokenStorage fakeStorage;

    setUp(() {
      fakeStorage = FakeTokenStorage();
    });

    test('1. 401 javob kelganda va refresh token bo\'lmasa avtomatik logout va clear bo\'ladi', () async {
      bool unauthorizedTriggered = false;
      final interceptor = AuthInterceptor(
        tokenStorage: fakeStorage,
        onUnauthorized: () {
          unauthorizedTriggered = true;
        },
      );

      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/protected'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/protected'),
          statusCode: 401,
        ),
      );

      final handler = _TestErrorInterceptorHandler();

      await interceptor.onError(dioException, handler);

      expect(fakeStorage.clearCalled, isTrue);
      expect(unauthorizedTriggered, isTrue);
      expect(handler.nextCalled, isTrue);
    });

    test('2. 401 javob kelganda va refresh token yaroqsiz bo\'lsa ham logout va clear bo\'ladi', () async {
      await fakeStorage.saveTokens('expired_access', 'invalid_refresh_token');
      bool unauthorizedTriggered = false;
      final interceptor = AuthInterceptor(
        tokenStorage: fakeStorage,
        onUnauthorized: () {
          unauthorizedTriggered = true;
        },
      );

      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/protected'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/protected'),
          statusCode: 401,
        ),
      );

      final handler = _TestErrorInterceptorHandler();

      await interceptor.onError(dioException, handler);

      expect(fakeStorage.clearCalled, isTrue);
      expect(unauthorizedTriggered, isTrue);
      expect(await fakeStorage.getAccessToken(), isNull);
    });

    test('3. 401 javob kelganda yaroqli refresh token bo\'lsa yangi access token saqlanadi', () async {
      await fakeStorage.saveTokens('expired_access', 'valid_refresh_token');
      bool unauthorizedTriggered = false;
      final interceptor = AuthInterceptor(
        tokenStorage: fakeStorage,
        onUnauthorized: () {
          unauthorizedTriggered = true;
        },
      );

      final newAccessToken = await interceptor.mockRefreshAccessToken('valid_refresh_token');
      expect(newAccessToken, isNotNull);
      expect(newAccessToken, startsWith('new_mock_access_token_'));
      expect(unauthorizedTriggered, isFalse);
    });

    test('4. AuthInterceptor tanlangan tashkilot ID sini X-Organization-Id headeriga qo\'shadi', () async {
      final fakeOrgStorage = FakeOrganizationStorage();
      await fakeOrgStorage.saveOrganizationId('org_42');
      await fakeStorage.saveTokens('token_abc', 'refresh_abc');

      final interceptor = AuthInterceptor(
        tokenStorage: fakeStorage,
        organizationStorage: fakeOrgStorage,
      );

      final options = RequestOptions(path: '/api/v1/tasks');
      final handler = _TestRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer token_abc');
      expect(options.headers['X-Organization-Id'], 'org_42');
    });
  });
}
