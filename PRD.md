# PRD — Layanan Warga Kelurahan Cepoko

**Status:** MVP prototipe dengan autentikasi demo sementara  
**Platform:** Android (Flutter); Flutter Web merupakan target sekunder setelah kebijakan CORS disiapkan  
**Bahasa antarmuka:** Indonesia

## Ringkasan

Layanan Warga Kelurahan Cepoko menyediakan kanal digital yang mudah dipakai untuk mengirim pengaduan, melampirkan bukti, memperoleh kode pelacakan, dan membaca perkembangan yang dicatat petugas. Aplikasi juga menyajikan ringkasan layanan dan informasi profil kelurahan setelah data resmi diverifikasi.

## Masalah dan tujuan

Warga memerlukan satu jalur yang jelas untuk menyampaikan masalah lingkungan dan mengetahui apakah laporan telah diterima serta ditinjau. Petugas memerlukan daftar laporan terstruktur, lampiran yang dapat diperiksa, dan cara mencatat tindak lanjut.

Tujuan MVP:

1. Warga dapat mengirim laporan dengan kategori, wilayah RT/RW, uraian, kontak opsional, dan lampiran pendukung.
2. Setiap laporan memperoleh UUID yang dapat dipakai untuk melacak status tanpa membuka identitas pelapor kepada publik.
3. Petugas dapat meninjau laporan dan mencatat status serta catatan perkembangan.
4. Beranda menampilkan statistik aktual dan menjelaskan alur layanan dengan bahasa yang tidak menjanjikan SLA yang belum disahkan.
5. Profil, kontak, peta, dan struktur perangkat kelurahan tidak menampilkan fakta yang belum diverifikasi.

## Pengguna

- **Warga/pelapor:** membutuhkan formulir sederhana, panduan privasi, dan cara mengecek laporan.
- **Petugas kelurahan:** membutuhkan inbox laporan, lampiran, kategori, waktu masuk, dan pencatatan tindak lanjut.
- **Pengelola layanan:** memelihara konten resmi, akses petugas, database, serta endpoint API.

## Ruang lingkup MVP

### Warga

- Beranda dengan CTA laporan, angka laporan diterima/diproses/selesai dari API, dan alur empat langkah.
- Form laporan: nama, RT/RW, kontak opsional, kategori, judul, uraian/lokasi, persetujuan privasi, dan lampiran opsional JPG/PNG/PDF maksimal 4 MiB.
- Kode laporan setelah pengiriman berhasil; layar pelacakan menunjukkan status dan catatan admin yang aman untuk dipublikasikan.
- Profil kelurahan dengan data sumber/tahun, FAQ, serta alur status.

### Petugas

- Inbox laporan terproteksi, akses lampiran, perubahan status, dan catatan admin.
- Gerbang splash dan login bersama yang mengarahkan akun demo warga ke aplikasi warga dan akun demo petugas ke panel petugas.
- Layar daftar serta atur ulang kata sandi warga sebagai demonstrasi alur. Akun demo dan pendaftaran hanya berada di memori aplikasi.
- Status yang tersedia: `received`, `in_review`, `resolved`, `declined`.
- Catatan yang dipublikasikan pada halaman pelacakan harus ditulis dengan mempertimbangkan privasi.

## Di luar ruang lingkup MVP

- Janji waktu tanggapan (SLA) sebelum standar layanan disahkan.
- Pesan push, SMS, WhatsApp, autentikasi produksi, dan sinkronisasi offline.
- Pemetaan batas wilayah tanpa sumber administrasi resmi.
- Analitik pelapor lintas laporan atau profil publik warga.
- Google Sites/Google Forms sebagai implementasi aplikasi utama.

## Alur utama

1. Warga membaca petunjuk, memilih kategori, dan melengkapi laporan.
2. API memvalidasi teks dan memeriksa format/magic byte lampiran.
3. Backend menyimpan laporan di Neon dan mengembalikan kode pelacakan.
4. Warga menyimpan kode lalu memeriksa status kapan saja.
5. Petugas membuka inbox, membaca bukti, mengubah status, dan menambahkan catatan.
6. Endpoint pelacakan mengembalikan kode, kategori, judul, status, tanggal, dan catatan publik; endpoint ini tidak boleh mengembalikan nama, kontak, RT/RW, uraian lengkap, atau lampiran.

## Kebutuhan nonfungsional

- Antarmuka responsif, mudah dibaca, memakai label formulir eksplisit, dan dapat digunakan dengan ukuran teks sistem.
- Validasi dilakukan di aplikasi untuk umpan balik cepat serta di server sebagai batas kepercayaan utama.
- Maksimal ukuran lampiran 4 MiB; tipe dibatasi ke JPEG, PNG, dan PDF dan diverifikasi berdasarkan konten.
- Semua akses database dilakukan oleh backend. Rilis produksi menggunakan HTTPS.
- Error jaringan, status kosong, pemuatan, sukses, dan validasi harus ditangani secara jelas.
- Jangan mencatat kredensial, data pelapor, atau isi lampiran pada log publik.

## Kriteria penerimaan

- Laporan valid tersimpan dan menerima kode yang dapat dilacak.
- Input tidak valid dan lampiran yang tidak didukung ditolak tanpa menulis ke database.
- Endpoint publik tidak membocorkan identitas atau detail pribadi.
- Tanpa kunci admin, endpoint petugas menolak permintaan; dengan kunci yang benar, petugas dapat melihat inbox dan memperbarui status.
- Statistik menunjukkan hitungan berdasarkan status database.
- Kegagalan jaringan, lampiran, atau server menampilkan tindakan pemulihan yang dapat dipahami.
- Semua informasi profil resmi memakai sumber yang disetujui; konten belum tersedia memakai placeholder.
- Flutter analyze, Flutter test, uji backend, uji E2E, dan build Android release lulus sebelum rilis.

## Risiko dan keputusan terbuka

- **Autentikasi admin:** implementasi saat ini memakai kunci API bersama yang dimasukkan ke layar admin. Ini cocok untuk prototipe terbatas, tetapi bukan autentikasi identitas petugas untuk layanan produksi. Sebelum rilis publik, ganti dengan identitas petugas dan otorisasi terkelola, rotasi kunci, pembatasan akses, dan audit perubahan.
- **Autentikasi demo:** login, pendaftaran, dan atur ulang kata sandi pada build prototipe berjalan lokal di memori; tidak mengirim email, tidak menyimpan sesi/akun ke server, dan bukan kontrol akses produksi. Panel admin tetap memerlukan kunci API server.
- **Retensi data:** tetapkan durasi penyimpanan laporan/lampiran, prosedur penghapusan, dan pejabat yang bertanggung jawab.
- **Privasi:** sahkan teks persetujuan dan kebijakan akses terhadap laporan sebelum penerapan.
- **Data kelurahan:** kumpulkan dan sahkan kontak, jam layanan, visi/misi, struktur perangkat, lokasi, dan batas wilayah.
- **Sumber data Kelurahan Cepoko:** identitas wilayah diverifikasi pada [GIS Kota Semarang](https://dataspasial.semarangkota.go.id/detail_kantor/61) dan pemberitaan verifikasi Pemkot 2025 ([Diskominfo Kota Semarang](https://diskominfo.semarangkota.go.id/berita/verifikasi-kinerja-kelurahan-cepoko-oleh-tim-pemerintah-kota-semarang)). Alamat dan koordinat di GIS tersebut diberi tahun data 2021; jangan sajikan seolah-olah data 2026 atau gunakan nomor/kontak lama tanpa pembaruan.
- **Foto/visual:** belum ada foto Kelurahan Cepoko dalam aset aplikasi. GIS Pemkot mencantumkan foto kantor, tetapi foto tersebut belum dipakai karena perlu pemeriksaan visual terbaru dan izin penggunaan. Ikon rumah di `assets/branding/` adalah ilustrasi identitas buatan, bukan dokumentasi lokasi.
- **Rilis:** tetapkan URL API produksi, signing key privat, pemilik akun Play, dan proses pembaruan.
