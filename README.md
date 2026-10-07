# ✝️ IGen Youth Mobile App

Aplikasi mobile resmi untuk komunitas youth & teens gereja (**Instagram: [@igen.youthxteens](https://instagram.com/igen.youthxteens)**). **IGen Youth** dirancang sebagai pusat informasi, kegiatan, event, komunitas sel (komsel), renungan harian, dan permohonan doa bagi generasi muda gereja dengan gaya bahasa santai namun tetap sopan, hangat, dan relevan.

> 🎨 **Inspirasi Desain**: Layout dan visual mengadopsi estetika referensi *Faith Notes* — menampilkan blok warna berlekuk (*curved hero banner*), tombol pill tebal, **Stacked Category Cards** dengan lekukan tab unik di atas kartu, serta *5-tab floating pill navigation bar*.

---

## 📱 Ringkasan Fitur

1. **Layar Welcome & Autentikasi Fleksibel**:
   - Hero banner maroon melengkung dengan aksen ilustrasi/foto kebersamaan youth.
   - Tombol utama pill kuning *"Mulai Sekarang"* untuk langsung masuk beranda sebagai **Tamu** (tanpa login paksa).
   - Opsi login & registrasi (Email & Google) untuk pendaftaran event, komsel, dan peran admin/leader.

2. **Beranda Interaktif**:
   - Header wordmark IGen Youth, tanggal hari ini, dan tombol notifikasi.
   - Shortcut bar maroon berbentuk pill: **Jadwal**, **Bantuan**, **Pengaturan**.
   - Outline pill search bar untuk mencari event, komsel, dan pengumuman secara real-time.
   - **Stacked Category Cards** dengan tab lekukan bertumpuk khas:
     - 📢 *Semua Info* (Maroon)
     - 🎟️ *Event* (Merah)
     - 👥 *Komsel* (Kuning)
     - 🗓️ *Kegiatan Rutin* (Mauve)
     - 📸 *Galeri* (Maroon Gelap)
   - Kartu kutipan *"Ayat Hari Ini"* berwarna soft-mint dengan watermark tanda kutip.
   - Carousel *"Event Mendatang"* dengan status kuota dan tombol RSVP langsung.
   - *Countdown Timer* menuju ibadah Youth Sabtu berikutnya (17:00 WIB).

3. **Event & Digital QR Ticketing**:
   - Filter pill kategori: Semua, Camp, Youth Night, Workshop, Sport, Outing.
   - Detail event lengkap: poster, waktu, lokasi, petunjuk Google Maps, PIC & tombol chat WhatsApp.
   - Tiket digital instan dengan QR Code dinamis (`qr_flutter`) untuk check-in di pintu masuk acara.

4. **Komunitas Sel (Komsel)**:
   - Pencarian berdasarkan wilayah (Jakarta Barat, Selatan, Pusat, Utara, Tangerang) & hari pertemuan.
   - Info kapasitas anggota dengan visual progress bar.
   - Profil Leader dengan tautan langsung kirim pesan WhatsApp.
   - Formulir pengajuan gabung komsel dan status persetujuan (*Pending / Approved*).

5. **Jadwal Kegiatan Rutin & Ibadah Mingguan**:
   - Timeline kegiatan terstruktur: Ibadah Youth Sabtu, Youth Service Minggu, Latihan Worship, Doa Malam.

6. **Pengumuman & Kabar Gereja**:
   - Feed pengumuman bertag (*Penting, Pelayanan, Komunitas, Umum*).
   - Pin pengumuman krusial ke bagian atas.

7. **Renungan Harian (Daily Devotion)**:
   - Tab navigasi harian (Senin - Minggu).
   - Nats firman Tuhan, renungan singkat, doa hari ini.
   - Tombol bookmark favorit & fitur generator kartu renungan siap bagikan ke Instagram Story/WhatsApp.

8. **Permohonan Doa (Prayer Wall)**:
   - Formulir kirim pokok doa dengan opsi anonim.
   - Umat dapat saling mendoakan dengan tombol interaktif *"Saya Mendoakan"* (+1 counter).

9. **Profil, Role Switcher Demo, & Mode Gelap**:
   - Melihat riwayat tiket QR dan status keanggotaan komsel.
   - **Role Switcher Demo** (Tamu, Member, Leader, Admin) untuk pengujian UI tanpa gonta-ganti akun.
   - Sakelar Dark Mode yang terintegrasi di seluruh aplikasi.

10. **Panel Admin & Leader**:
    - **Simulator Check-in Scanner**: Memasukkan / memindai kode QR tiket peserta secara langsung.
    - Manajemen Event, Komsel, dan Pengumuman gereja.
    - Persetujuan permintaan gabung komsel.

---

## 🛠️ Tech Stack & Arsitektur

- **Framework**: Flutter 3.47+ (Dart 3.13+)
- **Design System**: Material 3
- **State Management**: [Riverpod 3.x](https://riverpod.dev) (`flutter_riverpod`)
- **Routing**: [go_router 18.x](https://pub.dev/packages/go_router)
- **Typography**: [Google Fonts (Plus Jakarta Sans & Outfit)](https://fonts.google.com)
- **Icons**: [Lucide Icons Flutter](https://pub.dev/packages/lucide_icons_flutter)
- **QR Code**: [qr_flutter](https://pub.dev/packages/qr_flutter)
- **Architecture Pattern**: Feature-First Clean Architecture

```
lib/
├── core/
│   ├── theme/          # AppColors (token warna), AppTheme (Light & Dark)
│   ├── utils/          # Formatter tanggal & waktu Indonesia
│   └── widgets/        # Wordmark, StackedCategoryCard, FloatingNavBar, PillBars, dsb.
├── data/
│   ├── models/         # User, Event, Komsel, Announcement, Devotion, Prayer, dsb.
│   └── repositories/   # DummyData realistis + Repository Providers (Auth, Event, Komsel, dll.)
├── features/
│   ├── welcome/        # Layar pembuka / auth screen
│   ├── home/           # Beranda utama
│   ├── events/         # Daftar & detail event
│   ├── komsel/         # Daftar & detail komsel
│   ├── activities/     # Jadwal kegiatan rutin mingguan
│   ├── announcements/  # Warta jemaat & pengumuman
│   ├── devotion/       # Renungan harian
│   ├── prayer/         # Tembok doa
│   ├── gallery/        # Galeri momen pemuda
│   ├── notifications/  # Pusat notifikasi
│   ├── profile/        # Profil, tiket saya, role switcher demo
│   └── admin/          # Panel kontrol admin & scanner QR
├── routing/            # go_router konfigurasi rute
└── main.dart           # Inisialisasi Riverpod & Theme
```

---

## 🎨 Menyesuaikan Desain & Warna Brand

Semua token warna terpusat di satu berkas:
👉 **[`lib/core/theme/app_colors.dart`](file:///c:/Users/Hizkia%20Ariel%20Wijono/.gemini/antigravity/benchcode%20dev/igen_youth/lib/core/theme/app_colors.dart)**

Untuk mengubah palet warna sesuai logo resmi IGen Youth nantinya, Anda cukup mengganti nilai konstanta di berkas tersebut:

```dart
// lib/core/theme/app_colors.dart
class AppColors {
  // Ubah warna utama di sini:
  static const Color primaryMaroon     = Color(0xFF4B1D1D); // Warna utama
  static const Color primaryMaroonDark = Color(0xFF2E1010); // Latar gelap / aksen
  static const Color accentRed         = Color(0xFFEE3A35); // Aksen merah
  static const Color highlightYellow   = Color(0xFFFFC93C); // Pill aktif / badge
  static const Color mauve             = Color(0xFF6B4A5A); // Kartu kegiatan
  static const Color softMint          = Color(0xFFE6EEF0); // Kartu ayat hari ini
  static const Color softBackground    = Color(0xFFF3F6F7); // Background aplikasi
  ...
}
```

---

## 🚀 Cara Menjalankan Aplikasi

Pastikan Flutter SDK sudah terpasang.

### 1. Jalankan di Web (Browser)
```bash
cd "c:\Users\Hizkia Ariel Wijono\.gemini\antigravity\benchcode dev\igen_youth"
flutter pub get
flutter run -d chrome
```

Atau bangun versi statis untuk produksi web:
```bash
flutter build web --release
# File hasil build ada di folder build/web
```

### 2. Jalankan di Android Emulator / Device Fisik
```bash
flutter run -d android
```

### 3. Jalankan di iOS Simulator (macOS)
```bash
flutter run -d ios
```

---

## 🔥 Panduan Menghubungkan ke Firebase

Saat ini aplikasi menggunakan **Repository Pattern** dengan data lokal realistis berbahasa Indonesia di [`lib/data/repositories/dummy_data.dart`](file:///c:/Users/Hizkia%20Ariel%20Wijono/.gemini/antigravity/benchcode%20dev/igen_youth/lib/data/repositories/dummy_data.dart). Arsitektur ini dirancang agar Anda dapat beralih ke Firebase kapan pun tanpa perlu merombak tampilan UI.

### Langkah 1: Pasang Firebase CLI & FlutterFire
1. Pasang FlutterFire CLI jika belum ada:
   ```bash
   dart pub global activate flutterfire_cli
   ```
2. Login ke akun Google Firebase Anda:
   ```bash
   firebase login
   ```
3. Konfigurasikan proyek di folder `igen_youth`:
   ```bash
   flutterfire configure
   ```
   *(Pilih project Firebase gereja Anda di konsol)*

### Langkah 2: Tambahkan Dependensi Firebase
Tambahkan paket Firebase ke `pubspec.yaml`:
```bash
flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage firebase_messaging
```

### Langkah 3: Inisialisasi Firebase di `main.dart`
Perbarui awal fungsi `main()` di [`lib/main.dart`](file:///c:/Users/Hizkia%20Ariel%20Wijono/.gemini/antigravity/benchcode%20dev/igen_youth/lib/main.dart):
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Digenerate otomatis oleh flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: IGenYouthApp()));
}
```

### Langkah 4: Hubungkan Firestore ke Repository
Ganti implementasi data list lokal pada kelas repository menjadi Stream / Future Firestore:
- `eventRepositoryProvider`: Hubungkan dengan koleksi Firestore `events`.
- `komselRepositoryProvider`: Hubungkan dengan koleksi Firestore `komsel` dan `komselMembers`.
- `announcementRepositoryProvider`: Hubungkan dengan koleksi `announcements`.
- `devotionRepositoryProvider`: Hubungkan dengan koleksi `devotions`.
- `prayerRepositoryProvider`: Hubungkan dengan koleksi `prayerRequests`.
- `authRepositoryProvider`: Hubungkan dengan `FirebaseAuth.instance` dan dokumen user di `users/{uid}`.

Struktur model JSON di folder `lib/data/models/` sudah menyertakan method `toMap()` dan `fromMap()` yang 100% kompatibel dengan Cloud Firestore.

---

## 👥 Pengujian Demo Peran (Roles)

Untuk memudahkan peninjauan fitur tanpa login berkali-kali:
1. Masuk ke tab **Profil** di navigation bar bawah.
2. Pada bagian **"Ubah Role Akun (Untuk Demo)"**, klik tombol:
   - **Tamu**: Tombol admin disembunyikan; saat daftar event/komsel akan diminta login terlebih dahulu.
   - **Member**: Pengguna terdaftar; memiliki tiket aktif dan komsel terdaftar.
   - **Leader**: Pemimpin komsel; dapat melihat detail keanggotaan.
   - **Admin**: Menampilkan tombol `+` di beranda serta membuka akses ke **Admin Dashboard** (manajemen data & scanner tiket QR).

---

© 2026 **IGen Youth Community** • *Tempat anak muda bertumbuh, berkumpul, dan melayani bersama.*
