import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/core/network/auth_interceptor.dart';
import 'package:startup_app/core/storage/token_storage.dart';
import 'package:startup_app/features/auth/data/repositories/mock_auth_repository_impl.dart';

class FakeTokenStorage implements TokenStorage {
  String? _accessToken;
  String? _refreshToken;

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
  }
}

class _TestRequestInterceptorHandler extends RequestInterceptorHandler {
  bool nextCalled = false;

  @override
  void next(RequestOptions requestOptions) {
    nextCalled = true;
    super.next(requestOptions);
  }
}

void main() {
  group('TokenStorage & AuthInterceptor Tests', () {
    late FakeTokenStorage fakeStorage;

    setUp(() {
      fakeStorage = FakeTokenStorage();
    });

    test('1. saveTokens access va refresh tokenlarni to\'g\'ri saqlaydi va o\'qiydi', () async {
      await fakeStorage.saveTokens('access_123', 'refresh_456');

      expect(await fakeStorage.getAccessToken(), 'access_123');
      expect(await fakeStorage.getRefreshToken(), 'refresh_456');
    });

    test('2. clear barcha saqlangan tokenlarni tozalaydi', () async {
      await fakeStorage.saveTokens('access_123', 'refresh_456');
      await fakeStorage.clear();

      expect(await fakeStorage.getAccessToken(), isNull);
      expect(await fakeStorage.getRefreshToken(), isNull);
    });

    test('3. AuthInterceptor token mavjud bo\'lsa, headerga Bearer token qo\'shadi', () async {
      await fakeStorage.saveTokens('my_jwt_token', 'my_refresh_token');
      final interceptor = AuthInterceptor(tokenStorage: fakeStorage);

      final options = RequestOptions(path: '/api/v1/profile');
      final handler = _TestRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer my_jwt_token');
      expect(handler.nextCalled, isTrue);
    });

    test('4. AuthInterceptor token yo\'q bo\'lsa, Authorization header qo\'shmaydi', () async {
      final interceptor = AuthInterceptor(tokenStorage: fakeStorage);

      final options = RequestOptions(path: '/api/v1/public');
      final handler = _TestRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('Authorization'), isFalse);
      expect(handler.nextCalled, isTrue);
    });

    test('5. MockAuthRepositoryImpl login qilganda tokenlarni saqlaydi va logout da tozalaydi', () async {
      final authRepository = MockAuthRepositoryImpl(tokenStorage: fakeStorage);

      expect(await fakeStorage.getAccessToken(), isNull);

      await authRepository.login(email: 'user@test.com', password: 'password123');
      expect(await fakeStorage.getAccessToken(), isNotNull);
      expect(await fakeStorage.getRefreshToken(), isNotNull);

      await authRepository.logout();
      expect(await fakeStorage.getAccessToken(), isNull);
      expect(await fakeStorage.getRefreshToken(), isNull);
    });
  });
}
