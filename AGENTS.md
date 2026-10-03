# Panduan kerja agent

Instruksi ini berlaku untuk setiap perubahan di repositori Layanan Warga Kelurahan Cepoko, Kecamatan Gunungpati, Kota Semarang.

## Arah proyek

- Aplikasi warga ditulis dalam Flutter/Dart. Gunakan struktur Flutter di root: `lib/`, `test/`, `assets/`, `android/`, dan `web/`.
- Backend Node.js di `backend/` hanya untuk API dan akses Neon. Jangan menambahkan React, Vite, Capacitor, atau antarmuka JavaScript.
- Jangan menghubungkan aplikasi langsung ke Neon dan jangan menaruh URL/kredensial database atau kunci admin di Dart, aset, log, fixture, dokumentasi publik, maupun argumen rilis yang dapat dipaketkan.
- Baca [PRD](PRD.md), [arsitektur](docs/ARCHITECTURE.md), [design system](docs/DESIGN-SYSTEM.md), serta [strategi konten](docs/CONTENT-STRATEGY.md) sebelum mengubah alur terkait.

## Aturan implementasi

- Letakkan layar di `lib/pages/`, akses API di `lib/data/`, model di `lib/models.dart` (atau modul model terpisah bila tumbuh), dan komponen yang dipakai ulang di `lib/widgets/`.
- Pisahkan presentasi dari akses jaringan. Parse respons melalui model, tampilkan status loading/error/empty/success, dan selalu validasi ulang input di backend.
- Pertahankan status API: `received`, `in_review`, `resolved`, `declined`. Hindari mengganti kontrak tanpa memperbarui klien, skema, tes, dan dokumen secara bersamaan.
- Endpoint publik pelacakan tidak boleh mengirim identitas, RT/RW, kontak, uraian lengkap, atau konten lampiran.
- Kunci admin bersama saat ini hanya untuk prototipe terbatas. Jangan menyebutnya autentikasi produksi atau menambah penyimpanan permanen kunci tanpa persetujuan desain keamanan.
- Jangan mengarang nama pejabat, statistik, kontak, jadwal, visi/misi, koordinat, berita, atau janji waktu tanggapan. Data alamat/koordinat kantor yang bersumber dari GIS Kota Semarang mencatat tahun 2021, jadi pertahankan label sumber dan tahunnya.
- Jangan menggunakan foto desa/kelurahan kecuali sumber, lokasi, tanggal yang relevan, serta hak penggunaan sudah jelas. Ikon rumah yang ada adalah ilustrasi, bukan foto kantor.
- Gunakan palet `CepokoColors`, ikon Lucide yang relevan, label Indonesia, dan hindari emoji sebagai ikon UI.
- Jaga aksesibilitas: label form jelas, target sentuh memadai, kontras cukup, dan kesalahan tidak hanya ditandai dengan warna.

## Rahasia dan data

- `backend/.env` bersifat rahasia dan harus tetap diabaikan Git. Gunakan `backend/.env.example` hanya dengan nilai kosong/contoh yang tidak dapat dipakai.
- Hindari menampilkan atau menyalin isi environment, database URL, API key, lampiran, atau data warga ke output terminal dan dokumentasi.
- Uji integrasi Neon membuat data sementara. Pastikan cleanup di blok `finally` tetap berjalan dan laporkan bila cleanup gagal.
- Perubahan skema memerlukan pemeriksaan dampak terhadap database yang sudah terisi dan prosedur migrasi yang dapat diulang.

## Validasi perubahan

- Untuk backend, jalankan dari `backend/`: `npm test` dan `npm run test:e2e`; jalankan `npm run test:e2e:neon` hanya ketika akses jaringan dan database tersedia serta cleanup terjamin.
- Untuk Flutter, jalankan dari root: `dart format --set-exit-if-changed lib test`, `flutter analyze`, dan `flutter test`.
- Untuk perubahan Android, uji build APK release dengan URL API non-rahasia. Jangan menyatakan build, uji perangkat, atau rilis berhasil jika alat yang diperlukan tidak tersedia.
- Jangan menambahkan dependensi tanpa alasan; jangan menghapus dependensi yang dipakai backend/API.
- Sesuaikan README dan dokumen terkait ketika arsitektur, konfigurasi, kontrak API, alur pengguna, atau perintah berubah.

## Pelaporan

Jelaskan perubahan, verifikasi yang benar-benar dijalankan, dan batasan yang masih ada. Bedakan jelas hasil pemeriksaan backend dari hasil build/test Flutter dan Android.
