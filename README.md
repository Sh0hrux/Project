# startup_app

Startup loyiha uchun Flutter ilovasi: Feature-first Clean Architecture, BLoC state management, GoRouter deklarativ marshrutlash, Material 3 dizayn tizimi, Dio asosidagi API mijoz va xavfsiz sessiya boshqaruvi.

## Asosiy funksiyalar

- **Xavfsiz token saqlash:** `flutter_secure_storage` (`TokenStorage`) orqali access va refresh tokenlarni shifrlangan holda saqlash.
- **Autentifikatsiya (Login & Logout):** Email va parol validatsiyasi, yuklanish holatlari, `Failure` orqali xatolarni ko'rsatish, logout va splash'da sessiyani tiklash.
- **401 avtomatik boshqaruv:** `AuthInterceptor` orqali 401 xatosida refresh token bilan yangilashga urinish yoki avtomatik logout.
- **Parolni tiklash:** Uch bosqichli oqim (email kiritish, tasdiqlash kodi, yangi parol o'rnatish).
- **Foydalanuvchi profili:** Profil ma'lumotlarini ko'rish va tahrirlash (ismni yangilash).
- **Tashkilot tanlash:** Ko'p tashkilotli muhit uchun tashkilotni tanlash, `SharedPreferences` da saqlash va barcha API so'rovlarga `X-Organization-Id` headerini qo'shish.
- **Xavfsizlik:** Loglarda token va parollarni maskalash (`LoggingInterceptor` va BLoC event `toString`), barcha parol maydonlarida `obscureText`.

## Hisobotlar

- [Hafta 1 hisoboti](docs/weekly/hafta-1.md)
- [Hafta 2 hisoboti](docs/weekly/hafta-2.md)

## Loyiha tuzilmasi

```
lib/
├── app.dart                   # Bosh ilova vidjeti (Mavzu, Router, Global Providerlar)
├── main.dart                  # Kirish nuqtasi (DI va BLoC providerlar)
├── core/
│   ├── bloc/                  # AppBlocObserver
│   ├── error/                 # Failure, Exception, ErrorHandler va Result
│   ├── network/               # DioClient, ApiEndpoints, AuthInterceptor, TokenRefresher, LoggingInterceptor
│   ├── router/                # AppRoutes, AppRouter (redirect & refreshListenable), NotFoundScreen
│   ├── storage/               # TokenStorage (secure) va OrganizationStorage (prefs)
│   ├── theme/                 # AppColors, AppTheme, AppSpacing, AppRadius, AppTypography, ThemeCubit
│   ├── utils/                 # Validators
│   └── widgets/               # Umumiy UI vidjetlar (AppButton, AppTextField, LoadingOverlay, EmptyView, ErrorView)
└── features/
    ├── auth/                  # Autentifikatsiya va parolni tiklash moduli
    │   ├── data/              # Modellar, data sourcelar va repozitoriylar (Mock & Impl)
    │   ├── domain/            # UserEntity va AuthRepository
    │   └── presentation/      # AuthBloc, ForgotPasswordBloc, Splash/Login/Home/Forgot ekranlar
    ├── organization/          # Tashkilot tanlash moduli
    │   ├── data/              # OrganizationModel, MockOrganizationRemoteDataSource, Repo
    │   ├── domain/            # Organization entity va OrganizationRepository
    │   └── presentation/      # OrganizationBloc va OrganizationSelectScreen
    └── profile/               # Foydalanuvchi profili moduli
        ├── data/              # UserProfileModel, MockProfileRemoteDataSource, Repo
        ├── domain/            # UserProfile entity va ProfileRepository
        └── presentation/      # ProfileBloc va ProfileScreen
```

## Ishga tushirish

1. Bog'liqliklarni o'rnatish:
   ```bash
   flutter pub get
   ```

2. Tahlil va testlarni yurgizish:
   ```bash
   flutter analyze
   flutter test
   ```

3. Ilovani ishga tushirish:
   ```bash
   flutter run
   ```

## `USE_MOCK` bayrog'i

Ilova `main.dart` ichidagi `const bool useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);` bayrog'i orqali ikki rejimda ishlaydi:

- **Mock rejim (`USE_MOCK=true`, standart holat):** Backend talab qilmasdan `MockAuthRepositoryImpl`, `MockProfileRemoteDataSourceImpl` va `MockOrganizationRemoteDataSourceImpl` bilan ishlaydi.
  ```bash
  flutter run --dart-define=USE_MOCK=true
  ```
- **API rejim (`USE_MOCK=false`):** `DioClient`, `AuthInterceptor`, `DioTokenRefresher` hamda haqiqiy remote data source'lar orqali server bilan ishlaydi (`401` da token yangilanmasa avtomatik logout qilinadi).
  ```bash
  flutter run --dart-define=USE_MOCK=false
  ```

## Haqiqiy API bilan ishlatish

Backend serverga ulanish uchun `USE_MOCK=false` va `API_BASE_URL` bayroqlarini bering:

```bash
flutter run --dart-define=USE_MOCK=false --dart-define=API_BASE_URL=https://api.example.com/v1
```

Kutiladigan API endpointlar (`ApiEndpoints`):

| Funksiya | Metod | Endpoint yo'li | Izoh |
| --- | --- | --- | --- |
| Tizimga kirish | `POST` | `/auth/login` | `email`, `password` |
| Ro'yxatdan o'tish | `POST` | `/auth/register` | Ro'yxatdan o'tish |
| Token yangilash | `POST` | `/auth/refresh` | `refresh_token` |
| Tizimdan chiqish | `POST` | `/auth/logout` | Sessiyani yopish |
| Parol tiklash kodi | `POST` | `/auth/forgot-password` | `email` |
| Kodni tasdiqlash | `POST` | `/auth/verify-code` | `email`, `code` |
| Yangi parol o'rnatish | `POST` | `/auth/reset-password` | `email`, `code`, `new_password` |
| Profilni olish / yangilash | `GET` / `PUT` | `/auth/profile` | `Authorization`, `X-Organization-Id` |
| Tashkilotlar ro'yxati | `GET` | `/organizations` | `Authorization`, `X-Organization-Id` |
