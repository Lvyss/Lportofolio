# Log Fase 1: Fondasi Database dan Auth

> Tanggal mulai: 2026-10-03 | Tanggal selesai: - | Branch: feat/db-auth | Status: [x] berjalan [x] selesai

## Checklist
- [x] Tulis migrasi tabel (7.1) dan fungsi `is_admin()`
- [x] Aktifkan RLS dan buat policy setiap tabel
- [x] Buat bucket `media` beserta policy
- [x] Setup klien Supabase (browser, server, middleware)
- [x] Halaman `/admin/login` dan proteksi route `/admin/*`
- [x] Tambahkan akun admin ke tabel `admins`
- [x] Generate tipe TypeScript dari skema

## Perubahan
| Commit | Deskripsi | File utama |
|--------|-----------|------------|
| feat: tambah migrasi skema, RLS, dan storage | Tabel, is_admin(), policy, bucket media | supabase/migrations/0001-0003 |
| feat: setup klien Supabase dan login admin | Klien browser/server/proxy, login, layout terproteksi | src/lib/supabase, src/proxy.ts, src/app/admin |

## Keputusan
- ADR 003: proteksi admin berlapis (proxy + layout + RLS), signup publik dimatikan.
- Tabel `admins` ditutup total dari API (RLS tanpa policy); cek admin lewat `is_admin()`.
- Tipe TypeScript digenerate sebelum klien dibuat agar klien langsung ber-tipe.

## Kendala dan solusi
-

## Verifikasi "Selesai jika"
- [x] Login admin berhasil
- [x] Akses `/admin` tanpa login diarahkan ke `/admin/login`
- [x] INSERT ke `projects` memakai anon key ditolak RLS
- [x] Tabel `admins` tidak bisa dibaca lewat API
- [x] Signup publik dimatikan di Supabase Auth
- [x] `npm run lint` dan `npm run build` lolos

## Catatan untuk fase berikutnya
- Fase 2 dari branch `feat/admin-panel`; mulai dari komponen reusable (DataTable, FormField, ImageUploader, ConfirmDialog, StatusBadge) lalu modul Profile dan Projects dulu.
- Kalau skema berubah, buat migrasi baru (jangan edit 0001-0003) dan generate ulang tipe.
