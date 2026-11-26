import 'package:startup_app/core/network/token_refresher.dart';

class MockTokenRefresher implements TokenRefresher {
  @override
  Future<String?> refresh(String refreshToken) async {
    if (refreshToken == 'invalid_refresh_token') {
      return null;
    }
    return 'new_mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
  }
}
