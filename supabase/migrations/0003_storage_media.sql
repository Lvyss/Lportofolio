-- 0003_storage_media.sql
-- Fase 1: bucket media (public read) + policy tulis hanya admin

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'media', 'media', true, 5242880,
  array['image/jpeg','image/png','image/webp','image/avif','application/pdf']
)
on conflict (id) do nothing;

create policy "media admin select" on storage.objects
  for select to authenticated
  using (bucket_id = 'media' and public.is_admin());

create policy "media admin insert" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'media' and public.is_admin());

create policy "media admin update" on storage.objects
  for update to authenticated
  using (bucket_id = 'media' and public.is_admin())
  with check (bucket_id = 'media' and public.is_admin());

create policy "media admin delete" on storage.objects
  for delete to authenticated
  using (bucket_id = 'media' and public.is_admin());
