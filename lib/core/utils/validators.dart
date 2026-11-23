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
}
