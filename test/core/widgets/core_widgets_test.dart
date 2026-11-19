import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/core/widgets/app_button.dart';
import 'package:startup_app/core/widgets/app_text_field.dart';
import 'package:startup_app/core/widgets/empty_view.dart';
import 'package:startup_app/core/widgets/error_view.dart';
import 'package:startup_app/core/widgets/loading_indicator.dart';
import 'package:startup_app/core/widgets/loading_overlay.dart';

void main() {
  Widget wrapWithMaterial(Widget widget) {
    return MaterialApp(
      home: Scaffold(body: widget),
    );
  }

  group('Core Widgets Tests', () {
    testWidgets('AppButton turli variantlari va loading holati to\'g\'ri ishlaydi', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          Column(
            children: [
              AppButton.primary(
                text: 'Asosiy',
                onPressed: () => pressed = true,
              ),
              const AppButton.outlined(
                text: 'Konturli',
              ),
              const AppButton.text(
                text: 'Matnli',
              ),
              const AppButton(
                text: 'Yuklanmoqda',
                isLoading: true,
              ),
            ],
          ),
        ),
      );

      expect(find.text('Asosiy'), findsOneWidget);
      expect(find.text('Konturli'), findsOneWidget);
      expect(find.text('Matnli'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.text('Asosiy'));
      expect(pressed, isTrue);
    });

    testWidgets('AppTextField errorText, prefix va suffix ikonkalar bilan to\'g\'ri ishlaydi', (tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          const AppTextField(
            label: 'Foydalanuvchi nomi',
            hint: 'Ismingizni kiriting',
            errorText: 'Maydon bo\'sh bo\'lmasligi kerak',
            prefixIcon: Icon(Icons.person),
            suffixIcon: Icon(Icons.check),
          ),
        ),
      );

      expect(find.text('Foydalanuvchi nomi'), findsOneWidget);
      expect(find.text('Maydon bo\'sh bo\'lmasligi kerak'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('LoadingOverlay isLoading holatiga mos ravishda ishlaydi', (tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          const SizedBox(
            width: 400,
            height: 400,
            child: LoadingOverlay(
              isLoading: true,
              message: 'Yuklanmoqda...',
              child: Text('Kontent'),
            ),
          ),
        ),
      );

      expect(find.text('Kontent'), findsOneWidget);
      expect(find.text('Yuklanmoqda...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('EmptyView sarlavha, matn va harakat tugmasini to\'g\'ri aks ettiradi', (tester) async {
      var actionCalled = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          EmptyView(
            title: 'Ma\'lumot topilmadi',
            message: 'Hozircha hech qanday ma\'lumot mavjud emas',
            actionText: 'Yangilash',
            onAction: () => actionCalled = true,
          ),
        ),
      );

      expect(find.text('Ma\'lumot topilmadi'), findsOneWidget);
      expect(find.text('Hozircha hech qanday ma\'lumot mavjud emas'), findsOneWidget);
      expect(find.text('Yangilash'), findsOneWidget);

      await tester.tap(find.text('Yangilash'));
      expect(actionCalled, isTrue);
    });

    testWidgets('LoadingIndicator va ErrorView to\'g\'ri render bo\'ladi', (tester) async {
      var retried = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          Column(
            children: [
              const LoadingIndicator(message: 'Kuting...'),
              ErrorView(
                message: 'Xatolik yuz berdi',
                onRetry: () => retried = true,
              ),
            ],
          ),
        ),
      );

      expect(find.text('Kuting...'), findsOneWidget);
      expect(find.text('Xatolik yuz berdi'), findsOneWidget);
      expect(find.text('Qayta urinish'), findsOneWidget);

      await tester.tap(find.text('Qayta urinish'));
      expect(retried, isTrue);
    });
  });
}
