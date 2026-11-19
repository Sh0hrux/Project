import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/core/theme/theme_cubit.dart';

void main() {
  group('ThemeCubit Unit Tests', () {
    late ThemeCubit themeCubit;

    setUp(() {
      themeCubit = ThemeCubit();
    });

    tearDown(() {
      themeCubit.close();
    });

    test('1. Boshlang\'ich rejim ThemeMode.system bo\'lishi kerak', () {
      expect(themeCubit.state, ThemeMode.system);
    });

    test('2. setThemeMode berilgan rejimga to\'g\'ri o\'tkazishi kerak', () {
      themeCubit.setThemeMode(ThemeMode.dark);
      expect(themeCubit.state, ThemeMode.dark);

      themeCubit.setThemeMode(ThemeMode.light);
      expect(themeCubit.state, ThemeMode.light);
    });

    test('3. toggleTheme light va dark o\'rtasida to\'g\'ri almashtirishi kerak', () {
      themeCubit.setThemeMode(ThemeMode.light);
      themeCubit.toggleTheme();
      expect(themeCubit.state, ThemeMode.dark);

      themeCubit.toggleTheme();
      expect(themeCubit.state, ThemeMode.light);
    });
  });
}
