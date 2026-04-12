# Supabase Database Schema

Run the following SQL in your Supabase SQL Editor to set up the tables and initial data.

```sql
-- Create users table
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone TEXT,
  profile_picture TEXT,
  language TEXT DEFAULT 'en',
  is_dark_mode BOOLEAN DEFAULT false,
  role TEXT DEFAULT 'user' CHECK (role IN ('admin', 'user')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create categories table
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create destinations table
CREATE TABLE destinations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  location TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  rating DECIMAL(3, 2) DEFAULT 0,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create destination_images table
CREATE TABLE destination_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  destination_id UUID REFERENCES destinations(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create bookings table
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  destination_id UUID REFERENCES destinations(id) ON DELETE CASCADE,
  booking_date TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  visit_date DATE NOT NULL,
  total_price DECIMAL(10, 2) NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'cancelled')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create payments table
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID REFERENCES bookings(id) ON DELETE CASCADE,
  payment_method TEXT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'success', 'failed')),
  paid_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create wishlists table
CREATE TABLE wishlists (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  destination_id UUID REFERENCES destinations(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create reviews table
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  destination_id UUID REFERENCES destinations(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Enable Row Level Security (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE destinations ENABLE ROW LEVEL SECURITY;
ALTER TABLE destination_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Create policies (Simplified for Admin access)
-- Note: In a real app, you'd have more granular policies.
-- These policies allow admins to do everything.

CREATE POLICY "Admins can do everything on users" ON users FOR ALL TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
);

CREATE POLICY "Admins can do everything on categories" ON categories FOR ALL TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
);

CREATE POLICY "Admins can do everything on destinations" ON destinations FOR ALL TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
);

CREATE POLICY "Admins can do everything on destination_images" ON destination_images FOR ALL TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
);

CREATE POLICY "Admins can do everything on bookings" ON bookings FOR ALL TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
);

CREATE POLICY "Admins can do everything on payments" ON payments FOR ALL TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
);

CREATE POLICY "Admins can do everything on wishlists" ON wishlists FOR ALL TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
);

CREATE POLICY "Admins can do everything on reviews" ON reviews FOR ALL TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'admin'
);

-- Create a trigger to automatically create a user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, name, email, role)
  VALUES (new.id, COALESCE(new.raw_user_meta_data->>'name', new.email), new.email, 'user');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Insert some initial categories
INSERT INTO categories (name) VALUES ('Adventure'), ('Luxury'), ('Beach'), ('Cultural'), ('Nature');
```

### How to make yourself an Admin:
After signing up, run this in the SQL editor:
```sql
UPDATE users SET role = 'admin' WHERE email = 'your-email@example.com';
```
