# Strategi konten aplikasi

Copy disusun untuk aplikasi Flutter Kelurahan Cepoko, Kecamatan Gunungpati, Kota Semarang. Alamat dan koordinat kantor di UI mencantumkan sumber GIS Pemkot dengan tahun data 2021; data lain yang belum diverifikasi tetap menjadi keadaan kosong.

## Autentikasi prototipe

- Splash: **Lapor Cepoko** — **Layanan warga Kelurahan Cepoko**.
- Masuk: **Selamat datang** — **Masuk untuk menyampaikan laporan dan memantau perkembangannya.** Formulir tidak mengungkap peran akun; akun warga masuk ke layanan warga dan akun petugas menuju gerbang panel petugas.
- Daftar: **Buat akun warga** — akun demo hanya tersimpan selama aplikasi berjalan.
- Pemulihan: **Atur ulang kata sandi** — layar menjelaskan bahwa perubahan ini hanya berlaku lokal untuk sesi demo; tidak ada surel reset.
- Jangan mencantumkan kredensial contoh pada UI. Kredensial demo khusus prototipe disimpan di README proyek dan tidak boleh dianggap sebagai akun resmi.

## Beranda

**Judul:** Ada yang perlu disampaikan?  
**Deskripsi:** Sampaikan kondisi di lingkungan Anda. Petugas kelurahan dapat meninjau laporan dan mencatat perkembangannya di sini.  
**CTA utama:** Buat pengaduan  
**CTA pendamping:** Lacak laporan  
**Kepercayaan:** Kode pelacakan membantu Anda memeriksa perkembangan laporan.

Statistik berlabel **Laporan diterima**, **Sedang ditinjau**, dan **Selesai**. Nilai berasal dari endpoint statistik. Hindari angka statis. Alur empat langkah: tulis laporan, tambahkan bukti bila ada, simpan kode, periksa pembaruan.

Jika kabar kelurahan belum tersedia, tampilkan keadaan kosong seperti **Informasi akan ditampilkan setelah diumumkan oleh sumber pemerintah.** Jangan membuat berita contoh seolah-olah nyata.

## Buat laporan

**Judul:** Ceritakan apa yang terjadi.  
**Deskripsi:** Jelaskan masalah dan lokasi dengan singkat. Petugas kelurahan akan meninjau laporan yang masuk.  
**Petunjuk:** Sertakan RT/RW atau patokan lokasi, waktu kejadian bila diketahui, dan dampak yang terlihat. Jangan menyertakan data sensitif milik orang lain.

Kolom: nama pelapor; RT/RW; kontak untuk tindak lanjut (opsional); kategori; judul; uraian dan lokasi; foto/dokumen (opsional); persetujuan penanganan data sesuai kebijakan yang disahkan.

Kategori yang dipakai API saat ini: Infrastruktur, Keamanan, Administrasi, dan Layanan publik. Lampiran: JPG, PNG, PDF hingga 4 MB. Pesan sesudah submit memberi tahu warga untuk menyimpan kode pelacakan.

## Status / inbox warga

**Judul:** Status laporan Anda.  
**Deskripsi:** Masukkan kode pelacakan yang diberikan setelah laporan dikirim.  
**Aksi:** Cari laporan.

Tab Status berfungsi sebagai inbox privat untuk pencarian berdasarkan kode; jangan menampilkan daftar laporan warga lain.

Terjemahan status: `received` → **Diterima**; `in_review` → **Sedang ditinjau**; `resolved` → **Selesai**; `declined` → **Perlu informasi**. Jika butuh informasi tambahan, tampilkan catatan petugas yang aman dipublikasikan dan arahan tindak lanjut. Jangan menjanjikan lama tanggapan sampai SLA disahkan.

## FAQ

### Apakah nama saya ditampilkan saat melacak laporan?

Tidak. Halaman pelacakan menampilkan informasi minimum tentang status laporan. Identitas pelapor tersedia bagi petugas yang berwenang menangani laporan.

### Kapan laporan akan ditanggapi?

Petugas meninjau laporan sesuai alur layanan yang berlaku. Simpan kode pelacakan untuk melihat perubahan status. Waktu tanggapan resmi akan dicantumkan setelah standar layanan ditetapkan.

### Format bukti apa yang dapat dikirim?

Anda dapat melampirkan JPG, PNG, atau PDF hingga 4 MB. Lampiran bersifat opsional; uraikan lokasi dan masalah dengan jelas jika tidak memiliki bukti.

### Informasi apa yang sebaiknya dicantumkan?

Tuliskan kejadian, lokasi atau patokan, RT/RW, dan waktu bila diketahui. Hindari kata sandi, nomor identitas, atau informasi sensitif orang lain.

### Saya kehilangan kode pelacakan. Apa yang harus dilakukan?

Simpan kode setelah laporan berhasil dikirim. Jika kode hilang, hubungi kantor kelurahan setelah kontak terbaru tersedia. Jangan kirim data pribadi ke nomor yang tidak tercantum di kanal layanan yang terverifikasi.

## Profil kelurahan

Gunakan visi/misi, struktur perangkat, jam operasional, dan kontak hanya dari sumber Kelurahan/Pemkot yang dapat diverifikasi. GIS Kota Semarang mencantumkan alamat dan koordinat kantor dengan tahun data 2021; tampilkan tahun tersebut dan minta pembaruan sebelum menggantinya dengan data baru. Untuk konten yang belum tersedia, tampilkan label **Informasi sedang disiapkan oleh kelurahan** alih-alih menampilkan tebakan. Belum ada foto kelurahan yang digunakan; ikon aplikasi adalah ilustrasi buatan.

## Konten admin dan error

- **Sedang memuat:** Memuat laporan…
- **Jaringan gagal:** Layanan belum dapat dihubungi. Periksa koneksi lalu coba lagi.
- **Laporan tidak ditemukan:** Periksa kembali kode pelacakan yang Anda masukkan.
- **Laporan terkirim:** Laporan diterima. Simpan kode ini untuk melihat perkembangannya.
- **Lampiran tidak didukung:** Pilih JPG, PNG, atau PDF dengan ukuran maksimal 4 MB.
- **Kode admin salah/tidak berwenang:** Akses petugas tidak dapat diverifikasi. Hubungi pengelola layanan.

Jangan menyertakan stack trace, SQL, kredensial, alamat internal, atau data pelapor pada pesan yang ditampilkan kepada warga.
