# Hafta 1 hisoboti

## Qilingan ishlar
- **18.11** Flutter loyihani `startup_app` nomi bilan yaratdim, GitHub repository'ga ulab, birinchi commitni push qildim.
- **18.11** Feature-first Clean Architecture bo'yicha papkalarni tayyorladim: `core` ichida theme, router, network, error, widgets, `features/auth` ichida data, domain, presentation.
- **18.11** Kerakli paketlarni qo'shdim: `flutter_bloc`, `equatable`, `go_router`, `dio`.
- **18.11** Xatolarni boshqarish qismini yozdim: `Failure` va `Exception` sinflari (server, tarmoq, kesh xatolari).
- **18.11** Material 3 asosida theme yaratdim: `AppColors`, `AppTheme`, yorug' va qorong'i rejim, tugma va input stillari.
- **18.11** Umumiy vidjetlar yozdim: `AppButton`, `AppTextField`, `LoadingIndicator`, `ErrorView`.
- **18.11** Dio asosida API client yaratdim: `ApiEndpoints`, `DioClient`, interceptorlar va xatolarni ushlash.
- **18.11** Auth feature uchun `AuthBloc`, `AppRouter` (Splash, Login, Home ekranlari) va data/domain qatlamlarini (entity, model, data source, repository) yozib, `App` ga ulab chiqdim.
- **18.11** README'ga loyiha tuzilmasi va ishga tushirish yo'riqnomasini qo'shdim, `flutter analyze` va `flutter test` ni tekshirdim.

## Muammolar
- `flutter create` ni papka nomisiz yozganim uchun u loyiha yaratmadi, faqat yordam matnini chiqardi.
- Papka nomi `projectFT` edi, katta harflar bo'lgani uchun Dart uni paket nomi sifatida qabul qilmadi.
- Testda `App` ni sinaganimda `SplashScreen` tarmoqqa so'rov yuborib, Dio taymeri ochiq qolib ketdi va `!timersPending` xatosi chiqdi.
- Linter `prefer_initializing_formals` bo'yicha konstruktorlarda ogohlantirish berdi.

## Yechim
- `flutter create . --project-name startup_app` buyrug'i bilan paket nomini o'zim berdim.
- `App` ga `authRepository` ni tashqaridan berish imkonini qo'shdim, testda soxta `FakeAuthRepository` ishlatdim va `pumpAndSettle()` bilan kutdim.
- Konstruktorlarni `this.maydon` shaklida yozib, ogohlantirishlarni tuzatdim.

## Keyingi hafta rejasi
- Yangi funksiyalar (foydalanuvchi profili, sozlamalar va h.k.) uchun yangi modullar ochish.
- Tokenlarni xavfsiz saqlash (secure storage) tizimini ulash.
- Qo'shimcha testlar yozib borish.
