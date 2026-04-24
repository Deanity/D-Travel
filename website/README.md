# D-Travel Admin Dashboard - Documentation

## 🖥️ Overview
The **D-Travel Admin Dashboard** is a web-based management platform built to oversee the D-Travel travel ecosystem. It allows administrators to manage destinations, monitor user activity, and maintain the content featured on the mobile application.

---

## 🚀 Key Features

### 📍 Destination Management (CRUD)
- **Grid View**: A beautiful card-based layout to visualize all travel destinations.
- **Content Creation**: Add new destinations with titles, descriptions, pricing, and high-quality images.
- **Real-time Updates**: Edit existing travel packages and see changes instantly.
- **Safe Deletion**: Integrated custom confirmation modals to prevent accidental data loss.

### 🖼️ Asset Management
- **Image Uploads**: Streamlined process for managing destination banners and gallery photos.
- **Visual Branding**: Cohesive use of the D-Travel yellow branding across the UI.

### 📊 Administrative Controls
- **User Overview**: Monitor active travelers and their booking status.
- **Dynamic Filtering**: Easily search and filter through the destination database.

---

## 🎨 Professional Rebranding
- **Terminology**: Switched from generic or old naming (e.g., "Dezaa") to professional "D-Travel" branding.
- **Theme**: Consistent Yellow (`#FCD240`), Deep Black, and Modern White aesthetic.
- **UI Components**: High-quality modular components for Settings, Security, and Team management.

---

## 🛠 Tech Stack
- **Frontend**: React.js with TypeScript (`Vite`).
- **Styling**: Tailwind CSS / Vanilla CSS for a custom professional look.
- **Database**: Supabase (shared with the mobile app for real-time sync).
- **Icons**: Lucide React / Material Icons.

---

## 📂 Project Structure
```text
src/
├── components/         # Reusable UI components (Modals, Cards, Nav)
├── pages/              # Main dashboard views (Destinations, Settings)
├── hooks/              # Custom React hooks for data fetching
├── services/           # Supabase client and API logic
└── App.tsx             # Main routing and layout wrapper
```

---

## ⚙️ Setup Instructions
1. **Prerequisites**: Ensure Node.js and npm/yarn are installed.
2. **Installation**: Run `npm install`.
3. **Environment**: Setup `.env` with your Supabase URL and Anon Key.
4. **Development**: Run `npm run dev`.
5. **Build**: Run `npm run build` for production.

---

## 📝 Authors
Admin Management System for D-Travel Explorers.
