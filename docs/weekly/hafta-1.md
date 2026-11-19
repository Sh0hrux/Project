# Hafta 1 Hisoboti

## Qilingan ishlar
- **2026-11-19**: `flutter create . --project-name startup_app` buyrug'i yordamida loyiha yaratildi, masofaviy Git repozitoriyasi (`https://github.com/Sh0hrux/Project.git`) ulandi va birinchi commit `origin/main` ga push qilindi.
- **2026-11-19**: Feature-first Clean Architecture papkalar tuzilmasi shakllantirildi: `lib/core/{theme,router,network,error,widgets}` va `lib/features/auth/{data,domain,presentation}` bo'sh papkalari uchun `.gitkeep` yaratildi, `lib/app.dart` minimal dasturiy kodi yozildi, `main.dart` `App` widgetini ishga tushiradigan qilib sozlandi hamda `flutter analyze` va testlar muvaffaqiyatli tekshirildi.
- **2026-11-19**: Loyihaning holat boshqaruvi, marshrutlash va tarmoq so'rovlari uchun kerakli paketlar (`flutter_bloc`, `equatable`, `go_router`, `dio`) o'rnatildi.
- **2026-11-19**: Xatoliklarni boshqarish (`core/error`) moduli yaratildi: `Failure` sinflari (`ServerFailure`, `NetworkFailure`, `CacheFailure` va boshqalar) hamda mos `Exception` sinflari ishlab chiqildi.
- **2026-11-19**: Mavzu tizimi (`core/theme`) ishlab chiqildi: Material 3 ga mos `AppColors` ranglar palitrasi va `AppTheme` (yorug' va qorong'i rejimlar, button va input stillari) yaratilib, `App` ga ulandi.
- **2026-11-19**: Umumiy UI komponentlari (`core/widgets`) ishlab chiqildi: `AppButton` (yuklanish holatli tugma), `AppTextField` (parol ko'rinuvchanligi va validatsiyali maydon), `LoadingIndicator` hamda xatoliklarni qayta urinish bilan ko'rsatuvchi `ErrorView`.
- **2026-11-19**: Tarmoq va API mijozi qatlami (`core/network`) ishlab chiqildi: `ApiEndpoints` (manzillar va timeoutlar) hamda Dio asosidagi `DioClient` (so'rovlarni boshqarish, interceptorlar va xatolarni ushlab moslash) tizimi joriy etildi.
- **2026-11-19**: BLoC holat boshqaruvi (`AuthBloc`), `GoRouter` deklarativ marshrutlash (`AppRouter`, `SplashScreen`, `LoginScreen`, `HomeScreen`) hamda `features/auth` Clean Architecture qatlamlari (Entity, Model, RemoteDataSource, Repository) ishlab chiqilib, `App` ga to'liq ulandi.

## Muammolar
- `flutter create` buyrug'i papka nomisiz kiritilganda yordam (help) matnini chiqarib, loyihani yaratmadi.
- Loyiha papkasi nomi `projectFT` bo'lgani sababli, katta harflar mavjudligi tufayli Dart paket nomi sifatida qabul qilinmadi.
- `test/widget_test.dart` da `App` vidjetini sinash paytida `SplashScreen` foni orqali yuborilgan tarmoq so'rovi sababli asinxron Dio taymeri ochiq qolib, `!timersPending` assertion xatoligi yuz berdi.
- `prefer_initializing_formals` linter qoidasi bo'yicha konstruktor parametrlarida ogohlantirishlar paydo bo'ldi.

## Yechim
- `flutter create . --project-name startup_app` buyrug'i orqali joriy papkada `startup_app` paket nomi bilan Flutter loyihasi muvaffaqiyatli ishga tushirildi.
- `App` vidjetiga tashqaridan `authRepository` uzatish imkoniyati qo'shildi (Dependency Injection) va testda `FakeAuthRepository` berilib, `pumpAndSettle()` orqali asinxron jarayonlar xavfsiz yakunlanishi ta'minlandi.
- Konstruktorlarda parametrlarni to'g'ridan-to'g'ri `this.maydon` shaklida e'lon qilib, linter qoidalariga to'liq moslashtirildi.

## Keyingi hafta rejasi
- Yangi biznes funksiyalar (features) uchun Clean Architecture modullarini kengaytirish.
- Mahalliy xotira (local storage / flutter_secure_storage) orqali avtorizatsiya tokenlarini saqlash mexanizmini qo'shish.
- Foydalanuvchi profili va boshqa asosiy ekranlarni to'liq integratsiya qilish.
- Unit va integratsion testlar qamrovini oshirish.
