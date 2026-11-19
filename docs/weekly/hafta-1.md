# Hafta 1 Hisoboti

## Qilingan ishlar
- **2026-11-19**: `flutter create . --project-name startup_app` buyrug'i yordamida loyiha yaratildi, masofaviy Git repozitoriyasi (`https://github.com/Sh0hrux/Project.git`) ulandi va birinchi commit `origin/main` ga push qilindi.
- **2026-11-19**: Feature-first Clean Architecture papkalar tuzilmasi shakllantirildi: `lib/core/{theme,router,network,error,widgets}` va `lib/features/auth/{data,domain,presentation}` bo'sh papkalari uchun `.gitkeep` yaratildi, `lib/app.dart` minimal dasturiy kodi yozildi, `main.dart` `App` widgetini ishga tushiradigan qilib sozlandi hamda `flutter analyze` va testlar muvaffaqiyatli tekshirildi.

## Muammolar
- `flutter create` buyrug'i papka nomisiz kiritilganda yordam (help) matnini chiqarib, loyihani yaratmadi.
- Loyiha papkasi nomi `projectFT` bo'lgani sababli, katta harflar mavjudligi tufayli Dart paket nomi sifatida qabul qilinmadi.

## Yechim
- `flutter create . --project-name startup_app` buyrug'i orqali joriy papkada `startup_app` paket nomi bilan Flutter loyihasi muvaffaqiyatli ishga tushirildi.

## Keyingi hafta rejasi
- Feature-first Clean Architecture tuzilmasini shakllantirish (core va features/auth).
- State management va routing sozlamalarini integratsiya qilish.
- Umumiy UI komponentlar, mavzu (theme), API client va error handling tizimini o'rnatish.
