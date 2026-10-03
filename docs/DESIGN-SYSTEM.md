# Design system — Layanan Warga

## Prinsip pengalaman

1. **Jelas sebelum dekoratif:** warga harus tahu apa yang dikirim, siapa yang dapat membaca laporan, dan cara mengecek status.
2. **Tenang dan lokal:** hijau pinus dan tan memberi identitas layanan tanpa pola dekorasi berlebihan.
3. **Terbuka tentang keadaan:** tampilkan loading, data kosong, gagal, sukses, dan keterbatasan informasi secara eksplisit.
4. **Aman secara default:** jangan tampilkan identitas, kontak, uraian lengkap, atau bukti pada halaman pelacakan publik.
5. **Ramah aksesibilitas:** bahasa langsung, label selalu terlihat, target sentuh nyaman, dan status memakai teks beserta warna.

## Token warna

| Token | Nilai | Penggunaan |
| --- | --- | --- |
| `green` | `#1E5631` | tindakan utama, navigasi, identitas |
| `greenDeep` | `#163829` | permukaan gelap/hero dan teks pada hijau muda |
| `greenLight` | `#F0F4EB` | sorotan, chip terpilih, latar kelompok |
| `tan` | `#8D6E63` | aksen lokal, bingkai petunjuk |
| `paper` | `#FFFEFA` | permukaan dasar |
| `canvas` | `#F5F6F1` | area sekunder dan latar kartu |
| `line` | `#E4E8DF` | batas dan pemisah |
| `ink` | `#202920` | teks utama |
| `muted` | `#697366` | deskripsi/metadata; pastikan kontras pada latar |
| `error` | `#9B493E` | error dan status yang memerlukan perhatian |

Implementasi token berada di `lib/theme.dart` sebagai `CepokoColors`. Gunakan warna dari sana, bukan nilai lokal baru. Teks kecil perlu dicek kontrasnya terutama pada `muted` dan latar berwarna.

## Tipografi

- Utamakan Roboto/sans-serif sistem untuk tampilan Android konsisten dan ringan.
- Skala referensi: judul layar 24–30 sp, judul bagian 18–22 sp, judul kartu 15–17 sp, isi 14–16 sp, label/meta 11–13 sp.
- Gunakan bobot 400 untuk isi, 500 untuk label, 600–700 untuk judul atau aksi. Hindari seluruh teks menjadi bold.
- Batasi paragraf pendek. Jangan merapatkan tinggi baris pada teks bantuan atau legal.

## Grid, bentuk, dan elevasi

- Padding halaman ponsel 16–20 dp; jarak antarkelompok 20–28 dp; jarak label ke kontrol 8 dp.
- Susun konten dalam satu kolom pada ponsel. Batasi lebar konten web pada sekitar 720–960 dp.
- Gunakan radius sederhana 5–12 dp sesuai komponen. Hindari terlalu banyak kapsul dan kartu bersarang.
- Border tipis `line` lebih diutamakan daripada bayangan berat. Elevasi digunakan hanya saat komponen perlu tampak mengambang.
- Minimum target sentuh praktis 44–48 dp; beri jarak antar aksi berdekatan.

## Ikon dan ilustrasi

- Gunakan ikon Lucide melalui `lucide_icons_flutter` dengan ukuran konsisten 18–22 dp, stroke visual seragam.
- Ikon harus disertai label untuk aksi penting; jangan memakai emoji sebagai ikon UI.
- Ikon aplikasi menampilkan rumah sederhana dan elemen hijau/tan, dengan warna dan siluet yang mudah dikenali pada latar launcher. Sumber di `assets/branding/`.
- Foto Kelurahan Cepoko belum dipakai. Tambahkan foto hanya setelah sumber, lokasi, tanggal relevan, dan hak penggunaan diverifikasi. Ikon rumah adalah ilustrasi identitas, bukan dokumentasi kelurahan.

## Pola komponen

- **Primary action:** tombol hijau solid untuk satu aksi utama per bagian.
- **Secondary action:** outlined/text untuk tindakan pendamping seperti lacak atau bantuan.
- **Form field:** label permanen, hint berisi contoh, helper singkat bila perlu, error dekat dengan field.
- **Info notice:** latar hijau muda atau tan pucat, ikon line, judul pendek dan satu paragraf.
- **Status badge:** teks terjemahan + warna; jangan bergantung pada warna saja.
- **Stat card:** angka berasal dari API; gunakan placeholder/skeleton ketika memuat dan `—`/pesan kosong saat data tak tersedia.
- **FAQ:** kelompok collapsible satu kolom; setiap pertanyaan bisa dicapai keyboard dan menunjukkan kondisi buka/tutup.
- **Navigasi utama:** lima tujuan bawah pada aplikasi seluler: Beranda, Pengaduan, Status, FAQ, dan Profil. FAQ juga tersedia lewat tombol bantuan di header.
- **Pilihan kategori:** empat kartu pilihan yang dapat disentuh; kategori aktif dibedakan lewat warna, ikon centang, dan semantik aksesibilitas.
- **Kartu dan kolom:** sudut 12–16 dp, kolom nyaman disentuh, serta jarak halaman 16 dp pada layar ponsel.
- **Empty/error state:** jelaskan penyebab yang diketahui dan tindakan yang bisa dilakukan warga.

Tampilan referensi berada di `UIUX app/`. Gunakan pola layout, palet, kepadatan informasi, dan interaksi sebagai inspirasi. Jangan salin identitas warga, kredensial demo, angka, berita, foto, janji waktu tanggapan, pembagian wilayah, atau koordinat pada mockup karena itu bukan sumber data terverifikasi.

## Responsif dan aksesibilitas

- Gunakan SafeArea, scroll yang benar pada layar pendek, dan hindari overflow ketika keyboard terbuka.
- Uji skala teks sistem besar, portrait, landscape, tablet, dan viewport web.
- Sematkan label semantik pada kontrol ikon tanpa teks dan urutan fokus yang masuk akal.
- Kontras isi normal target minimal 4.5:1 bila dapat diterapkan; jangan menempatkan isi panjang di atas foto ramai.
- Gunakan kata-kata untuk status, validasi, dan error; sediakan state fokus dan disabled yang jelas.

## Bahasa dan nada

- Bahasa Indonesia baku yang hangat, tidak birokratis, dan tidak memberi janji yang belum disahkan.
- Tindakan memakai kata kerja konkret: “Kirim laporan”, “Simpan kode”, “Periksa status”.
- Jelaskan kegagalan tanpa menyalahkan warga. Beri langkah ulang yang aman.
- Jangan mengarang statistik, berita, nama petugas, jadwal tanggapan, alamat, atau peta.
