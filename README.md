# Layanan Warga Kelurahan Cepoko

Aplikasi resmi pelayanan aspirasi dan pengaduan warga berbasis Flutter/Dart untuk Kelurahan Cepoko, Kecamatan Gunungpati, Kota Semarang. Warga dapat menyampaikan laporan fasilitas atau pelayanan publik, melampirkan bukti foto/dokumen, memantau riwayat tindak lanjut, dan meneruskan konfirmasi resmi melalui Gateway WhatsApp Kelurahan.

Seluruh data tersimpan secara persisten melalui API Node.js di `backend/` yang terhubung ke basis data Neon Postgres. Kredensial database dan kunci server dilindungi penuh di sisi backend dan tidak ditanam ke aplikasi klien Flutter maupun berkas paket APK.

---

## Daftar Dokumen Proyek

- [PRD](PRD.md) — tujuan produk, profil pengguna, batasan teknis, dan kriteria penerimaan.
- [Arsitektur](docs/ARCHITECTURE.md) — batas keamanan, alur data, rancangan API, dan koneksi Neon.
- [Design system](docs/DESIGN-SYSTEM.md) — token warna `CepokoColors`, tipografi, elevasi bayangan, dan aturan UI responsif.
- [Strategi konten](docs/CONTENT-STRATEGY.md) — pedoman penulisan, keterbukaan informasi, status laporan, dan kepatuhan privasi (UU PDP).
- [Pemetaan referensi UI/UX](docs/UIUX-IMPLEMENTATION.md) — implementasi visual berstandar tinggi dari acuan rancangan antarmuka.
- [Panduan agent](AGENTS.md) — standar operasional dan larangan data fiktif dalam repositori.

---

## Struktur Repositori

```text
.
├── android/                  # Konfigurasi native Android & Gradle wrapper
├── assets/branding/          # Ikon launcher, lambang, dan aset visual
├── backend/
│   ├── src/                  # Server Express, validasi input, handler Neon, skema tabel
│   ├── scripts/              # Inisialisasi basis data dan uji E2E backend
│   └── .env.example          # Template konfigurasi tanpa rahasia
├── docs/                     # Dokumentasi arsitektur, desain, konten, dan audit
├── lib/
│   ├── data/                 # Klien HTTP API (`complaint_api.dart`) & auth demo lokal (`demo_auth_service.dart`)
│   ├── pages/                # Layar utama: auth, beranda, formulir laporan, status/inbox, FAQ, profil, admin
│   ├── widgets/              # Komponen terkurasi (`ui.dart`)
│   ├── app.dart              # Shell navigasi & bottom navigation bar
│   ├── main.dart             # Bootstrap aplikasi Flutter
│   ├── models.dart           # Model data, parsing JSON, dan sanitasi respons
│   └── theme.dart            # Tema visual resmi Kelurahan Cepoko
├── test/                     # Uji unit & widget Flutter
├── tool/                     # Generator ikon dan utilitas otomatisasi
├── web/                      # Konfigurasi Flutter Web, favicon, manifest
├── AGENTS.md
├── PRD.md
├── analysis_options.yaml
└── pubspec.yaml
```

---

## Akun Demo & Uji Coba (Dummy Credentials)

Untuk keperluan pengujian antarmuka dan verifikasi fungsi sebelum integrasi penuh dengan penyedia identitas tunggal (*Single Sign-On / Disdukcapil*), aplikasi dilengkapi dengan simulasi akun demo di memori lokal:

| Peran | Email / NIK | Kata Sandi | Lingkup Hak Akses |
| :--- | :--- | :--- | :--- |
| **Warga Demo** | `warga@cepoko.test` | `CepokoWarga2026!` | Mengakses Beranda, membuat pengaduan, melampirkan berkas, melihat inbox/riwayat laporan, dan membuka profil RT/RW. |
| **Petugas Kelurahan** | `petugas@cepoko.test` | `CepokoAdmin2026!` | Masuk ke Panel Petugas Kelurahan untuk melihat antrean pengaduan seluruh warga dan memperbarui status penanganan. |

> [!NOTE]
> **Akses Panel Petugas Kelurahan**:
> Untuk memuat daftar laporan atau memperbarui status laporan dari basis data Neon, panel petugas mewajibkan pengisian **Kunci Admin Server**:
> - **Kunci Admin Pengujian / Prototipe**: `TJiUNoA7pTQXeiQZ3uqoCod31iGGdiJa5b`
> 
> *Pastikan nilai kunci ini juga disesuaikan pada variabel `ADMIN_API_KEY` di berkas `backend/.env` lokal saat menjalankan server API.*

---

## Fitur Unggulan & Implementasi UI/UX

1. **Autentikasi & Registrasi Multi-Step**:
   - Pemilihan peran ramah pengguna (*Tab Warga Cepoko* vs *Petugas Kelurahan*).
   - Registrasi berjenjang 3 langkah (*1. Data Akun ➔ 2. Verifikasi ➔ 3. Selesai*) dengan validasi NIK 16 digit dan pilihan domisili RT 01–08 / RW 01–04.
   - Dialog verifikasi OTP / PIN 4 digit dengan penghitung mundur kirim ulang.
   - Opsi pengingat login (*Ingat Saya*) dan alur pemulihan kata sandi.

2. **Beranda & Rekapitulasi Data Terverifikasi**:
   - Penanda tanggal otomatis berbahasa Indonesia (`Senin, 2 Maret 2026`).
   - Sapaan personal warga dan lencana wilayah RT/RW.
   - Rekap statistik dinamis (*Total Laporan*, *Sedang Diproses*, *Selesai*) yang bersumber langsung dari agregasi database Neon.
   - Panduan alur 4 tahap penanganan aduan masyarakat.

3. **Formulir Pengaduan & Perlindungan Privasi (UU PDP)**:
   - Pilihan kategori aduan cepat menggunakan chip ikon (*Infrastruktur*, *Ketertiban*, *Administrasi*, *Lingkungan*).
   - Pembatasan uraian dengan penghitung karakter langsung (maksimal 1.500 karakter).
   - Pemilih lampiran multi-berkas (JPG, PNG, PDF; batas 4 MB) dengan kartu pratinjau dan aksi hapus.
   - Opsi **Laporkan Secara Anonim** untuk melindungi identitas pelapor dari publik.
   - Bukti tanda terima digital lengkap dengan **Kode Pelacakan UUID**, tombol salin, dan opsi tindak lanjut.

4. **Gateway WhatsApp Resmi Kelurahan**:
   - Fitur konfirmasi dan penerusan laporan langsung ke format pesan WhatsApp terstandarisasi.
   - Menyusun ringkasan tiket otomatis (*ID Laporan, Kategori, Judul, Wilayah, dan Waktu Kirim*).
   - Menggunakan mekanisme templat aman tanpa menanam nomor kontak pribadi yang belum terverifikasi secara statis di kode klien. Nomor WhatsApp resmi kelurahan dapat dikonfigurasikan melalui server atau parameter build `--dart-define=WA_GATEWAY_NUMBER=...`.

5. **Pelacakan Status & Transparansi**:
   - Pencarian berbasis kode tiket dengan filter tahapan (*Semua*, *Diproses*, *Selesai*).
   - Indikator progres horizontal bertingkat (*Diterima ➔ Diverifikasi ➔ Diproses ➔ Selesai*).
   - Kotak catatan resmi dari petugas kelurahan yang menerangkan tindakan konkret di lapangan.

---

## Kebijakan Kualitas Konten (Anti-AI Slop)

Sesuai ketentuan ketat pada [AGENTS.md](AGENTS.md):
- **Bebas dari Teks Artifisial / AI Buzzwords**: Tidak ada teks pengisi generik seperti *"solusi mutakhir abad 21"*, *"revolusi digital tak terbatas"*, atau frasa pemasaran kosong.
- **Faktual & Berdasar Data Nyata**: Koordinat dan alamat kantor kelurahan mengacu pada data resmi GIS Pemerintah Kota Semarang (tahun pencatatan 2021).
- **Tidak Mengarang Data**: Nama pejabat struktural, visi/misi resmi, nomor kontak publik, dan jadwal layanan hanya dicantumkan setelah dokumen resmi terbit dari Pemerintah Kota Semarang.
- **Transparansi Status**: Indikator nol pada statistik berasal dari perhitungan data riil di database Neon, bukan angka rekayasa antarmuka.

---

## Panduan Menjalankan Sistem

### 1. Menyiapkan Backend (Node.js & Neon Postgres)

Pastikan Node.js 20+ dan npm telah terpasang.

```powershell
# Masuk ke direktori backend
Set-Location backend

# Salin konfigurasi environment
Copy-Item .env.example .env

# Pasang dependensi
npm install

# Siapkan skema basis data di Neon Postgres
npm run db:setup

# Jalankan server API lokal (port 4173)
npm run api:dev
```

### 2. Menjalankan Aplikasi Flutter

Pastikan Flutter SDK (3.8+) dan Android SDK / Chrome telah siap.

```powershell
# Pasang dependensi Flutter
flutter pub get

# Jalankan pengujian otomatis Flutter
flutter test

# Jalankan pada Android Emulator (mengarah ke API lokal)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4173/api

# Jalankan pada Flutter Web lokal via Chrome
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:4173/api

# Atau cukup jalankan skrip otomatis di Windows
.\run.bat
```

---

## Pengujian dan Kualitas Kode

Jalankan perintah verifikasi mutu sebelum melakukan rilis:

```powershell
# Pemeriksaan format kode Dart
dart format --set-exit-if-changed lib test

# Analisis statis linter Flutter
flutter analyze

# Uji end-to-end backend
cd backend
npm test
npm run test:e2e
```
