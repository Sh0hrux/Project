import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/core/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateEmail bo\'sh bo\'lganda xatolik qaytaradi', () {
      expect(Validators.validateEmail(null), 'Email kiriting');
      expect(Validators.validateEmail(''), 'Email kiriting');
      expect(Validators.validateEmail('   '), 'Email kiriting');
    });

    test('validateEmail noto\'g\'ri formatda xatolik qaytaradi', () {
      expect(Validators.validateEmail('test'), 'Yaroqli email kiriting');
      expect(Validators.validateEmail('test@'), 'Yaroqli email kiriting');
      expect(Validators.validateEmail('test@domain'), 'Yaroqli email kiriting');
    });

    test('validateEmail to\'g\'ri formatda null qaytaradi', () {
      expect(Validators.validateEmail('user@example.com'), isNull);
      expect(Validators.validateEmail('john.doe@company.uz'), isNull);
    });

    test('validatePassword bo\'sh bo\'lganda xatolik qaytaradi', () {
      expect(Validators.validatePassword(null), 'Parol kiriting');
      expect(Validators.validatePassword(''), 'Parol kiriting');
    });

    test('validatePassword 6 tadan kam bo\'lganda xatolik qaytaradi', () {
      expect(
        Validators.validatePassword('12345'),
        'Parol kamida 6 belgidan iborat bo\'lishi kerak',
      );
    });

    test('validatePassword to\'g\'ri bo\'lganda null qaytaradi', () {
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('secure_password'), isNull);
    });

    test('validateResetCode 6 ta belgidan boshqasida xato qaytaradi', () {
      expect(Validators.validateResetCode(''), 'Tasdiqlash kodini kiriting');
      expect(
        Validators.validateResetCode('123'),
        'Kod 6 ta belgidan iborat bo\'lishi kerak',
      );
      expect(Validators.validateResetCode('123456'), isNull);
    });

    test('validateConfirmPassword parollar mosligini tekshiradi', () {
      expect(
        Validators.validateConfirmPassword('', '123456'),
        'Parolni tasdiqlang',
      );
      expect(
        Validators.validateConfirmPassword('654321', '123456'),
        'Parollar mos kelmadi',
      );
      expect(Validators.validateConfirmPassword('123456', '123456'), isNull);
    });
  });
}
