# Hafta 2 hisoboti

## Qilingan ishlar
- **23.11** `flutter_secure_storage` paketini qo'shdim va tokenlarni faqat xavfsiz xotirada saqlovchi `TokenStorage` interfeysi hamda `SecureTokenStorage` sinfini yaratdim.
- **23.11** `AuthInterceptor` ni xotiradagi oddiy o'zgaruvchi o'rniga `TokenStorage` dan asinxron token olib `Authorization: Bearer <token>` qo'shadigan qilib o'zgartirdim.
- **23.11** `MockAuthRepositoryImpl` va `AuthRepositoryImpl` da login muvaffaqiyatli bo'lganda tokenlarni saqlash va logout qilinganda tozalash logikasini qo'shdim.
- **23.11** `LoggingInterceptor` da `Authorization` headeri `Bearer ***` ko'rinishida, parol va maxfiy ma'lumotlar esa `***MASKED***` qilib chiqarilishini tasdiqladim va moslashtirdim.
- **23.11** `main.dart` da `SecureTokenStorage` instansiyasini yaratib, repozitoriy va interceptorga bog'ladim.
- **23.11** `FakeTokenStorage` yaratib, tokenlarni saqlash, o'qish, tozalash, interceptor orqali headerga biriktirish va repozitoriy integratsiyasi bo'yicha 5 ta unit test yozdim.
- **23.11** `.gitignore` fayliga maxfiy kalitlar va sertifikatlar (`*.key`, `*.keystore`, `*.jks`, `*.p12`, `*.pfx`, `secrets.json`) kengaytmalarini qo'shdim.

## Muammolar
- `MockAuthRepositoryImpl` konstruktorida `_tokenStorage` xususiy maydoniga parametr biriktirilganda linter `prefer_initializing_formals` ogohlantirishini ko'rsatdi.

## Yechim
- Konstruktorni `this.tokenStorage` shakliga keltirib, maydonni to'g'ridan-to'g'ri boshlang'ichlash orqali ogohlantirishni bartaraf etdim.
