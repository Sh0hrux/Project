# startup_app

Startup loyiha uchun Flutter skeleton: Feature-first Clean Architecture, BLoC state management, GoRouter deklarativ marshrutlash, Material 3 mavzusi, Dio asosidagi API mijoz va markazlashtirilgan error handling tizimi.

## Hisobotlar

- [Hafta 1 hisoboti](docs/weekly/hafta-1.md)
- [Hafta 2 hisoboti](docs/weekly/hafta-2.md)

## Loyiha tuzilmasi

```
lib/
├── app.dart                   # Bosh ilova vidjeti (Mavzu, Router, Global Providerlar)
├── main.dart                  # Kirish nuqtasi (main entrypoint)
├── core/
│   ├── error/                 # Failure va Exception sinflari
│   ├── network/               # DioClient va ApiEndpoints
│   ├── router/                # GoRouter marshrutlash sozlamalari
│   ├── theme/                 # AppColors va AppTheme (Material 3)
│   └── widgets/               # Umumiy UI vidjetlar (AppButton, AppTextField, LoadingIndicator, ErrorView)
└── features/
    └── auth/                  # Autentifikatsiya moduli (Feature-first)
        ├── data/              # Modellar, ma'lumot manbalari va repozitoriy realizatsiyasi
        ├── domain/            # Mohiyatlar (Entities) va repozitoriy shartnomalari
        └── presentation/      # BLoC, ekranlar (Splash, Login, Home)
```

## Getting Started

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
