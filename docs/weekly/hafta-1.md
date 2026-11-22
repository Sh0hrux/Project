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
- **19.11** BLoC holat o'zgarishlarini kuzatish uchun `AppBlocObserver` yaratdim, `main.dart` da `AuthBloc` ni `BlocProvider` orqali ta'minladim va `AuthBloc` uchun unit testlar yozdim.
- **19.11** GoRouter uchun `AppRoutes` konstantalarini, autentifikatsiya holatiga asoslangan `redirect` logikasini, `refreshListenable` orqali BLoC oqimini kuzatishni hamda 404 xatosi uchun `NotFoundScreen` ni yaratdim va widget testlar bilan tekshirdim.
- **19.11** Umumiy UI komponentlarini kengaytirdim: `AppButton` variantlarini (primary, outlined, text), `AppTextField` uchun `errorText` va qo'shimcha ikonkalar, `LoadingOverlay` va `EmptyView` vidjetlarini yaratdim hamda ularga widget testlar yozdim.
- **19.11** Dizayn tizimi va mavzuni boshqarishni joriy qildim: `AppSpacing`, `AppRadius`, `AppTypography` konstantalarini yaratdim, `ThemeCubit` orqali yorug'/qorong'i mavzuni almashtirishni ulab, Home ekraniga mavzu tugmasini joylashtirdim va `ThemeCubit` uchun testlar yozdim.
- **22.11** API so'rovlariga token qo'shuvchi `AuthInterceptor` va loglarda maxfiy ma'lumotlarni maskalovchi `LoggingInterceptor` yaratdim.
- **22.11** Dio xatolarini `Failure` ga aylantiruvchi markaziy `ErrorHandler` hamda tashqi kutubxonalarsiz ishlovchi `Result` (`Success`/`Error`) sinfini yozdim va unit testlar bilan tekshirdim.
- **22.11** Tarmoqsiz sinash uchun `MockAuthRepositoryImpl` yaratdim (oddiy login bilan kiradi, xato emailda server xatosi beradi) va Login ekranida xatolikni `ErrorView` da ko'rsatishni ulab, BLoC testlarini yozdim.

## Muammolar
- `flutter create` ni papka nomisiz yozganim uchun u loyiha yaratmadi, faqat yordam matnini chiqardi.
- Papka nomi `projectFT` edi, katta harflar bo'lgani uchun Dart uni paket nomi sifatida qabul qilmadi.
- Testda `App` ni sinaganimda `SplashScreen` tarmoqqa so'rov yuborib, Dio taymeri ochiq qolib ketdi va `!timersPending` xatosi chiqdi.
- Linter `prefer_initializing_formals` bo'yicha konstruktorlarda ogohlantirish berdi.
- Unit testda `mocktail` import qilinganda linter `depend_on_referenced_packages` xatosini ko'rsatdi.
- Mavjud bo'lmagan sahifaga kirilganda `redirect` funksiyasi dastlabki holatda har doim `/splash` ga yo'naltirgani sababli 404 ekrani ko'rinmay qoldi.
- `LoadingOverlay` widget testida Stack ichidagi kichik child sababli `LoadingIndicator` sig'may `RenderFlex overflow` xatosi yuz berdi.
- `MockAuthRepositoryImpl` ichida `Future.delayed` ishlatilganida `blocTest` da asinxron vaqt o'tishi sababli kutilgan holat testga yetib bormay qoldi.
- `AuthInterceptor` da xususiy maydonni boshlang'ichlashda linter `prefer_initializing_formals` qoidasiga ko'ra xatolik berdi.

## Yechim
- `flutter create . --project-name startup_app` buyrug'i bilan paket nomini o'zim berdim.
- `App` ga `authRepository` ni tashqaridan berish imkonini qo'shdim, testda soxta `FakeAuthRepository` ishlatdim va `pumpAndSettle()` bilan kutdim.
- Konstruktorlarni `this.maydon` shaklida yozib, ogohlantirishlarni tuzatdim.
- `mocktail` kutubxonasini `pubspec.yaml` ning `dev_dependencies` bo'limiga qo'shib muammoni hal qildim.
- `redirect` funksiyasining boshiga `state.error != null` bo'lganda `null` qaytarish shartini qo'shdim, natijada xatolik bo'lganda router to'g'ri `NotFoundScreen` ga yo'naltirildi.
- `LoadingOverlay` ichidagi indikatorni `SingleChildScrollView` bilan o'radim va testda qat'iy o'lchamli `SizedBox` bilan ta'minladim.
- `MockAuthRepositoryImpl` dan `Future.delayed` ni olib tashlab, natijalarni to'g'ridan-to'g'ri sinxron qaytaradigan qildim va har bir `blocTest` da yangi `AuthBloc` obyektini ishlatdim.
- Konstruktorda `this.token` shaklini qo'llab linter ogohlantirishini bartaraf etdim.
