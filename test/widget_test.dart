import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/app.dart';
import 'package:startup_app/features/auth/domain/entities/user_entity.dart';
import 'package:startup_app/features/auth/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<UserEntity?> getCurrentUser() async => null;

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    return const UserEntity(id: '1', email: 'test@example.com');
  }

  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(App(authRepository: FakeAuthRepository()));
    expect(find.text('Ilova yuklanmoqda...'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Xush kelibsiz'), findsOneWidget);
  });
}
