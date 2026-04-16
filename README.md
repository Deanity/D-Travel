# DTravel - Complete Travel Ecosystem

Welcome to the **DTravel** project, an integrated travel platform featuring a premium mobile application for travelers and a robust admin dashboard for platform management.

---

## 🏗️ Project Architecture
DTravel is divided into two main components that communicate through a unified backend:

### 📱 [Mobile Application](./apps)
The traveler-facing side of the ecosystem. Built with **Flutter**, it provides a high-end experience for discovering destinations, booking trips, and managing travel itineraries.
- **Location**: `/apps`
- **Primary Tech**: Flutter, Supabase Auth, Shared Preferences.
- **Key Features**: Personalization, Immersive Detail Pages, OTP Recovery, Wishlist.

### 🖥️ [Admin Dashboard](./website)
The administrative side of the ecosystem. Built with **React and TypeScript**, it allows the DTravel team to manage content, monitor destinations, and oversee user activity.
- **Location**: `/website`
- **Primary Tech**: React (Vite), Tailwind CSS, Supabase Database.
- **Key Features**: Destination CRUD, Image Management, User Analytics.

---

## ☁️ Unified Backend
Both platforms share a single **Supabase** instance, ensuring:
- **Real-time Sync**: Changes made in the Admin Dashboard are instantly reflected in the Mobile App.
- **Centralized Auth**: Seamless user management.
- **Data Integrity**: Unified destination and review database.

---

## 📂 Repository Structure
```text
DTravel/
├── apps/               # Flutter Mobile Project (Traveler Client)
│   └── README.md       # Mobile-specific documentation
├── website/            # React Web Project (Admin Dashboard)
│   └── README.md       # Web-specific documentation
└── README.md           # Master Documentation (this file)
```

---

## 🚦 How to Get Started

### Core Requirements
- **Flutter SDK** (for mobile)
- **Node.js & npm** (for web)
- **Supabase Account** (backend)

### Setup Steps
1.  **Backend**: Configure your Supabase project and database schema.
2.  **Web Dashboard**:
    ```bash
    cd website
    npm install
    npm run dev
    ```
3.  **Mobile App**:
    ```bash
    cd apps
    flutter pub get
    flutter run
    ```

---

## 🎨 Branding & Vision
DTravel aims to redefine the travel discovery experience by combining a high-contrast aesthetic (Yellow #FCD240 & Deep Black) with ultra-smooth transitions and intuitive layouts.

---

## 📝 Authors
The DTravel Development Team.
