-- 0001_init_schema.sql
-- Fase 1: tabel inti, fungsi helper, trigger updated_at

create table admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

create or replace function is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;

create or replace function set_updated_at() returns trigger
language plpgsql set search_path = public as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Singleton: hanya boleh satu baris (id = 1)
create table profile (
  id int primary key default 1 check (id = 1),
  full_name text not null,
  headline text,
  bio text,
  photo_url text,
  email text,
  socials jsonb not null default '{}',
  cv_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table projects (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  title text not null,
  summary text,
  description text,                       -- Markdown
  category text,
  tech_stack text[] not null default '{}',
  role text,
  demo_url text,
  repo_url text,
  thumbnail_url text,
  gallery text[] not null default '{}',
  year int,
  status text not null default 'draft' check (status in ('draft','published')),
  featured boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table achievements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  organizer text,
  level text,                             -- kampus, regional, nasional, internasional
  placement text,
  achieved_at date,
  description text,
  image_url text,
  certificate_url text,
  status text not null default 'draft' check (status in ('draft','published')),
  featured boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table experiences (
  id uuid primary key default gen_random_uuid(),
  type text not null check (type in ('asdos','organisasi','kepanitiaan','magang')),
  position text not null,
  organization text not null,
  start_date date,
  end_date date,
  highlights text[] not null default '{}',
  status text not null default 'draft' check (status in ('draft','published')),
  featured boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table skills (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null check (category in ('technical','soft','language')),
  level int check (level between 1 and 5),
  icon text,
  status text not null default 'draft' check (status in ('draft','published')),
  featured boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table education (
  id uuid primary key default gen_random_uuid(),
  degree text not null,
  institution text not null,
  start_year int,
  end_year int,
  gpa numeric(3,2),
  description text,
  status text not null default 'draft' check (status in ('draft','published')),
  featured boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table certifications (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  issuer text,
  issued_at date,
  credential_url text,
  image_url text,
  status text not null default 'draft' check (status in ('draft','published')),
  featured boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table ip_records (
  id uuid primary key default gen_random_uuid(),
  type text not null check (type in ('hki','artikel')),
  title text not null,
  reference_number text,                  -- nomor HKI atau DOI
  publisher text,
  year int,
  url text,
  document_url text,
  status text not null default 'draft' check (status in ('draft','published')),
  featured boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table mentored_projects (
  id uuid primary key default gen_random_uuid(),
  student_name text not null,
  course text,
  title text not null,
  description text,
  tech_stack text[] not null default '{}',
  project_url text,
  image_url text,
  consent boolean not null default false, -- izin tampil dari mahasiswa
  status text not null default 'draft' check (status in ('draft','published')),
  featured boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table testimonials (
  id uuid primary key default gen_random_uuid(),
  mentored_project_id uuid not null references mentored_projects(id) on delete cascade,
  author_name text,
  content text not null,
  status text not null default 'draft' check (status in ('draft','published')),
  featured boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table contact_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 100),
  email text not null check (char_length(email) between 3 and 200),
  message text not null check (char_length(message) between 1 and 2000),
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

-- Trigger updated_at untuk semua tabel yang punya kolomnya
do $$
declare t text;
begin
  foreach t in array array[
    'profile','projects','achievements','experiences','skills',
    'education','certifications','ip_records','mentored_projects','testimonials'
  ] loop
    execute format(
      'create trigger set_updated_at before update on %I
       for each row execute function set_updated_at()', t);
  end loop;
end $$;

-- Baris profile awal (singleton), isi detailnya nanti dari /admin/profile
insert into profile (full_name) values ('Nama Lengkap Kamu') on conflict (id) do nothing;
