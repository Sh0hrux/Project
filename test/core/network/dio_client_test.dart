import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/core/network/api_endpoints.dart';
import 'package:startup_app/core/network/dio_client.dart';
import 'package:startup_app/core/storage/organization_storage.dart';
import 'package:startup_app/core/storage/token_storage.dart';

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

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequestOptions = options;
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

void main() {
  test(
    'DioClient so\'rovida Authorization va X-Organization-Id headerlari yuboriladi',
    () async {
      final fakeAdapter = _FakeHttpClientAdapter();
      final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl))
        ..httpClientAdapter = fakeAdapter;

      final client = DioClient(
        dio: dio,
        tokenStorage: _FakeTokenStorage(
          accessToken: 'secret_access_123',
          refreshToken: 'secret_refresh_456',
        ),
        organizationStorage: _FakeOrganizationStorage(orgId: 'org_99'),
      );

      final response = await client.get(ApiEndpoints.organizations);

      expect(response.statusCode, 200);
      expect(fakeAdapter.lastRequestOptions, isNotNull);
      expect(
        fakeAdapter.lastRequestOptions!.headers['Authorization'],
        'Bearer secret_access_123',
      );
      expect(
        fakeAdapter.lastRequestOptions!.headers['X-Organization-Id'],
        'org_99',
      );
    },
  );
}
