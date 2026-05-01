# Traver Mobile App - Documentation

## ✈️ About Traver
**Traver** is a premium mobile travel application designed to provide users with a seamless experience in discovering, planning, and booking their dream vacations. Built with **Flutter** and **Supabase**, this app combines a stunning modern aesthetic with robust backend functionality.

---

## 🚀 Key Features

### 🔐 Authentication & Onboarding
- **Immersive Onboarding**: Introduction to the app's core values.
- **Personalized Registration**: Users select their favorite exploration categories (e.g., Beach, Mountain) during registration to customize their feed.
- **Secure Login**: Powered by Supabase Auth.
- **Recovery System**: Forgot password flow using **8-digit OTP** verification (Local-dev friendly).

### 🏠 Discovery & Home
- **Dynamic Homepage**: Personalized greetings and recommendations.
- **Category Filtering**: Explore locations by type (Beach, Forest, Ocean, etc.).
- **Interactive Cards**: High-quality imagery for favorite places and popular packages.

### 📍 Exploration Details
- **Immersive Detail Page**: Full-screen visuals with collapsed image cards.
- **Package Details**: Integrated view of "What's Included" (Flight, Hotel, Transport).
- **Social Proof**: Real user reviews and ratings.
- **Map Integration**: Visual location tracking.

### 🎒 Trip Management
- **Wishlist**: Save your favorite spots for later.
- **My Trip**: Manage and view your upcoming tickets and travel history.
- **User Profile**: Personalize account details and secure logout.

---

## 🎨 Design System
- **Primary Color**: `#FCD240` (Traver Yellow) - Representing energy and warmth.
- **Secondary Colors**: Pure Black and Clean White for a premium high-contrast look.
- **Typography**: Modern, bold headlines with clean sans-serif body text.
- **Transitions**: Smooth fade and slide transitions between screens for a liquid UI feel.

---

## 🛠 Tech Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (Auth, Database)
- **State Management**: StatefulWidgets (Local) & Shared Preferences (Cache).
- **Icons**: Material Icons & Custom Designed UI Elements.

---

## 📂 Project Structure
```text
lib/
├── auth/               # All authentication flows (Login, Register, OTP)
├── home/               # Main dashboard and core features
│   ├── details/        # Destination detail views
│   ├── listTrip/       # Trip history and tickets
│   ├── profile/        # User settings and profile info
│   ├── whishlist/      # Saved favorite places
│   └── homepage.dart   # Main discovery screen
├── screen/             # General screens (Splash, Onboarding)
└── main.dart           # App entry point
```

---

## ⚙️ Setup Instructions
1. **Prerequisites**: Ensure Flutter SDK is installed.
2. **Dependencies**: Run `flutter pub get`.
3. **Supabase Config**: Update your credentials in the initialization block (usually in `main.dart`).
4. **Run**: `flutter run`.

---

## 📝 Authors
Developed with ❤️ for world explorers.
