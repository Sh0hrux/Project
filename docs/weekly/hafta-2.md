# Hafta 2 hisoboti

## Qilingan ishlar
- **23.11** `flutter_secure_storage` paketini qo'shdim va tokenlarni faqat xavfsiz xotirada saqlovchi `TokenStorage` interfeysi hamda `SecureTokenStorage` sinfini yaratdim.
- **23.11** `AuthInterceptor` ni xotiradagi oddiy o'zgaruvchi o'rniga `TokenStorage` dan asinxron token olib `Authorization: Bearer <token>` qo'shadigan qilib o'zgartirdim.
- **23.11** `MockAuthRepositoryImpl` va `AuthRepositoryImpl` da login muvaffaqiyatli bo'lganda tokenlarni saqlash va logout qilinganda tozalash logikasini qo'shdim.
- **23.11** `LoggingInterceptor` da `Authorization` headeri `Bearer ***` ko'rinishida, parol va maxfiy ma'lumotlar esa `***MASKED***` qilib chiqarilishini tasdiqladim va moslashtirdim.
- **23.11** `main.dart` da `SecureTokenStorage` instansiyasini yaratib, repozitoriy va interceptorga bog'ladim.
- **23.11** `FakeTokenStorage` yaratib, tokenlarni saqlash, o'qish, tozalash, interceptor orqali headerga biriktirish va repozitoriy integratsiyasi bo'yicha 5 ta unit test yozdim.
- **23.11** `.gitignore` fayliga maxfiy kalitlar va sertifikatlar (`*.key`, `*.keystore`, `*.jks`, `*.p12`, `*.pfx`, `secrets.json`) kengaytmalarini qo'shdim.
- **23.11** Email va parol uchun regex asosidagi `Validators` yordamchi sinfini yaratdim, `LoginScreen` ga bog'lab, yuklanish holatida tugmani bloklashni joriy qildim.
- **23.11** `AuthBloc` dagi holat o'tishlarini (`initial`, `loading`, `authenticated`, `failure`) yaxshiladim, `clearError` parametri orqali xatoliklarni tozalash imkoniyatini qo'shdim.
- **23.11** Validatsiya uchun 6 ta unit test, `AuthBloc` login holatlari va `LoginScreen` vidjeti uchun testlar yozdim.
- **23.11** `LogoutRequestedEvent` orqali tizimdan chiqish, `TokenStorage.clear()` bilan tokenlarni to'liq tozalash va login ekraniga qaytishni ta'minladim.
- **23.11** `SplashScreen` ochilganda `TokenStorage` dagi token asosida sessiyani tiklash va to'g'ridan-to'g'ri Home ekraniga o'tish logikasini yaratdim.
- **23.11** `AuthInterceptor` ga 401 xatosi kelganda refresh token orqali yangilash yoki avtomatik tizimdan chiqarish (`onUnauthorized`) logikasini qo'shdim.
- **23.11** Logout, sessiyani tiklash va 401 interceptor holatlari uchun unit va bloc testlar yozdim.
- **25.11** Parolni tiklash uchun `ForgotPasswordBloc`, `AuthRepository` metodlari (`sendResetCode`, `verifyCode`, `resetPassword`) va mock realizatsiya yaratdim (tasdiqlash kodi: "123456").
- **25.11** Uch bosqichli parol tiklash ekranlarini (`ForgotPasswordScreen`, `VerifyCodeScreen`, `ResetPasswordScreen`) yaratib, Login ekraniga "Parolni unutdim?" havolasini va login'siz ochiladigan marshrutlarni qo'shdim.
- **25.11** Parolni tiklash BLoC va yangi validatsiyalar (`validateResetCode`, `validateConfirmPassword`) uchun unit va bloc testlar yozdim.
- **25.11** Feature-first Clean Architecture bo'yicha `features/profile` (domain, data, presentation) modulini yaratdim: `UserProfile`, `ProfileRepository`, `MockProfileRemoteDataSourceImpl` va `ProfileBloc`.
- **25.11** `ProfileScreen` (ism, email, bosh harfli avatar va tahrirlash rejimi) yaratdim, `/profile` marshruti va Home ekranidan profilga o'tish tugmasini qo'shdim.
- **25.11** `ProfileBloc` uchun 3 ta bloc test va `ProfileScreen` uchun widget test yozdim.
- **26.11** Feature-first Clean Architecture bo'yicha `features/organization` modulini yaratdim (`Organization`, `OrganizationRepository`, `MockOrganizationRemoteDataSourceImpl`, `OrganizationBloc`, `OrganizationSelectScreen`).
- **26.11** Tanlangan tashkilot ID sini `SharedPreferencesOrganizationStorage` da saqlashni, `AppRouter` da login'dan keyin tashkilot tanlash sahifasiga yo'naltirishni va `HomeScreen` da tashkilot nomini ko'rsatib almashtirish tugmasini qo'shdim.
- **26.11** `AuthInterceptor` ga barcha so'rovlarga `X-Organization-Id` headerini qo'shishni hamda logout'da tanlangan tashkilotni tozalashni uladim; `OrganizationBloc` va interceptor uchun testlar yozdim.
- **26.11** Loyihada xavfsizlik auditini o'tkazdim: `LoginRequestedEvent` va `ResetPasswordSubmittedEvent` eventlarining `toString()` metodida parol maskalanishini qo'shdim, `README.md` ni yangiladim.
- **26.11** `main.dart` ga `USE_MOCK` bayrog'ini qo'shdim (`useMock == false` holatda `DioClient`, `AuthRepositoryImpl`, haqiqiy `ProfileRemoteDataSourceImpl` va `OrganizationRemoteDataSourceImpl` ulanadi, `onUnauthorized` esa `LogoutRequestedEvent` yuboradi).
- **26.11** `ApiEndpoints` ga `/organizations` endpointini, `DioClient` ga `put` metodini qo'shdim hamda `DioClient` so'rovlarida `Authorization` va `X-Organization-Id` headerlari yuborilishini tekshiruvchi test yozdim.
- **26.11** `AuthInterceptor` dan soxta `mockRefreshAccessToken` metodini olib tashlab, `TokenRefresher` interfeysi va interceptorsiz `Dio` bilan ishlovchi `DioTokenRefresher` (testlar uchun `MockTokenRefresher`) yaratdim.
- **26.11** `AuthInterceptor` ga parallel 401 so'rovlar uchun `Completer` lock, `extra['retried']` himoyasi, asl `Dio` orqali qayta urinish va muvaffaqiyatsiz refresh'da sessiyani tozalashni qo'shdim hamda 3 ta yangi test yozdim.
- **26.11** `flutter_secure_storage` (11.2.0) Android `minSdk` talabini tekshirdim (`README.md` da 23, `android/build.gradle` da 24); `flutter.minSdkVersion` allaqachon 24 bo'lgani uchun `build.gradle.kts` ni o'zgartirmadim.
- **26.11** `android/settings.gradle.kts` da Android Gradle Plugin versiyasini `9.1.0` dan `9.1.1` ga ko'tardim va bayroqsiz `flutter build apk --debug` ni muvaffaqiyatli o'tkazdim.
- **26.11** `ApiEndpoints.baseUrl` ni `String.fromEnvironment('API_BASE_URL', defaultValue: ...)` orqali olinadigan qildim, `forgotPassword`, `verifyCode`, `resetPassword` endpointlari va `AuthRemoteDataSourceImpl` metodlarini qo'shdim.
- **26.11** `ErrorHandler.handleException` da `UnauthorizedException`, `NetworkException`, `ServerException` va `CacheException` turlarini mos `Failure` ga aylantirishni qo'shib, `AuthRepositoryImpl`, `ProfileRepositoryImpl` va `OrganizationRepositoryImpl` ga uladim.
- **26.11** `dio_client_test.dart` da login, profil, tashkilotlar ro'yxati va Dio xatolarining (`timeout`, `401`, `5xx`) `Failure` ga aylanishi uchun 4 ta yangi integratsion test yozdim hamda `README.md` ga haqiqiy API va endpointlar jadvalini qo'shdim.
- **26.11** `AndroidManifest.xml` ga `android:allowBackup="false"`, `.gitignore` ga `key.properties` va `google-services.json` qoidalarini qo'shdim hamda kod va git tarixida maxfiy ma'lumot yo'qligini tekshirdim.

## Muammolar
- `MockAuthRepositoryImpl` konstruktorida `_tokenStorage` xususiy maydoniga parametr biriktirilganda linter `prefer_initializing_formals` ogohlantirishini ko'rsatdi.
- `LoginScreen` widget testida `mockAuthRepository.login(...)` chaqiruviga javob mock qilinmagani sababli test `AuthStatus.failure` holatiga tushib qoldi.
- `DioClient` faylida `VoidCallback` ishlatilganda `package:flutter/foundation.dart` import qilinmagani uchun `undefined_class` xatosi chiqdi.
- Unit testda `ErrorInterceptorHandler` mock qilinganda `super.next(err)` chaqirilishi tufayli uncompleted Completer sababli istisno yuz berdi.
- `ProfileScreen` widget testida `pumpAndSettle()` va oddiy `pump()` chaqirilganda `ProfileBloc` asinxron yuklanishi tugamay qolib, foydalanuvchi nomi ekranda ko'rinmadi.
- `OrganizationBloc` testida `const SelectOrganizationEvent(organization: orgs[0])` yozilganda `const_with_non_constant_argument` kompilyatsiya xatosi yuz berdi.
- `dio_client_test.dart` dagi fake storage sinflarida linter `prefer_initializing_formals` ogohlantirishini berdi.
- AGP 9.1.0 Flutter talab qilgan 9.1.1 dan past bo'lgani uchun `flutter build apk --debug` to'xtadi.

## Yechim
- Konstruktorni `this.tokenStorage` shakliga keltirib, maydonni to'g'ridan-to'g'ri boshlang'ichlash orqali ogohlantirishni bartaraf etdim.
- Widget testida `when(() => mockAuthRepository.login(...)).thenAnswer(...)` bilan kutilgan foydalanuvchi ma'lumotlarini qaytardim.
- `DioClient` fayliga `import 'package:flutter/foundation.dart';` qo'shib xatolikni tuzatdim.
- Mock handler ichida `super.next(err)` ni olib tashlab, faqat chaqiruv bayrog'ini belgilaydigan qildim.
- Widget testida `tester.runAsync(() => Future<void>.delayed(Duration.zero))` va `await tester.pump()` ishlatib, asinxron event natijasi UI ga yetib kelishini ta'minladim.
- Testda `const` kalit so'zini olib tashlab, `SelectOrganizationEvent(organization: orgs[0])` shaklida to'g'riladim.
- Fake sinf maydonlarini `this.accessToken`, `this.refreshToken` va `this.orgId` ko'rinishida to'g'ridan-to'g'ri boshlang'ichladim.
- Avval `--android-skip-build-dependency-validation` bayrog'i bilan vaqtincha aylanib o'tdim, keyin `android/settings.gradle.kts` da AGP ni `9.1.1` ga ko'tarib, bayroqsiz `flutter build apk --debug` o'tishini tasdiqladim.
