import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/core/error/exceptions.dart';
import 'package:startup_app/core/network/api_endpoints.dart';
import 'package:startup_app/core/network/auth_interceptor.dart';
import 'package:startup_app/core/network/dio_client.dart';
import 'package:startup_app/core/network/token_refresher.dart';
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
  bool clearCalled = false;

  @override
  Future<void> saveOrganizationId(String organizationId) async {
    _orgId = organizationId;
  }

  @override
  Future<String?> getOrganizationId() async => _orgId;

  @override
  Future<void> clear() async {
    _orgId = null;
    clearCalled = true;
  }
}

class _CountingTokenRefresher implements TokenRefresher {
  int callCount = 0;
  final Future<String?> Function(String refreshToken) onRefresh;

  _CountingTokenRefresher(this.onRefresh);

  @override
  Future<String?> refresh(String refreshToken) async {
    callCount++;
    return onRefresh(refreshToken);
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

class _FakeHttpClientAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  _FakeHttpClientAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) =>
      handler(options);

  @override
  void close({bool force = false}) {}
}

void main() {
  group('AuthInterceptor 401 & TokenRefresher Tests', () {
    late FakeTokenStorage fakeStorage;
    late FakeOrganizationStorage fakeOrgStorage;

    setUp(() {
      fakeStorage = FakeTokenStorage();
      fakeOrgStorage = FakeOrganizationStorage();
    });

    test('1. 401 javob kelganda va refresh token bo\'lmasa avtomatik logout va clear bo\'ladi', () async {
      await fakeOrgStorage.saveOrganizationId('org_1');
      bool unauthorizedTriggered = false;
      final refresher = _CountingTokenRefresher((_) async => 'unused');
      final interceptor = AuthInterceptor(
        tokenStorage: fakeStorage,
        tokenRefresher: refresher,
        organizationStorage: fakeOrgStorage,
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

      expect(refresher.callCount, 0);
      expect(fakeStorage.clearCalled, isTrue);
      expect(fakeOrgStorage.clearCalled, isTrue);
      expect(unauthorizedTriggered, isTrue);
      expect(handler.nextCalled, isTrue);
    });

    test('2. Refresh muvaffaqiyatsiz bo\'lsa tokenlar, tashkilot tozalanadi va logout bo\'ladi', () async {
      await fakeStorage.saveTokens('expired_access', 'invalid_refresh_token');
      await fakeOrgStorage.saveOrganizationId('org_1');
      bool unauthorizedTriggered = false;

      final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl))
        ..httpClientAdapter = _FakeHttpClientAdapter((options) async {
          return ResponseBody.fromString(
            jsonEncode({'message': 'Unauthorized'}),
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

      final client = DioClient(
        dio: dio,
        tokenStorage: fakeStorage,
        organizationStorage: fakeOrgStorage,
        tokenRefresher: _CountingTokenRefresher((_) async => null),
        onUnauthorized: () {
          unauthorizedTriggered = true;
        },
      );

      await expectLater(
        client.get('/protected'),
        throwsA(isA<UnauthorizedException>()),
      );

      expect(fakeStorage.clearCalled, isTrue);
      expect(fakeOrgStorage.clearCalled, isTrue);
      expect(unauthorizedTriggered, isTrue);
      expect(await fakeStorage.getAccessToken(), isNull);
      expect(await fakeOrgStorage.getOrganizationId(), isNull);
    });

    test('3. Refresh muvaffaqiyatli bo\'lsa yangi token saqlanadi va so\'rov asl DioClient orqali qayta yuboriladi', () async {
      await fakeStorage.saveTokens('expired_access', 'valid_refresh_token');
      await fakeOrgStorage.saveOrganizationId('org_1');
      bool unauthorizedTriggered = false;
      final observedAuthHeaders = <String?>[];

      final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl))
        ..httpClientAdapter = _FakeHttpClientAdapter((options) async {
          observedAuthHeaders.add(options.headers['Authorization']?.toString());
          if (options.headers['Authorization'] == 'Bearer fresh_access_token') {
            return ResponseBody.fromString(
              jsonEncode({'ok': true}),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          return ResponseBody.fromString(
            jsonEncode({'message': 'Expired'}),
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

      final refresher = _CountingTokenRefresher((token) async {
        expect(token, 'valid_refresh_token');
        return 'fresh_access_token';
      });

      final client = DioClient(
        dio: dio,
        tokenStorage: fakeStorage,
        organizationStorage: fakeOrgStorage,
        tokenRefresher: refresher,
        onUnauthorized: () {
          unauthorizedTriggered = true;
        },
      );

      final response = await client.get<Map<String, dynamic>>('/protected');

      expect(response.statusCode, 200);
      expect(response.data?['ok'], isTrue);
      expect(refresher.callCount, 1);
      expect(observedAuthHeaders, [
        'Bearer expired_access',
        'Bearer fresh_access_token',
      ]);
      expect(await fakeStorage.getAccessToken(), 'fresh_access_token');
      expect(unauthorizedTriggered, isFalse);
    });

    test('4. Ikki parallel 401 da refresh faqat bir marta chaqiriladi', () async {
      await fakeStorage.saveTokens('expired_access', 'valid_refresh_token');
      await fakeOrgStorage.saveOrganizationId('org_1');

      final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl))
        ..httpClientAdapter = _FakeHttpClientAdapter((options) async {
          if (options.headers['Authorization'] == 'Bearer shared_new_token') {
            return ResponseBody.fromString(
              jsonEncode({'path': options.path}),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          return ResponseBody.fromString(
            jsonEncode({'message': 'Expired'}),
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

      final refresher = _CountingTokenRefresher((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return 'shared_new_token';
      });

      final client = DioClient(
        dio: dio,
        tokenStorage: fakeStorage,
        organizationStorage: fakeOrgStorage,
        tokenRefresher: refresher,
      );

      final results = await Future.wait([
        client.get<Map<String, dynamic>>('/first'),
        client.get<Map<String, dynamic>>('/second'),
      ]);

      expect(refresher.callCount, 1);
      expect(results[0].statusCode, 200);
      expect(results[0].data?['path'], '/first');
      expect(results[1].statusCode, 200);
      expect(results[1].data?['path'], '/second');
    });

    test('5. Qayta urinishda yana 401 kelsa cheksiz tsikl bo\'lmaydi va logout qilinadi', () async {
      await fakeStorage.saveTokens('expired_access', 'valid_refresh_token');
      bool unauthorizedTriggered = false;

      final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl))
        ..httpClientAdapter = _FakeHttpClientAdapter((options) async {
          return ResponseBody.fromString(
            jsonEncode({'message': 'Still unauthorized'}),
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

      final refresher = _CountingTokenRefresher((_) async => 'still_bad_token');

      final client = DioClient(
        dio: dio,
        tokenStorage: fakeStorage,
        organizationStorage: fakeOrgStorage,
        tokenRefresher: refresher,
        onUnauthorized: () {
          unauthorizedTriggered = true;
        },
      );

      await expectLater(
        client.get('/protected'),
        throwsA(isA<UnauthorizedException>()),
      );

      expect(refresher.callCount, 1);
      expect(fakeStorage.clearCalled, isTrue);
      expect(unauthorizedTriggered, isTrue);
    });

    test('6. AuthInterceptor tanlangan tashkilot ID sini X-Organization-Id headeriga qo\'shadi', () async {
      await fakeOrgStorage.saveOrganizationId('org_42');
      await fakeStorage.saveTokens('token_abc', 'refresh_abc');

      final interceptor = AuthInterceptor(
        tokenStorage: fakeStorage,
        tokenRefresher: _CountingTokenRefresher((_) async => null),
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
