# ADR 003: Proteksi admin berlapis dan signup dimatikan

- Tanggal: 2026-10-03
- Status: Diterima

## Konteks
Situs hanya punya satu admin. Siapa pun yang punya akun Supabase Auth tidak boleh otomatis dianggap admin.

## Keputusan
1. Signup publik dimatikan di Supabase Auth.
2. Admin ditentukan oleh keberadaan `user_id` di tabel `admins`, dicek lewat `is_admin()`.
3. Tiga lapis penjaga: proxy/middleware (redirect), layout `(protected)` (cek ulang di server), dan RLS di database (penjaga terakhir).
4. Server memakai `getUser()`, bukan `getSession()`, karena `getUser()` memverifikasi token.

## Konsekuensi
Satu query tambahan (`is_admin()`) tiap request ke `/admin/*`. Untuk satu admin, dampaknya kecil.
