# Traver — Mobile Travel Application

<p align="center">
  <img src="apps/assets/images/Traver.png" alt="Traver Logo" width="100"/>
</p>

<p align="center">
  <strong>Discover. Plan. Book. Travel.</strong><br/>
  A premium mobile travel application built with Flutter & Supabase.
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter"/>
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart"/>
  <img alt="Supabase" src="https://img.shields.io/badge/Supabase-2.x-3ECF8E?logo=supabase"/>
  <img alt="Platform" src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey"/>
  <img alt="Version" src="https://img.shields.io/badge/Version-1.0.0-yellow"/>
  <a href="https://github.com/Deanity/Traver">
    <img alt="GitHub" src="https://img.shields.io/badge/GitHub-Deanity%2FTraver-181717?logo=github"/>
  </a>
</p>

---

## 📖 Overview

**Traver** adalah aplikasi travel mobile premium yang memungkinkan pengguna untuk menemukan, merencanakan, dan memesan perjalanan impian mereka. Aplikasi ini dibangun dengan **Flutter** untuk tampilan lintas platform yang konsisten, dan menggunakan **Supabase** sebagai backend untuk autentikasi dan manajemen data pengguna.

---

## ✨ Fitur Utama

### 🔐 Autentikasi & Onboarding
- **Splash Screen** — Transisi animasi halus ke layar onboarding.
- **Onboarding Immersif** — 3 slide dengan gambar lokal penuh layar (Mountain, Jungle, Beach) dan deskripsi singkat.
- **Registrasi Multi-langkah**:
  1. Input nama lengkap
  2. Input alamat email
  3. Input & konfirmasi password
  4. Verifikasi OTP 8-digit (via email Supabase)
  5. Pemilihan kategori eksplorasi favorit (Beach, Mountain, dll.)
  6. Layar sukses pembuatan akun
- **Login** — Autentikasi via email & password menggunakan Supabase Auth.
- **Logout** — Konfirmasi logout dengan modal bottom sheet.

### 🏠 Halaman Utama (Homepage)
- **Greeting personal** berdasarkan nama pengguna dari database.
- **Foto profil pengguna** dari aset lokal.
- **Category Filter Bar** — Filter destinasi berdasarkan kategori (Beach, Forest, Ocean, dsb.).
- **Favorite Places** — Tampilan horizontal scroll dengan gambar lokal (Kuta Beach, Bromo Mountain).
- **Popular Packages** — Daftar paket wisata populer (Kuta Resort, Jepara Resort).

### 📍 Detail Destinasi (`placeCover.dart`)
- **Slideshow Foto** — Auto-scroll 3 gambar Showcase dengan `PageView` dan indikator halaman.
- **Informasi Destinasi** — Nama, lokasi, rating, harga, dan deskripsi lengkap.
- **What's Included** — Chip indikator paket (Flight, Hotel, Transport).
- **Gallery Photos** — Grid 3 foto lokal dengan overlay counter "+20".
- **Peta Lokasi** — Gambar peta statis (`DummyMaps.png`) dengan ikon pin dan kontrol zoom dekoratif.
- **Review & Rating** — Daftar ulasan pengguna dengan avatar, nama, tanggal, dan bintang.

### 🗓️ Alur Booking
- **Date Picker** — Modal bottom sheet `BookingDatePicker` untuk memilih tanggal check-in dan check-out.
- **Detail Booking** — Form pengisian data pemesan (Nama, Kontak, ID Card, jumlah member).
- **Payment Method** — Pilihan metode pembayaran.
- **Confirmation** — Ringkasan transaksi sebelum konfirmasi.
- **Success Screen** — Layar konfirmasi booking berhasil.

### 💛 Wishlist
- Menyimpan destinasi favorit dengan tampilan kartu bergambar.
- Data lokal menggunakan gambar aset (`KutaResort`, `JeparaResort`, `BromoMountain`).

### 🧳 My Trip
- Manajemen perjalanan yang sudah dipesan (Upcoming & History).

### 👤 Profil
- Menampilkan data pengguna yang diambil dari tabel `users` di Supabase.
- Foto profil dari aset lokal (`pfp.png`).
- Menu: Personal Information, Notification, FAQ, Language, Logout.

### 🔔 Notifikasi
- Layar notifikasi perjalanan dan promosi.

---

## 🗂️ Struktur Proyek

```
DTravel/
└── apps/                          # Flutter project root
    ├── lib/
    │   ├── main.dart              # Entry point, Supabase init
    │   ├── screen/
    │   │   ├── splash_screen.dart
    │   │   └── onboarding_screen.dart
    │   ├── auth/
    │   │   ├── login/
    │   │   │   └── login.dart
    │   │   └── register/
    │   │       ├── createNewAccName.dart
    │   │       ├── createNewAccEmail.dart
    │   │       ├── createNewAccPassword.dart
    │   │       ├── createNewAccOTP.dart
    │   │       ├── favoriteExplore.dart
    │   │       └── succesCreateAcc.dart
    │   ├── home/
    │   │   ├── homepage.dart
    │   │   ├── details/
    │   │   │   ├── placeCover.dart
    │   │   │   └── bookingDatePicker.dart
    │   │   ├── booking/
    │   │   │   ├── detailBooking.dart
    │   │   │   ├── paymentMethod.dart
    │   │   │   ├── payment.dart
    │   │   │   └── succesBooking.dart
    │   │   ├── search/
    │   │   │   └── search.dart
    │   │   ├── whishlist/
    │   │   │   └── wishList.dart
    │   │   ├── listTrip/
    │   │   │   └── myTrip.dart
    │   │   ├── profile/
    │   │   │   └── profile.dart
    │   │   └── notification/
    │   │       └── notif.dart
    │   └── assets/
    │       ├── loadingScreen/     # Onboarding images (Mountain, Jungle, Beach)
    │       ├── homePage/          # KutaBeach, BromoMountain, KutaResort, JeparaResort
    │       ├── detailPage/        # Showcase1, Showcase2, Showcase3
    │       │   └── gallery/       # image1, image2, image3
    │       ├── profile/           # pfp.png
    │       └── DummyMaps.png      # Map placeholder
    ├── assets/
    │   └── images/
    │       └── Traver.png         # App logo / launcher icon
    ├── android/                   # Android native config (label: "Traver")
    ├── ios/                       # iOS native config (CFBundleName: "Traver")
    ├── .env                       # Supabase credentials (tidak di-commit)
    ├── .env.example               # Template env
    └── pubspec.yaml               # Dependencies & assets config
```

---

## 🔧 Tech Stack & Dependencies

| Package | Versi | Kegunaan |
|---|---|---|
| `flutter` | SDK | Framework UI lintas platform |
| `supabase_flutter` | ^2.12.2 | Backend: Auth, Database (PostgreSQL) |
| `flutter_dotenv` | ^6.0.0 | Manajemen environment variables |
| `shared_preferences` | ^2.5.5 | Penyimpanan data lokal |
| `google_fonts` | ^6.2.1 | Tipografi (Inter, dll.) |
| `flutter_launcher_icons` | ^0.13.1 | Generator ikon aplikasi |

---

## ⚙️ Setup & Cara Menjalankan

### Prasyarat
- Flutter SDK `^3.x` sudah terinstall
- Dart SDK `^3.11.1`
- Akun [Supabase](https://supabase.com)
- Android Studio / Xcode (untuk emulator)

### Langkah Instalasi

**1. Clone repository**
```bash
git clone https://github.com/Deanity/Traver.git
cd Traver/apps
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Konfigurasi environment**

Salin file `.env.example` menjadi `.env` dan isi dengan credentials Supabase Anda:
```bash
cp .env.example .env
```
```env
VITE_SUPABASE_URL=https://<your-project-ref>.supabase.co
VITE_SUPABASE_ANON_KEY=<your-anon-key>
```

**4. Jalankan aplikasi**
```bash
flutter run
```

### Generate Launcher Icon (opsional)
```bash
dart run flutter_launcher_icons
```

---

## 🗄️ Supabase Schema

Aplikasi menggunakan tabel `users` di schema `public` dengan kolom berikut:

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | `uuid` | Primary key, referensi ke `auth.users` |
| `name` | `text` | Nama lengkap pengguna |
| `email` | `text` | Alamat email |
| `role` | `text` | Role pengguna (default: `user`) |
| `created_at` | `timestamptz` | Waktu pembuatan akun |

> **Trigger**: Sebuah database trigger pada tabel `auth.users` secara otomatis mengisi tabel `public.users` saat pengguna baru mendaftar.

---

## 🎨 Design System

| Elemen | Nilai |
|---|---|
| **Primary Color** | `#FCD240` (Kuning Traver) |
| **Background** | `#FFFFFF` / `#FBFBFB` |
| **Font** | Inter (Google Fonts) |
| **Corner Radius** | 16px – 24px |
| **Tema** | Material 3 (Light) |

---

## 📱 Tampilan Aplikasi

| Layar | Deskripsi |
|---|---|
| Splash Screen | Logo animasi dengan transisi ke onboarding |
| Onboarding | 3 slide gambar penuh (Mountain, Jungle, Beach) |
| Login | Form email & password |
| Register | Alur 6 langkah (Nama → Email → Password → OTP → Favorit → Sukses) |
| Homepage | Greeting, Favorite Places, Popular Packages |
| Search | Filter kategori + daftar hasil pencarian |
| Detail Destinasi | Slideshow, info, galeri, peta, review |
| Booking | Date picker → Form detail → Pembayaran → Konfirmasi |
| Wishlist | Daftar destinasi favorit tersimpan |
| My Trip | Riwayat dan tiket perjalanan |
| Profile | Data akun + menu pengaturan |

---

## 🚧 Catatan Pengembangan

- File `.env` **tidak boleh di-commit** ke repository. Pastikan sudah tercantum di `.gitignore`.
- Setelah menambahkan aset baru, selalu daftarkan foldernya di `pubspec.yaml` di bawah bagian `flutter > assets`.
- Setelah mengubah path gambar (dari network ke asset), lakukan **Hot Restart** (bukan Hot Reload) agar perubahan aset terbaca dengan benar oleh Flutter.
- Navigasi antar tab utama (Home, Trip, Wishlist, Profile) menggunakan `Navigator.pushReplacement` dengan `FadeTransition` untuk pengalaman yang lebih halus.

---

## 👤 Developer

Dikembangkan sebagai bagian dari project **Traver** — sebuah aplikasi travel mobile premium berbasis Flutter.

<p>
  <a href="https://www.instagram.com/shoyou.nt/?hl=id">
    <img alt="Instagram" src="https://img.shields.io/badge/@shoyou.nt-E4405F?logo=instagram&logoColor=white"/>
  </a>
</p>

---

## 🎨 Design Credits

UI/UX design terinspirasi dan bersumber dari karya **Pickolab** — studio desain kreatif yang berfokus pada UI Kit dan template premium untuk aplikasi mobile.

<p>
  <a href="https://www.instagram.com/pickolab/?hl=id">
    <img alt="Instagram" src="https://img.shields.io/badge/@pickolab-E4405F?logo=instagram&logoColor=white"/>
  </a>
</p>

---

*Versi 1.0.0 — Traver Mobile App*
