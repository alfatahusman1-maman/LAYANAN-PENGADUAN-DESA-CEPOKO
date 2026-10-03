# Arsitektur aplikasi

## Ringkasan sistem

```text
Flutter Android / Flutter Web
        │ HTTPS (produksi) / HTTP emulator lokal
        ▼
Express API (backend/src)
        │ @neondatabase/serverless
        ▼
Neon Postgres
```

Flutter menangani splash, autentikasi demo lokal, navigasi, presentasi, validasi awal, pemilihan lampiran, dan pemanggilan API. Autentikasi demo tidak memverifikasi identitas lewat server dan tidak memberi akses ke Neon. API Node menjadi satu-satunya komponen yang membaca `DATABASE_URL`, menerapkan validasi tepercaya, mengautorisasi operasi petugas, dan mengakses Neon.

## Struktur kode

```text
lib/
├── data/complaint_api.dart  # HTTP, serialisasi JSON, penanganan API
├── data/demo_auth_service.dart # Akun demo lokal sementara; tidak untuk produksi
├── pages/                   # Layar dan state UI per alur
│   ├── auth_page.dart        # Splash, masuk, daftar, reset demo
├── widgets/ui.dart           # Komponen visual lintas halaman
├── app.dart                  # Shell, bottom navigation, rute
├── main.dart                 # Bootstrap Flutter, locale, tema Shadcn
├── models.dart               # Model response/request aplikasi
└── theme.dart                # Tema Material 3 dan token warna

backend/
├── src/index.js              # Route Express dan aturan akses
├── src/validation.js         # Skema Zod, kategori, status, batas file
├── src/db.js                 # Inisialisasi klien Neon dari environment
├── src/schema.sql             # Tabel dan indeks awal yang idempotent
└── scripts/                   # Setup DB dan E2E lokal/Neon
```

## Modul aplikasi Flutter

- `AuthGate` menampilkan splash sebelum masuk, mengelola layar masuk/daftar/reset demo, lalu mengarahkan akun warga ke `CepokoApp` dan akun petugas ke `AdminPage`.
- `DemoAuthService` menyimpan akun dan pendaftaran di memori sesi. Ini hanya demonstrasi alur: tidak ada verifikasi server, email pemulihan, atau persistensi.
- `CepokoApp` mengelola navigasi utama (beranda, pengaduan, status, FAQ, profil) dan menyediakan keluar akun.
- `ComplaintApi` membungkus HTTP, timeout, decode JSON, dan pemetaan error server.
- `models.dart` memetakan statistik, receipt, hasil pelacakan, dan record inbox.
- `pages/` mengelola state per alur: form submit, hasil lacak, profil/FAQ, dan inbox petugas.
- `widgets/ui.dart` menyediakan komponen dan label status yang konsisten.
- `theme.dart` adalah sumber warna/komponen global; jangan menetapkan ulang warna utama sembarangan di layar.

Navigasi memakai `IndexedStack` agar halaman tetap hidup ketika tab berganti. Kode pelacakan dari tanda terima diarahkan ke tab status, dan FAQ tersedia sebagai tab utama serta pintasan bantuan. Periksa implikasi lifecycle/controller ketika menambah tab atau mengubah struktur navigasi.

## API dan data

API dasar ditentukan oleh compile-time `API_BASE_URL`; default lokal Android emulator ialah `http://10.0.2.2:4173/api`. Produksi harus memakai HTTPS. API utama:

| Rute | Akses | Tujuan |
| --- | --- | --- |
| `GET /api/health` | publik | pemeriksaan kesiapan server/database |
| `GET /api/stats` | publik | hitungan ringkas dari tabel laporan |
| `POST /api/complaints` | publik | membuat laporan dan lampiran opsional |
| `GET /api/complaints/:id` | kode acak | status dan catatan publik untuk kode tersebut |
| `GET /api/admin/complaints` | kunci admin | inbox detail untuk petugas |
| `GET /api/admin/complaints/:id/attachment` | kunci admin | lampiran laporan |
| `PATCH /api/admin/complaints/:id` | kunci admin | memperbarui status/catatan |

Tabel `complaints` menyimpan UUID, identitas pelapor, RT/RW, kontak, kategori, judul/uraian, status, catatan petugas, dan lampiran BYTEA opsional. Skema sumber ada di `backend/src/schema.sql`; setup membuat tabel dan indeks yang dapat dijalankan ulang.

Kategori: `Infrastruktur`, `Keamanan`, `Administrasi`, `Layanan publik`. Status: `received`, `in_review`, `resolved`, `declined`. Lampiran dibatasi 4 MiB serta JPEG, PNG, atau PDF; server memeriksa signature konten sebelum menyimpan.

## Batas keamanan

- Pelacakan publik berdasarkan UUID tidak berarti semua kolom boleh dipublikasikan. Bentuk responsnya harus eksplisit dan minim data.
- Koneksi database dan kunci petugas tidak pernah masuk build Flutter. `backend/.env` lokal harus diabaikan Git.
- API admin sekarang menggunakan satu shared API key pada header. Ini mekanisme prototipe, bukan identitas/otorisasi individual yang memadai untuk produksi.
- Data sensitif laporan dan lampiran tersimpan langsung di Postgres. Tetapkan kebijakan retensi, backup, akses petugas, dan penghapusan sebelum layanan publik diluncurkan.
- Batasi rate, ukuran body, origin, dan akses admin ketika menyiapkan deployment. Gunakan TLS, secret manager, rotasi key, observabilitas tanpa PII, serta autentikasi petugas yang sesuai.

## Operasi dan konfigurasi

- Backend membaca `backend/.env` saat dijalankan dengan current working directory `backend/`.
- Jalankan `npm run db:setup` untuk setup awal; tangani migrasi perubahan skema secara eksplisit.
- Backend lokal default port `4173`; smoke test menjalankan instance terpisah pada port `4317`, E2E Neon pada `4318`.
- API hanya mengizinkan origin browser yang tercantum eksplisit dalam `CORS_ORIGINS` (daftar dipisahkan koma); jangan gunakan wildcard untuk deployment.
- `tool/create_icons.ps1` menghasilkan ikon web dari identitas yang ada. Flutter launcher icons dibuat melalui konfigurasi `pubspec.yaml` setelah dependensi Flutter tersedia.
- Platform native tambahan perlu dihasilkan/dirawat dengan Flutter SDK. Target utama repo saat ini Android dan Web.

## Keputusan berikutnya

1. Ganti autentikasi demo dengan penyedia identitas server, pemulihan kata sandi terverifikasi, dan otorisasi role sebelum rilis produksi.
2. Sahkan kebijakan privasi, retensi, dan SLA layanan.
3. Tentukan data/profil resmi, kontak, berita, peta, dan pemilik konten.
4. Tetapkan hosting API, domain HTTPS, observabilitas, backup, dan rencana pemulihan.
5. Siapkan CI untuk format/analyze/test Flutter, tes backend, dan build Android bertanda tangan.
