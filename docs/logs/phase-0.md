# Log Fase 0: Persiapan

> Tanggal mulai: 2026-10-03 | Tanggal selesai: - | Branch: main, dev | Status: [] berjalan [x] selesai

## Checklist

- [ ] Buat repo GitHub dan branch `main` + `dev`
- [ ] Inisialisasi Next.js + TypeScript + Tailwind + ESLint
- [ ] Buat project Supabase, simpan kredensial di `.env.local`
- [ ] Buat `.env.example`, pastikan `.env.local` ada di `.gitignore`
- [ ] Hubungkan repo ke Vercel (preview deployment aktif)

## Perubahan

| Commit              | Deskripsi                        | File utama                   |
| ------------------- | -------------------------------- | ---------------------------- |
| chore: init project | Scaffold Next.js + struktur docs | package.json, src/app, docs/ |

## Keputusan

- ADR 001 dan 002 sudah tercatat di PROJECT.md bagian 16.

## Kendala dan solusi

- `.env.example` ikut ke-ignore oleh `.env*` bawaan Next.js, ditambah `!.env.example` di `.gitignore`.
- Heredoc Bash tidak jalan di PowerShell, diganti here-string `@' '@`.

## Verifikasi "Selesai jika: halaman kosong ter-deploy ke Vercel"

- [x] `npm run lint` dan `npm run build` lolos
- [x] `.env.local` tidak ikut ter-commit
- [x] URL production Vercel tampil: https://ekanandasusila.vercel.app
- [x] Push ke `dev` menghasilkan preview deployment

## Catatan untuk fase berikutnya

- Fase 1 mulai dari branch `feat/db-auth` (cabang dari `dev`).
