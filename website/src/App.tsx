import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { AuthProvider } from '@/src/contexts/AuthContext';
import { ProtectedRoute } from '@/src/components/ProtectedRoute';
import { Layout } from '@/src/components/Layout';
import { LoginPage } from '@/src/pages/LoginPage';
import { Toaster } from '@/src/components/ui/sonner';

// Lazy load pages later or import them now
import { DashboardPage } from '@/src/pages/DashboardPage';
import { DestinationsPage } from '@/src/pages/DestinationsPage';
import { CategoriesPage } from '@/src/pages/CategoriesPage';
import { BookingsPage } from '@/src/pages/BookingsPage';
import { UsersPage } from '@/src/pages/UsersPage';
import { ReviewsPage } from '@/src/pages/ReviewsPage';

export default function App() {
  return (
    <Router>
      <AuthProvider>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          
          <Route path="/" element={
            <ProtectedRoute>
              <Layout>
                <DashboardPage />
              </Layout>
            </ProtectedRoute>
          } />

          <Route path="/destinations" element={
            <ProtectedRoute>
              <Layout>
                <DestinationsPage />
              </Layout>
            </ProtectedRoute>
          } />

          <Route path="/categories" element={
            <ProtectedRoute>
              <Layout>
                <CategoriesPage />
              </Layout>
            </ProtectedRoute>
          } />

          <Route path="/bookings" element={
            <ProtectedRoute>
              <Layout>
                <BookingsPage />
              </Layout>
            </ProtectedRoute>
          } />

          <Route path="/users" element={
            <ProtectedRoute>
              <Layout>
                <UsersPage />
              </Layout>
            </ProtectedRoute>
          } />

          <Route path="/reviews" element={
            <ProtectedRoute>
              <Layout>
                <ReviewsPage />
              </Layout>
            </ProtectedRoute>
          } />
        </Routes>
        <Toaster position="top-right" richColors />
      </AuthProvider>
    </Router>
  );
}
