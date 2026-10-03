-- 0002_rls_policies.sql
-- Fase 1: RLS di semua tabel + grant eksplisit

-- admins: RLS aktif tanpa policy = tidak bisa diakses lewat API sama sekali.
-- Cek admin hanya lewat fungsi is_admin() (security definer).
alter table admins enable row level security;
revoke all on admins from anon, authenticated;

-- Tabel konten standar: pengunjung baca published, admin akses penuh
do $$
declare t text;
begin
  foreach t in array array[
    'projects','achievements','experiences','skills',
    'education','certifications','ip_records'
  ] loop
    execute format('alter table %I enable row level security', t);
    execute format('create policy "public read published" on %I for select using (status = ''published'')', t);
    execute format('create policy "admin full access" on %I for all using (is_admin()) with check (is_admin())', t);
  end loop;
end $$;

-- profile: seluruh isi memang publik, tulis hanya admin
alter table profile enable row level security;
create policy "public read" on profile for select using (true);
create policy "admin full access" on profile for all using (is_admin()) with check (is_admin());

-- mentored_projects: wajib published DAN ada izin tampil
alter table mentored_projects enable row level security;
create policy "public read published with consent" on mentored_projects
  for select using (status = 'published' and consent = true);
create policy "admin full access" on mentored_projects
  for all using (is_admin()) with check (is_admin());

-- testimonials: hanya tampil kalau project induknya published + consent
alter table testimonials enable row level security;
create policy "public read published with consent" on testimonials
  for select using (
    status = 'published' and exists (
      select 1 from mentored_projects m
      where m.id = testimonials.mentored_project_id
        and m.status = 'published' and m.consent = true
    )
  );
create policy "admin full access" on testimonials
  for all using (is_admin()) with check (is_admin());

-- contact_messages: pengunjung hanya boleh INSERT, admin yang baca/ubah/hapus
alter table contact_messages enable row level security;
create policy "anyone can send message" on contact_messages
  for insert to anon, authenticated with check (is_read = false);
create policy "admin full access" on contact_messages
  for all using (is_admin()) with check (is_admin());

-- Grant eksplisit (RLS tetap jadi penjaga utama)
grant usage on schema public to anon, authenticated;

grant select on profile, projects, achievements, experiences, skills,
  education, certifications, ip_records, mentored_projects, testimonials to anon;

grant select, insert, update, delete on profile, projects, achievements,
  experiences, skills, education, certifications, ip_records,
  mentored_projects, testimonials, contact_messages to authenticated;

grant insert on contact_messages to anon;
grant execute on function is_admin() to anon, authenticated;
