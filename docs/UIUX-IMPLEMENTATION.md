# Penerapan referensi UI/UX

## Sumber referensi

Mockup ada di `UIUX app/` dan menampilkan splash, login, dashboard warga, form laporan, status/inbox, serta beberapa variasi logo dan profil. Implementasi memakai bahasa visual utamanya: hijau pekat untuk aksi utama, permukaan hangat, aksen tan, kartu ringkasan, pilihan kategori yang jelas, langkah pelaporan, progress status, dan navigasi bawah.

## Pemetaan ke aplikasi

| Referensi | Penerapan |
| --- | --- |
| Dashboard warga | Beranda mengambil statistik langsung dari API, CTA untuk membuat laporan, ringkasan empat langkah, dan bantuan FAQ. |
| Form laporan | Input nama, RT/RW, kontak opsional, kategori, judul, uraian, bukti JPG/PNG/PDF, persetujuan privasi, dan tanda terima berkode. Kategori memakai empat kartu pilihan. |
| Inbox/status | Tab Status meminta kode pelacakan pribadi dan menampilkan progres dari API. Tidak menampilkan data laporan warga lain. |
| FAQ | Tab FAQ dan pintasan bantuan berisi jawaban mengenai privasi, waktu tanggapan yang belum ditetapkan, format file, dan status. |
| Profil | Memakai fakta Kelurahan Cepoko yang sudah bersumber dan melabeli data GIS kantor tahun 2021; informasi yang belum terverifikasi tetap dinyatakan belum tersedia. |
| Splash/login/akun demo | Tidak diterapkan sebagai autentikasi. Login warga berada di luar ruang lingkup PRD dan belum ada identitas atau layanan autentikasi yang aman. Login petugas tetap berupa prototipe terbatas sesuai batas arsitektur. |

## Batas fakta dan privasi

Mockup memuat angka laporan, nama/akun uji, foto kejadian, nama petugas, berita, dusun/RT/RW, koordinat, dan janji respons. Semua diperlakukan sebagai konten contoh, bukan fakta Kelurahan Cepoko di Gunungpati. Aplikasi tidak menyalinnya. Statistik harus berasal dari API; status dicari memakai kode; informasi profil hanya ditampilkan bila sumber serta tahunnya jelas. Foto kantor atau warga baru dapat dipakai setelah sumber, lokasi, waktu, dan hak penggunaannya dipastikan.

## Interaksi yang harus dipertahankan

- CTA Beranda membuka form pengaduan.
- Berhasil mengirim menampilkan kode privat; aksi “Lacak laporan” membuka tab Status dengan kode terisi.
- Pencarian status menggunakan endpoint publik yang hanya mengembalikan ringkasan aman.
- FAQ dapat dibuka dari tab bawah maupun tombol bantuan header.
- Seluruh form memvalidasi input di klien dan API; API tetap sumber validasi tepercaya.
- Status resmi tetap `received`, `in_review`, `resolved`, dan `declined`.
