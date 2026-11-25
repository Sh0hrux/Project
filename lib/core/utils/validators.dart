class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
  );

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email kiriting';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Yaroqli email kiriting';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Parol kiriting';
    }
    if (value.length < 6) {
      return 'Parol kamida 6 belgidan iborat bo\'lishi kerak';
    }
    return null;
  }

  static String? validateResetCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tasdiqlash kodini kiriting';
    }
    if (value.trim().length != 6) {
      return 'Kod 6 ta belgidan iborat bo\'lishi kerak';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Parolni tasdiqlang';
    }
    if (value != password) {
      return 'Parollar mos kelmadi';
    }
    return null;
  }
}
