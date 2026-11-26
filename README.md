# SkyCast – Weather Forecast

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.47.8-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.13.7-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Architecture-MVVM-orange" alt="MVVM">
  <img src="https://img.shields.io/badge/State_Management-Provider-blue" alt="Provider">
  <img src="https://img.shields.io/badge/API-Open--Meteo-green" alt="Open-Meteo">
</p>

**SkyCast** adalah aplikasi prakiraan cuaca berbasis Flutter dan Dart dengan tema Dark Navy yang menyesuaikan kondisi cuaca serta waktu (siang/malam) secara dinamis. Aplikasi ini dibangun menggunakan arsitektur **Model-View-ViewModel (MVVM)**, integrasi **Open-Meteo REST API** (Current, Hourly 24 Jam, & Daily 7 Hari), deteksi lokasi **GPS perangkat**, state management **Provider**, serta penyimpanan lokal persisten melalui **SharedPreferences**.

---

## Tangkapan Layar (Screenshots)

<table>
  <tr>
    <td align="center" width="50%">
      <strong>1. Home Screen (Tampilan Awal)</strong><br><br>
      <img src="screenshots/WhatsApp%20Image%202026-11-26%20at%2007.07.16%20(1).jpeg" width="230" alt="Home Screen" />
    </td>
    <td align="center" width="50%">
      <strong>2. Home Screen (Scroll Bawah)</strong><br><br>
      <img src="screenshots/WhatsApp%20Image%202026-11-26%20at%2007.07.13.jpeg" width="230" alt="Home Screen Scroll" />
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <strong>3. 7-Day Forecast Chart (Geser Horizontal)</strong><br><br>
      <img src="screenshots/WhatsApp%20Image%202026-11-26%20at%2007.07.13%20(1).jpeg" width="230" alt="7-Day Forecast Chart" />
    </td>
    <td align="center" width="50%">
      <strong>4. Manage Cities & Update GPS</strong><br><br>
      <img src="screenshots/WhatsApp%20Image%202026-11-26%20at%2007.07.16.jpeg" width="230" alt="Manage Cities" />
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <strong>5. Preview Lokasi (Cancel / Save)</strong><br><br>
      <img src="screenshots/WhatsApp%20Image%202026-11-26%20at%2007.07.15.jpeg" width="230" alt="Location Preview" />
    </td>
    <td align="center" width="50%">
      <strong>6. Kota Tersimpan di Added Locations</strong><br><br>
      <img src="screenshots/WhatsApp%20Image%202026-11-26%20at%2007.07.15%20(1).jpeg" width="230" alt="Saved City" />
    </td>
  </tr>
</table>

---

## Fitur & Alur Layar Aplikasi

### 1. Home / Weather Screen
- **Dynamic Weather Background**: Gradasi warna latar belakang menyesuaikan kondisi cuaca (cerah, berawan, mendung, hujan, badai) dan waktu lokal kota (siang/malam) menggunakan `AnimatedContainer`.
- **Header & Lokasi**: Menampilkan nama kota aktif (otomatis dari GPS atau kota pilihan), negara, tanggal, serta tombol `+` di kanan atas untuk membuka halaman **Manage cities**.
- **Hero Temperature**: Suhu terkini berukuran besar, deskripsi kondisi cuaca, suhu maksimum/minimum hari ini, dan *Feels like*.
- **7-Day Forecast Card (Ringkas 3 Hari)**: Menampilkan prakiraan `Today`, `Tomorrow`, dan hari ke-3 lengkap dengan bar rentang suhu serta tombol **See all >** / **7-day forecast** untuk membuka grafik 7 hari penuh.
- **Hourly Forecast**: Daftar scroll horizontal prakiraan per jam lengkap dengan suhu dan peluang hujan (`%`).
- **Metric Cards (2x2 Grid)**: Menampilkan *Real feel*, *Humidity*, *Wind speed*, dan *Precipitation*.
- **Pull-to-Refresh**: Tarik ke bawah untuk memperbarui data cuaca secara real-time.

### 2. Manage Cities (Search & Save Locations Screen)
- **Search Bar dengan Debounce (500ms)**: Pencarian kota langsung melalui **Open-Meteo Geocoding API**.
- **Location Preview (Cancel / Save)**: Mengetuk hasil pencarian membuka halaman preview cuaca kota tersebut lengkap dengan tombol **Cancel** dan **Save**.
- **Current Location & Update GPS**: Mendeteksi lokasi terkini perangkat via `geolocator` + reverse geocoding Nominatim OpenStreetMap.
- **Added Locations (SharedPreferences)**: Menampilkan daftar kota tersimpan dengan suhu terkini, high/low, klik untuk memilih kota aktif, atau tombol hapus dengan dialog konfirmasi.

### 3. 7-Day Forecast Chart Screen
- Halaman khusus prakiraan 7 hari yang dapat digeser secara horizontal, menampilkan kolom *highlight* untuk `Today`, ikon cuaca, **dua garis kurva suhu halus** (suhu maksimum & minimum), serta peluang hujan harian.

---

## Teknologi & Dependensi

| Package | Versi | Fungsi |
| :--- | :--- | :--- |
| **Flutter SDK** | 3.47.8 | Framework aplikasi mobile multiplatform |
| **Dart SDK** | 3.13.7 | Bahasa pemrograman utama |
| **provider** | ^6.1.2 | State management reaktif berbasis `ChangeNotifier` |
| **http** | ^1.2.2 | HTTP Client untuk melakukan HTTP GET request |
| **shared_preferences** | ^2.3.2 | Local storage persisten di penyimpanan perangkat |
| **geolocator** | ^13.0.2 | Akses lokasi GPS perangkat secara real-time |
| **intl** | ^0.19.0 | Format tanggal, jam, dan hari |
| **cupertino_icons** | ^1.0.8 | Ikon pelengkap sistem |

---

## Struktur Folder Proyek

```text
lib/
├── app.dart                                # Konfigurasi MaterialApp dan tema dasar
├── main.dart                               # Entry point aplikasi, inisialisasi MultiProvider
├── core/                                   # Komponen inti aplikasi
│   ├── constants/
│   │   ├── api_constants.dart              # Endpoint Open-Meteo & parameter cuaca/hourly/daily
│   │   ├── app_colors.dart                 # Palet warna konsisten Material 3
│   │   ├── app_strings.dart                # Teks statis dan label aplikasi
│   │   └── view_state.dart                 # Enum status: initial, loading, success, empty, error
│   ├── theme/
│   │   └── app_theme.dart                  # Konfigurasi ThemeData Material 3
│   ├── utils/
│   │   ├── date_formatter.dart             # Formatter tanggal hari dan bulan
│   │   ├── debounce.dart                   # Utility debouncer untuk membatasi frekuensi request API
│   │   └── weather_code_helper.dart        # Penerjemah kode WMO ke teks, ikon, & gradasi background
│   └── widgets/
│       ├── empty_state_widget.dart         # Widget tampilan kosong informatif
│       ├── error_state_widget.dart         # Widget tampilan error beserta tombol retry
│       └── loading_widget.dart             # Indikator animasi loading konsisten
├── data/                                   # Lapisan data (Data Layer)
│   ├── models/
│   │   ├── current_weather_model.dart      # Model cuaca terkini
│   │   ├── daily_forecast_model.dart       # Model ramalan 7 hari ke depan
│   │   ├── hourly_forecast_model.dart      # Model ramalan 24 jam ke depan (per jam)
│   │   ├── location_model.dart             # Model lokasi kota, koordinat, dan serialisasi JSON
│   │   └── weather_model.dart              # Model induk respons Open-Meteo
│   ├── repositories/
│   │   ├── location_repository.dart        # Abstraksi data lokasi (pencarian + penyimpanan lokal)
│   │   └── weather_repository.dart         # Abstraksi data cuaca Open-Meteo
│   └── services/
│       ├── device_location_service.dart    # Akses GPS perangkat & reverse geocoding Nominatim
│       ├── geocoding_service.dart          # Komunikasi HTTP GET ke Geocoding API
│       ├── storage_service.dart            # Komunikasi ke SharedPreferences
│       └── weather_service.dart            # Komunikasi HTTP GET ke Weather Forecast API
└── features/                               # Lapisan fitur aplikasi (Presentation Layer)
    ├── search/
    │   ├── viewmodels/
    │   │   ├── saved_locations_viewmodel.dart # ViewModel manajemen kota tersimpan & cuaca ringkas
    │   │   └── search_viewmodel.dart          # ViewModel pencarian lokasi dengan debouncer
    │   ├── views/
    │   │   ├── location_preview_screen.dart   # Screen preview cuaca kota sebelum disimpan
    │   │   └── search_and_save_screen.dart    # Screen Manage cities (Pencarian, GPS, & Tersimpan)
    │   └── widgets/
    │       └── saved_location_card.dart       # Kartu lokasi tersimpan
    └── weather/
        ├── viewmodels/
        │   └── weather_viewmodel.dart         # ViewModel cuaca aktif, GPS, hourly, & daily
        ├── views/
        │   ├── seven_day_forecast_screen.dart # Screen grafik kurva prakiraan 7 hari (swipeable)
        │   └── weather_screen.dart            # Screen Home Cuaca utama
        └── widgets/
            ├── hourly_forecast_card.dart      # Horizontal scroll prakiraan per jam
            ├── seven_day_forecast_card.dart   # Ringkasan 3 hari + tombol ke 7-day forecast
            ├── weather_hero_card.dart         # Header kota, suhu utama, & kondisi cuaca
            └── weather_metrics_grid.dart      # Grid 2x2 metrik cuaca
```

---

## Penjelasan Arsitektur MVVM

1. **Model (`lib/data/models/`)**:
   - `LocationModel`: merepresentasikan entitas kota hasil geocoding, GPS, dan data yang disimpan.
   - `WeatherModel`: menaungi `CurrentWeatherModel`, `HourlyForecastModel`, dan `DailyForecastModel`.
   - Menggunakan factory `.fromJson()` dan `.toJson()` dengan validasi tipe numerik yang aman.
2. **View (`lib/features/.../views/`)**:
   - `WeatherScreen`, `SevenDayForecastScreen`, `SearchAndSaveScreen`, dan `LocationPreviewScreen`.
   - View tidak memanggil HTTP request secara langsung, melainkan mengamati ViewModel melalui `context.watch<T>()` / `context.read<T>()`.
3. **ViewModel (`lib/features/.../viewmodels/`)**:
   - `WeatherViewModel`: Mengelola state cuaca aktif, inisialisasi GPS / fallback lokasi terakhir, dan `refreshCurrentLocation()`.
   - `SearchViewModel`: Mengatur input pencarian, debounce 500ms, dan hasil geocoding.
   - `SavedLocationsViewModel`: Mengatur daftar kota favorit di `SharedPreferences` dan cache cuaca ringkasnya.
4. **Repository & Service (`lib/data/`)**:
   - `WeatherRepository` dan `LocationRepository` mengabstraksikan sumber data dari `WeatherService`, `GeocodingService`, `DeviceLocationService`, dan `StorageService`.

---

## Integrasi Open-Meteo REST API

### 1. Geocoding API (Pencarian Lokasi)
- **Endpoint**: `https://geocoding-api.open-meteo.com/v1/search`
- **Metode**: `HTTP GET`
- **Parameter**: `name`, `count=10`, `language=id`, `format=json`

### 2. Weather Forecast API (Cuaca Terkini, Hourly, & Daily)
- **Endpoint**: `https://api.open-meteo.com/v1/forecast`
- **Metode**: `HTTP GET`
- **Parameter**:
  - `latitude` & `longitude`
  - `current`: `temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m`
  - `hourly`: `temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,wind_speed_10m`
  - `daily`: `weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max`
  - `timezone`: `auto`

---

## Local Storage (Penyimpanan Lokal)

Menggunakan **SharedPreferences** melalui `StorageService`:
- `skycast_favorites_locations`: Menyimpan daftar lokasi kota yang disimpan dalam format list JSON string.
- `skycast_last_selected_location`: Menyimpan lokasi terakhir yang dipilih pengguna (atau hasil deteksi GPS) agar langsung dimuat saat aplikasi dibuka kembali.

---

## Panduan Menjalankan Aplikasi

1. Ambil dependensi:
   ```bash
   flutter pub get
   ```
2. Jalankan analisis kode:
   ```bash
   flutter analyze --no-pub
   ```
3. Jalankan pengujian:
   ```bash
   flutter test --no-pub
   ```
4. Jalankan aplikasi ke perangkat / emulator:
   ```bash
   flutter run
   ```
