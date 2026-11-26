# Hafta 2 hisoboti

## Qilingan ishlar
- **23.11** `flutter_secure_storage` paketini qo'shdim va tokenlarni faqat xavfsiz xotirada saqlovchi `TokenStorage` interfeysi hamda `SecureTokenStorage` sinfini yaratdim.
- **23.11** `AuthInterceptor` ni xotiradagi oddiy o'zgaruvchi o'rniga `TokenStorage` dan asinxron token olib `Authorization: Bearer <token>` qo'shadigan qilib o'zgartirdim.
- **23.11** `MockAuthRepositoryImpl` va `AuthRepositoryImpl` da login muvaffaqiyatli bo'lganda tokenlarni saqlash va logout qilinganda tozalash logikasini qo'shdim.
- **23.11** `LoggingInterceptor` da `Authorization` headeri `Bearer ***` ko'rinishida, parol va maxfiy ma'lumotlar esa `***MASKED***` qilib chiqarilishini tasdiqladim va moslashtirdim.
- **23.11** `main.dart` da `SecureTokenStorage` instansiyasini yaratib, repozitoriy va interceptorga bog'ladim.
- **23.11** `FakeTokenStorage` yaratib, tokenlarni saqlash, o'qish, tozalash, interceptor orqali headerga biriktirish va repozitoriy integratsiyasi bo'yicha 5 ta unit test yozdim.
- **23.11** `.gitignore` fayliga maxfiy kalitlar va sertifikatlar (`*.key`, `*.keystore`, `*.jks`, `*.p12`, `*.pfx`, `secrets.json`) kengaytmalarini qo'shdim.
- **25.11** Email va parol uchun regex asosidagi `Validators` yordamchi sinfini yaratdim, `LoginScreen` ga bog'lab, yuklanish holatida tugmani bloklashni joriy qildim.
- **25.11** `AuthBloc` dagi holat o'tishlarini (`initial`, `loading`, `authenticated`, `failure`) yaxshiladim, `clearError` parametri orqali xatoliklarni tozalash imkoniyatini qo'shdim.
- **25.11** Validatsiya uchun 6 ta unit test, `AuthBloc` login holatlari va `LoginScreen` vidjeti uchun testlar yozdim.
- **25.11** `LogoutRequestedEvent` orqali tizimdan chiqish, `TokenStorage.clear()` bilan tokenlarni to'liq tozalash va login ekraniga qaytishni ta'minladim.
- **25.11** `SplashScreen` ochilganda `TokenStorage` dagi token asosida sessiyani tiklash va to'g'ridan-to'g'ri Home ekraniga o'tish logikasini yaratdim.
- **25.11** `AuthInterceptor` ga 401 xatosi kelganda refresh token orqali yangilash yoki avtomatik tizimdan chiqarish (`onUnauthorized`) logikasini qo'shdim.
- **25.11** Logout, sessiyani tiklash va 401 interceptor holatlari uchun unit va bloc testlar yozdim.
- **26.11** Parolni tiklash uchun `ForgotPasswordBloc`, `AuthRepository` metodlari (`sendResetCode`, `verifyCode`, `resetPassword`) va mock realizatsiya yaratdim (tasdiqlash kodi: "123456").
- **26.11** Uch bosqichli parol tiklash ekranlarini (`ForgotPasswordScreen`, `VerifyCodeScreen`, `ResetPasswordScreen`) yaratib, Login ekraniga "Parolni unutdim?" havolasini va login'siz ochiladigan marshrutlarni qo'shdim.
- **26.11** Parolni tiklash BLoC va yangi validatsiyalar (`validateResetCode`, `validateConfirmPassword`) uchun unit va bloc testlar yozdim.
- **26.11** Feature-first Clean Architecture bo'yicha `features/profile` (domain, data, presentation) modulini yaratdim: `UserProfile`, `ProfileRepository`, `MockProfileRemoteDataSourceImpl` va `ProfileBloc`.
- **26.11** `ProfileScreen` (ism, email, bosh harfli avatar va tahrirlash rejimi) yaratdim, `/profile` marshruti va Home ekranidan profilga o'tish tugmasini qo'shdim.
- **26.11** `ProfileBloc` uchun 3 ta bloc test va `ProfileScreen` uchun widget test yozdim.

## Muammolar
- `MockAuthRepositoryImpl` konstruktorida `_tokenStorage` xususiy maydoniga parametr biriktirilganda linter `prefer_initializing_formals` ogohlantirishini ko'rsatdi.
- `LoginScreen` widget testida `mockAuthRepository.login(...)` chaqiruviga javob mock qilinmagani sababli test `AuthStatus.failure` holatiga tushib qoldi.
- `DioClient` faylida `VoidCallback` ishlatilganda `package:flutter/foundation.dart` import qilinmagani uchun `undefined_class` xatosi chiqdi.
- Unit testda `ErrorInterceptorHandler` mock qilinganda `super.next(err)` chaqirilishi tufayli uncompleted Completer sababli istisno yuz berdi.
- `ProfileScreen` widget testida `pumpAndSettle()` va oddiy `pump()` chaqirilganda `ProfileBloc` asinxron yuklanishi tugamay qolib, foydalanuvchi nomi ekranda ko'rinmadi.

## Yechim
- Konstruktorni `this.tokenStorage` shakliga keltirib, maydonni to'g'ridan-to'g'ri boshlang'ichlash orqali ogohlantirishni bartaraf etdim.
- Widget testida `when(() => mockAuthRepository.login(...)).thenAnswer(...)` bilan kutilgan foydalanuvchi ma'lumotlarini qaytardim.
- `DioClient` fayliga `import 'package:flutter/foundation.dart';` qo'shib xatolikni tuzatdim.
- Mock handler ichida `super.next(err)` ni olib tashlab, faqat chaqiruv bayrog'ini belgilaydigan qildim.
- Widget testida `tester.runAsync(() => Future<void>.delayed(Duration.zero))` va `await tester.pump()` ishlatib, asinxron event natijasi UI ga yetib kelishini ta'minladim.
