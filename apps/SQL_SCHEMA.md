```sql

create extension if not exists "pgcrypto";

-- USERS
create table users (
  id uuid primary key references auth.users(id),
  name text,
  email text unique,
  phone text,
  role text check (role in ('admin','user','vendor')) default 'user',
  created_at timestamp default now()
);

-- DESTINATIONS
create table destinations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  country text,
  city text,
  description text,
  latitude double precision,
  longitude double precision,
  created_at timestamp default now()
);

-- PACKAGES (🔥 tambah created_by)
create table packages (
  id uuid primary key default gen_random_uuid(),
  destination_id uuid references destinations(id),
  title text not null,
  description text,
  duration_days int,
  base_price decimal,
  rating decimal default 0,
  created_by uuid references users(id), -- penting untuk vendor
  created_at timestamp default now()
);

-- SCHEDULES (🔥 tambah created_by)
create table schedules (
  id uuid primary key default gen_random_uuid(),
  package_id uuid references packages(id),
  start_date date,
  end_date date,
  quota int,
  booked_count int default 0,
  price decimal,
  status text check (status in ('available','full','cancelled')) default 'available',
  created_by uuid references users(id),
  created_at timestamp default now()
);

-- BOOKINGS
create table bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id),
  schedule_id uuid references schedules(id),
  total_price decimal,
  total_travelers int,
  status text check (status in ('pending','confirmed','cancelled','completed')) default 'pending',
  expires_at timestamp,
  created_at timestamp default now()
);

-- TRAVELERS
create table travelers (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid references bookings(id) on delete cascade,
  full_name text,
  age int,
  passport_number text,
  created_at timestamp default now()
);

-- ADDONS
create table addons (
  id uuid primary key default gen_random_uuid(),
  name text,
  price decimal
);

create table booking_addons (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid references bookings(id),
  addon_id uuid references addons(id),
  quantity int
);

-- PAYMENTS
create table payments (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid references bookings(id),
  provider text,
  external_id text,
  amount decimal,
  status text check (status in ('pending','paid','failed','expired')) default 'pending',
  payment_url text,
  expired_at timestamp,
  paid_at timestamp,
  created_at timestamp default now()
);

-- COUPONS
create table coupons (
  id uuid primary key default gen_random_uuid(),
  code text unique,
  discount_type text check (discount_type in ('percentage','fixed')),
  value decimal,
  max_usage int,
  used_count int default 0,
  expired_at timestamp
);

create table coupon_usages (
  id uuid primary key default gen_random_uuid(),
  coupon_id uuid references coupons(id),
  booking_id uuid references bookings(id),
  user_id uuid references users(id),
  created_at timestamp default now()
);

-- REVIEWS
create table reviews (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid references bookings(id),
  rating int check (rating between 1 and 5),
  comment text,
  created_at timestamp default now()
);

-- WISHLISTS
create table wishlists (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id),
  package_id uuid references packages(id),
  created_at timestamp default now()
);

-- IMAGES
create table images (
  id uuid primary key default gen_random_uuid(),
  entity_type text check (entity_type in ('destination','package')),
  entity_id uuid,
  url text
);

alter table users enable row level security;
alter table destinations enable row level security;
alter table packages enable row level security;
alter table schedules enable row level security;
alter table bookings enable row level security;
alter table travelers enable row level security;
alter table addons enable row level security;
alter table booking_addons enable row level security;
alter table payments enable row level security;
alter table coupons enable row level security;
alter table coupon_usages enable row level security;
alter table reviews enable row level security;
alter table wishlists enable row level security;
alter table images enable row level security;

-- ambil role user
create or replace function public.get_user_role()
returns text as $$
  select role from users where id = auth.uid();
$$ language sql stable;

create or replace function public.is_admin()
returns boolean as $$
  select public.get_user_role() = 'admin';
$$ language sql stable;

create or replace function public.is_vendor()
returns boolean as $$
  select public.get_user_role() = 'vendor';
$$ language sql stable;

create policy "user read own"
on users for select using (auth.uid() = id);

create policy "user update own"
on users for update using (auth.uid() = id);

create policy "admin full users"
on users for all using (public.is_admin());

create policy "public read destinations"
on destinations for select using (true);

create policy "admin manage destinations"
on destinations for all using (public.is_admin());

create policy "public read packages"
on packages for select using (true);

create policy "vendor manage packages"
on packages for all
using (public.is_vendor() and created_by = auth.uid());

create policy "admin full packages"
on packages for all using (public.is_admin());

create policy "public read schedules"
on schedules for select using (true);

create policy "vendor manage schedules"
on schedules for all
using (public.is_vendor() and created_by = auth.uid());

create policy "admin full schedules"
on schedules for all using (public.is_admin());

create policy "user view own bookings"
on bookings for select using (auth.uid() = user_id);

create policy "user create booking"
on bookings for insert with check (auth.uid() = user_id);

create policy "vendor view bookings"
on bookings for select using (
  public.is_vendor() AND EXISTS (
    SELECT 1 FROM schedules s
    JOIN packages p ON s.package_id = p.id
    WHERE s.id = bookings.schedule_id
    AND p.created_by = auth.uid()
  )
);

create policy "admin full bookings"
on bookings for all using (public.is_admin());

create policy "user manage travelers"
on travelers for all using (
  exists (
    select 1 from bookings b
    where b.id = travelers.booking_id
    and b.user_id = auth.uid()
  )
);

create policy "admin full travelers"
on travelers for all using (public.is_admin());

create policy "user view payments"
on payments for select using (
  exists (
    select 1 from bookings b
    where b.id = payments.booking_id
    and b.user_id = auth.uid()
  )
);

create policy "user create payments"
on payments for insert with check (
  exists (
    select 1 from bookings b
    where b.id = booking_id
    and b.user_id = auth.uid()
  )
);

create policy "admin full payments"
on payments for all using (public.is_admin());

create policy "user wishlist"
on wishlists for all using (auth.uid() = user_id);

create policy "admin wishlist"
on wishlists for all using (public.is_admin());

create policy "public read reviews"
on reviews for select using (true);

create policy "user create review"
on reviews for insert with check (
  exists (
    select 1 from bookings b
    where b.id = booking_id
    and b.user_id = auth.uid()
    and b.status = 'completed'
  )
);

create policy "admin reviews"
on reviews for all using (public.is_admin());

create policy "public read coupons"
on coupons for select using (true);

create policy "admin manage coupons"
on coupons for all using (public.is_admin());

create policy "user coupon usage"
on coupon_usages for all using (auth.uid() = user_id);

create policy "admin coupon usage"
on coupon_usages for all using (public.is_admin());

create policy "public read addons"
on addons for select using (true);

create policy "admin addons"
on addons for all using (public.is_admin());

create policy "public read images"
on images for select using (true);

create policy "admin images"
on images for all using (public.is_admin());

create or replace function update_quota()
returns trigger as $$
begin
  if new.status = 'confirmed' then
    update schedules
    set booked_count = booked_count + new.total_travelers
    where id = new.schedule_id;
  end if;
  return new;
end;
$$ language plpgsql;

create trigger trg_update_quota
after update on bookings
for each row
execute function update_quota();

create or replace function update_quota()
returns trigger as $$
begin
  if new.status = 'confirmed' AND old.status is distinct from 'confirmed' then
    update schedules
    set booked_count = booked_count + new.total_travelers
    where id = new.schedule_id;
  end if;
  return new;
end;
$$ language plpgsql;

create policy "user manage booking addons"
on booking_addons for all using (
  exists (
    select 1 from bookings b
    where b.id = booking_addons.booking_id
    and b.user_id = auth.uid()
  )
);

create policy "admin full booking addons"
on booking_addons for all using (public.is_admin());

drop policy if exists "vendor manage packages" on packages;

create policy "vendor manage packages"
on packages for all
using (public.is_vendor() and created_by = auth.uid())
with check (public.is_vendor() and created_by = auth.uid());

create index if not exists idx_bookings_user_id on bookings(user_id);
create index if not exists idx_bookings_schedule_id on bookings(schedule_id);
create index if not exists idx_schedules_package_id on schedules(package_id);
create index if not exists idx_packages_created_by on packages(created_by);
create index if not exists idx_payments_booking_id on payments(booking_id);

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (id, email, name, role)
  values (
    new.id, 
    new.email, 
    concat(new.raw_user_meta_data->>'first_name', ' ', new.raw_user_meta_data->>'last_name'),
    'user'
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

alter table bookings
add constraint bookings_total_travelers_check check (total_travelers > 0);

alter table schedules
add constraint schedules_quota_check check (quota >= 0);
```