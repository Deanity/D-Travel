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

**Traver** is a premium mobile travel application that allows users to discover, plan, and book their dream vacations. Built with **Flutter** for a consistent cross-platform experience and powered by **Supabase** as the backend for authentication and user data management.

---

## ✨ Key Features

### 🔐 Authentication & Onboarding
- **Splash Screen** — Smooth animated transition to the onboarding flow.
- **Immersive Onboarding** — 3 full-screen slides with local images (Mountain, Jungle, Beach) and brief descriptions.
- **Multi-Step Registration**:
  1. Enter full name
  2. Enter email address
  3. Set & confirm password
  4. 8-digit OTP verification (via Supabase email)
  5. Select favorite exploration categories (Beach, Mountain, etc.)
  6. Account creation success screen
- **Login** — Authentication via email & password using Supabase Auth.
- **Logout** — Confirmation via modal bottom sheet.

### 🏠 Homepage
- **Personalized greeting** based on the user's name from the database.
- **User profile picture** from local assets.
- **Category Filter Bar** — Filter destinations by type (Beach, Forest, Ocean, etc.).
- **Favorite Places** — Horizontal scroll with local images (Kuta Beach, Bromo Mountain).
- **Popular Packages** — List of popular travel packages (Kuta Resort, Jepara Resort).

### 📍 Destination Detail (`placeCover.dart`)
- **Photo Slideshow** — Auto-scrolling 3-image Showcase with `PageView` and page indicator.
- **Destination Info** — Name, location, rating, price, and full description.
- **What's Included** — Package indicator chips (Flight, Hotel, Transport).
- **Gallery Photos** — 3-image local grid with "+20" overlay counter.
- **Location Map** — Static map image (`DummyMaps.png`) with decorative pin icon and zoom controls.
- **Reviews & Ratings** — User review list with avatar, name, date, and star rating.

### 🗓️ Booking Flow
- **Date Picker** — `BookingDatePicker` modal bottom sheet for selecting check-in and check-out dates.
- **Booking Detail** — Form to fill in traveler information (Name, Contact, ID Card, number of members).
- **Payment Method** — Selection of available payment methods.
- **Confirmation** — Transaction summary before final confirmation.
- **Success Screen** — Booking confirmation screen.

### 💛 Wishlist
- Save favorite destinations with an image card layout.
- Local data using asset images (`KutaResort`, `JeparaResort`, `BromoMountain`).

### 🧳 My Trip
- Manage booked trips (Upcoming & History).

### 👤 Profile
- Displays user data fetched from the `users` table in Supabase.
- Profile picture from local assets (`pfp.png`).
- Menu: Personal Information, Notification, FAQ, Language, Logout.

### 🔔 Notifications
- Screen for trip notifications and promotions.

---

## 🗂️ Project Structure

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
    │       └── DummyMaps.png      # Static map placeholder
    ├── assets/
    │   └── images/
    │       └── Traver.png         # App logo / launcher icon
    ├── android/                   # Android native config (label: "Traver")
    ├── ios/                       # iOS native config (CFBundleName: "Traver")
    ├── .env                       # Supabase credentials (not committed)
    ├── .env.example               # Environment template
    └── pubspec.yaml               # Dependencies & assets config
```

---

## 🔧 Tech Stack & Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter` | SDK | Cross-platform UI framework |
| `supabase_flutter` | ^2.12.2 | Backend: Auth, Database (PostgreSQL) |
| `flutter_dotenv` | ^6.0.0 | Environment variable management |
| `shared_preferences` | ^2.5.5 | Local data storage |
| `google_fonts` | ^6.2.1 | Typography (Inter, etc.) |
| `flutter_launcher_icons` | ^0.13.1 | App launcher icon generator |

---

## ⚙️ Setup & Installation

### Prerequisites
- Flutter SDK `^3.x` installed
- Dart SDK `^3.11.1`
- A [Supabase](https://supabase.com) account
- Android Studio / Xcode (for emulator/simulator)

### Installation Steps

**1. Clone the repository**
```bash
git clone https://github.com/Deanity/Traver.git
cd Traver/apps
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Configure environment variables**

Copy `.env.example` to `.env` and fill in your Supabase credentials:
```bash
cp .env.example .env
```
```env
VITE_SUPABASE_URL=https://<your-project-ref>.supabase.co
VITE_SUPABASE_ANON_KEY=<your-anon-key>
```

**4. Run the app**
```bash
flutter run
```

### Generate Launcher Icon (optional)
```bash
dart run flutter_launcher_icons
```

---

## 🗄️ Supabase Schema

The app uses a `users` table in the `public` schema with the following columns:

| Column | Type | Description |
|---|---|---|
| `id` | `uuid` | Primary key, references `auth.users` |
| `name` | `text` | User's full name |
| `email` | `text` | Email address |
| `role` | `text` | User role (default: `user`) |
| `created_at` | `timestamptz` | Account creation timestamp |

> **Trigger**: A database trigger on `auth.users` automatically populates `public.users` when a new user registers.

---

## 🎨 Design System

| Element | Value |
|---|---|
| **Primary Color** | `#FCD240` (Traver Yellow) |
| **Background** | `#FFFFFF` / `#FBFBFB` |
| **Font** | Inter (Google Fonts) |
| **Corner Radius** | 16px – 24px |
| **Theme** | Material 3 (Light) |

---

## 📱 App Screens

| Screen | Description |
|---|---|
| Splash Screen | Animated logo with transition to onboarding |
| Onboarding | 3 full-screen slides (Mountain, Jungle, Beach) |
| Login | Email & password form |
| Register | 6-step flow (Name → Email → Password → OTP → Favorites → Success) |
| Homepage | Greeting, Favorite Places, Popular Packages |
| Search | Category filter + search results list |
| Destination Detail | Slideshow, info, gallery, map, reviews |
| Booking | Date picker → Detail form → Payment → Confirmation |
| Wishlist | Saved favorite destinations |
| My Trip | Trip history and upcoming tickets |
| Profile | Account info + settings menu |

---

## 🚧 Development Notes

- The `.env` file **must not be committed** to the repository. Make sure it is listed in `.gitignore`.
- After adding new assets, always register the folder in `pubspec.yaml` under the `flutter > assets` section.
- After changing image paths (from network to asset), perform a **Hot Restart** (not Hot Reload) so Flutter correctly picks up the new assets.
- Navigation between main tabs (Home, Trip, Wishlist, Profile) uses `Navigator.pushReplacement` with `FadeTransition` for a smoother experience.

---

## 👤 Developer

Developed as part of the **Traver** project — a premium mobile travel application built with Flutter.

<p>
  <a href="https://www.instagram.com/shoyou.nt/?hl=id">
    <img alt="Instagram" src="https://img.shields.io/badge/@shoyou.nt-E4405F?logo=instagram&logoColor=white"/>
  </a>
</p>

---

## 🎨 Design Credits

UI/UX design inspired by and sourced from **Pickolab** — a creative design studio specializing in premium UI Kits and templates for mobile applications.

<p>
  <a href="https://www.instagram.com/pickolab/?hl=id">
    <img alt="Instagram" src="https://img.shields.io/badge/@pickolab-E4405F?logo=instagram&logoColor=white"/>
  </a>
</p>

---

*Version 1.0.0 — Traver Mobile App*
