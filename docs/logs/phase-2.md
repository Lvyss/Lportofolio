# Log Fase 2: Admin Panel (inti CRUD)

> Tanggal mulai: 2026-10-03 | Tanggal selesai: - | Branch: feat/admin-panel | Status: [x] berjalan [ ] selesai

## Checklist
- [~] Layout admin (sidebar, header, logout)
- [~] Komponen reusable: StatusBadge, FormField, ConfirmDialog (selesai); DataTable, ImageUploader (belum)
- [ ] CRUD Profile (singleton)
- [ ] CRUD Projects
- [ ] CRUD Achievements
- [ ] CRUD Experiences
- [ ] CRUD Skills
- [ ] CRUD Education + Certifications
- [ ] CRUD IP Records
- [ ] CRUD Mentored Projects + Testimonials
- [ ] Reorder (sort_order) dan toggle draft/published/featured
- [ ] Dashboard ringkasan

## Perubahan
| Commit | Deskripsi | File utama |
|--------|-----------|------------|
| feat: layout admin dan komponen dasar | Sidebar, StatusBadge, FormField, ConfirmDialog, helper cn | src/components/admin, src/lib/utils.ts |

## Keputusan
- Menu sidebar hanya berisi halaman yang sudah ada (src/components/admin/nav.ts), ditambah per modul.
- ConfirmDialog memakai elemen `<dialog>` native, tanpa dependensi tambahan.

## Kendala dan solusi
-

## Verifikasi "Selesai jika: semua modul bisa ditambah, diubah, dihapus, dan diurutkan"
- [ ] (diisi bertahap per modul)

## Catatan untuk bagian berikutnya
- Bagian 2: DataTable dan ImageUploader (batas 2 MB gambar, 5 MB dokumen, path `{modul}/{id}/{timestamp}-{nama-file}`).
- Bagian 3: CRUD Profile, lalu Projects.
