# Hafta 1 Hisoboti

## Qilingan ishlar
- **2026-11-19**: `flutter create . --project-name startup_app` buyrug'i yordamida loyiha yaratildi, masofaviy Git repozitoriyasi (`https://github.com/Sh0hrux/Project.git`) ulandi va birinchi commit `origin/main` ga push qilindi.
- **2026-11-19**: Feature-first Clean Architecture papkalar tuzilmasi shakllantirildi: `lib/core/{theme,router,network,error,widgets}` va `lib/features/auth/{data,domain,presentation}` bo'sh papkalari uchun `.gitkeep` yaratildi, `lib/app.dart` minimal dasturiy kodi yozildi, `main.dart` `App` widgetini ishga tushiradigan qilib sozlandi hamda `flutter analyze` va testlar muvaffaqiyatli tekshirildi.
- **2026-11-19**: Loyihaning holat boshqaruvi, marshrutlash va tarmoq so'rovlari uchun kerakli paketlar (`flutter_bloc`, `equatable`, `go_router`, `dio`) o'rnatildi.
- **2026-11-19**: Xatoliklarni boshqarish (`core/error`) moduli yaratildi: `Failure` sinflari (`ServerFailure`, `NetworkFailure`, `CacheFailure` va boshqalar) hamda mos `Exception` sinflari ishlab chiqildi.
- **2026-11-19**: Mavzu tizimi (`core/theme`) ishlab chiqildi: Material 3 ga mos `AppColors` ranglar palitrasi va `AppTheme` (yorug' va qorong'i rejimlar, button va input stillari) yaratilib, `App` ga ulandi.
- **2026-11-19**: Umumiy UI komponentlari (`core/widgets`) ishlab chiqildi: `AppButton` (yuklanish holatli tugma), `AppTextField` (parol ko'rinuvchanligi va validatsiyali maydon), `LoadingIndicator` hamda xatoliklarni qayta urinish bilan ko'rsatuvchi `ErrorView`.

## Muammolar
- `flutter create` buyrug'i papka nomisiz kiritilganda yordam (help) matnini chiqarib, loyihani yaratmadi.
- Loyiha papkasi nomi `projectFT` bo'lgani sababli, katta harflar mavjudligi tufayli Dart paket nomi sifatida qabul qilinmadi.

## Yechim
- `flutter create . --project-name startup_app` buyrug'i orqali joriy papkada `startup_app` paket nomi bilan Flutter loyihasi muvaffaqiyatli ishga tushirildi.

## Keyingi hafta rejasi
- Feature-first Clean Architecture tuzilmasini shakllantirish (core va features/auth).
- State management va routing sozlamalarini integratsiya qilish.
- Umumiy UI komponentlar, mavzu (theme), API client va error handling tizimini o'rnatish.
