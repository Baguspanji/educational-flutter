# GastroFun - Digestive System Learning App

Aplikasi pembelajaran interaktif yang berfokus pada sistem pencernaan manusia untuk pembelajaran ipas.

## Fitur Utama

1. **Materi Belajar** - Konten terstruktur dalam bentuk bab/modul
2. **LKPD (Lembar Kerja)** - Latihan interaktif dengan berbagai jenis soal
3. **Video Pembelajaran** - Koleksi video pendek yang menjelaskan konsep kunci
4. **Artikel Terkait** - Kumpulan artikel relevan dan berita terkini
5. **Kuis** - Assessment interaktif di akhir setiap bab

## Struktur Proyek

```text
├── lib/                  # Folder utama untuk kode Dart
│   ├── main.dart         # Titik masuk utama aplikasi
│   ├── screens/          # Folder untuk setiap halaman/layar aplikasi
│   │   └── home_screen.dart
│   └── widgets/          # Folder untuk widget yang dapat digunakan kembali
│       └── custom_button.dart
├── assets/               # Untuk gambar, font, atau file lainnya
│   └── images/
│       └── logo.png
```

## Teknologi yang Digunakan

- Flutter SDK
- Provider (State Management)
- Google Fonts

## Instalasi dan Menjalankan Proyek

1. **Prasyarat:**
   - Flutter SDK (versi terbaru)
   - Dart SDK (versi terbaru)
   - Android Studio / VS Code dengan plugin Flutter

2. **Clone repositori:**

   ```bash
   git clone https://github.com/username/educational_app.git
   cd educational_app
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Run the app in debug mode:**

   ```bash
   flutter run
   ```

## Building Release Versions

### Setting Up Android Release

1. **Generate a keystore file** (if you don't have one already):

   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Move the keystore file** to the app's android folder:

   ```bash
   mv ~/upload-keystore.jks android/app/upload-keystore.jks
   ```

3. **Update the key.properties file** with your keystore information:
   - Open `android/key.properties`
   - Replace placeholder values with your actual keystore password and key password

### Building Android Release

1. **Build an Android APK:**

   ```bash
   flutter build apk --release
   ```
   
   The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

2. **Build an Android App Bundle for Play Store:**

   ```bash
   flutter build appbundle --release
   ```
   
   The bundle will be located at `build/app/outputs/bundle/release/app-release.aab`

### Building iOS Release

1. **Prepare for iOS release:**

   ```bash
   flutter build ios --release
   ```

2. **Archive and upload to App Store** using Xcode:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select a real device or "Any iOS Device" as the build target
   - Go to Product > Archive
   - Use the Organizer window to validate and distribute your app
   ```

4. **Jalankan aplikasi:**

   ```bash
   flutter run
   ```

## Tema Aplikasi

Aplikasi menggunakan skema warna yang didesain khusus berdasarkan PRD:

- **Primary Color**: Deep Blue - Profesionalisme dan kepercayaan
- **Secondary Color**: Teal - Supporting elements
- **Tertiary Color**: Sky Blue - Backgrounds
- **Accent Color**: Warm Orange - CTA buttons dan highlights

Font yang digunakan adalah Inter, yang memberikan tampilan modern dan mudah dibaca.
