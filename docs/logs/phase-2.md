# Log Fase 2: Admin Panel (inti CRUD)

> Tanggal mulai: 2026-10-03 | Tanggal selesai: - | Branch: feat/admin-panel | Status: [x] berjalan [ ] selesai

## Checklist

- [~] Layout admin (sidebar, header, logout)
  - [x] Komponen reusable: DataTable, FormField, ImageUploader, ConfirmDialog, StatusBadge
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

| Commit                                   | Deskripsi                                                              | File utama                                              |
| ---------------------------------------- | ---------------------------------------------------------------------- | ------------------------------------------------------- |
| feat: layout admin dan komponen dasar    | Sidebar, StatusBadge, FormField, ConfirmDialog, helper cn              | src/components/admin, src/lib/utils.ts                  |
| feat: tambah DataTable dan ImageUploader | Tabel generik dan uploader ke bucket media dengan validasi tipe/ukuran | src/components/admin/data-table.tsx, image-uploader.tsx |

## Keputusan

- Menu sidebar hanya berisi halaman yang sudah ada (src/components/admin/nav.ts), ditambah per modul.
- ConfirmDialog memakai elemen `<dialog>` native, tanpa dependensi tambahan.
   - ImageUploader upload langsung dari browser (policy storage admin), menyimpan URL publik di input hidden. Tombol hapus hanya mengosongkan field, file yatim dibersihkan nanti di /admin/media.

## Kendala dan solusi

-

## Verifikasi "Selesai jika: semua modul bisa ditambah, diubah, dihapus, dan diurutkan"

- [ ] (diisi bertahap per modul)

## Catatan untuk bagian berikutnya

- Bagian 2: DataTable dan ImageUploader (batas 2 MB gambar, 5 MB dokumen, path `{modul}/{id}/{timestamp}-{nama-file}`).
   - Bagian 3: CRUD Profile (singleton), lalu Projects. Form untuk record baru membuat UUID di awal (crypto.randomUUID) dan memakainya sebagai id insert sekaligus bagian path upload.