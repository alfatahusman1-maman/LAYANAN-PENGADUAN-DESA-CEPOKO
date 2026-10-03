import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/complaint_api.dart';
import '../theme.dart';
import '../widgets/ui.dart';
import 'admin_page.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  static const questions = [
    (
      'Apakah nama dan laporan saya ditampilkan ke publik?',
      'Tidak. Nama, kontak, dan isi laporan hanya dapat dibuka petugas dengan akses admin. Halaman pelacakan hanya menampilkan ringkasan status dan judul laporan.',
    ),
    (
      'Berapa lama petugas akan menanggapi laporan?',
      'Batas waktu tanggapan belum ditetapkan. Simpan kode pelacakan dan periksa status secara berkala. Kelurahan dapat menambahkan standar layanan setelah dikonfirmasi.',
    ),
    (
      'Format dan ukuran file apa yang bisa dilampirkan?',
      'Lampiran yang diterima ialah foto JPG atau PNG dan dokumen PDF, maksimal 4 MB. Bukti foto bersifat opsional; foto lokasi dapat membantu petugas.',
    ),
    (
      'Apakah saya harus mencantumkan nama lengkap?',
      'Ya. Nama dibutuhkan petugas untuk menindaklanjuti laporan dan dijaga sebagai informasi pribadi. Kolom nomor telepon atau email untuk klarifikasi bersifat opsional.',
    ),
    (
      'Bagaimana jika saya kehilangan kode pelacakan?',
      'Kode ditampilkan setelah laporan berhasil dikirim. Salin dan simpan saat itu. Bila kode hilang, minta bantuan petugas melalui kontak kelurahan setelah kanalnya dikonfirmasi.',
    ),
    (
      'Apakah saya bisa mengirim lebih dari satu laporan?',
      'Bisa. Buat laporan terpisah untuk setiap persoalan supaya petugas lebih mudah mengelompokkan dan menanganinya.',
    ),
    (
      'Apa arti setiap status laporan?',
      'Diterima berarti laporan berhasil masuk. Sedang ditinjau berarti petugas sedang memeriksanya. Selesai berarti penanganan dicatat. Perlu informasi berarti klarifikasi tambahan dibutuhkan.',
    ),
  ];

  @override
  Widget build(BuildContext context) => pagePadding(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeading(
          kicker: 'Pusat bantuan',
          title: 'Jawaban, sebelum Anda bertanya.',
          description:
              'Temukan panduan ringkas untuk membuat laporan dan memeriksa tindak lanjut.',
        ),
        const InlineNotice(
          message:
              'Informasi batas waktu tanggapan akan mengikuti standar layanan Kelurahan Cepoko setelah dikonfirmasi.',
          icon: LucideIcons.info,
        ),
        const SizedBox(height: 15),
        UiCard(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            children: [
              for (var i = 0; i < questions.length; i++) ...[
                Material(
                  color: Colors.transparent,
                  child: ExpansionTile(
                    key: PageStorageKey<String>('faq-$i'),
                    leading: Text(
                      (i + 1).toString().padLeft(2, '0'),
                      style: const TextStyle(
                        color: Color(0xFF98A191),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    title: Text(
                      questions[i].$1,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(15, 0, 13, 14),
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    iconColor: CepokoColors.green,
                    collapsedIconColor: CepokoColors.muted,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          questions[i].$2,
                          style: const TextStyle(
                            fontSize: 10,
                            height: 1.8,
                            color: CepokoColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i != questions.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
        const SizedBox(height: 15),
        const InlineNotice(
          message:
              'Masih membutuhkan bantuan? Kontak kelurahan akan ditampilkan setelah diverifikasi.',
          icon: LucideIcons.messageCircle,
          tan: true,
        ),
      ],
    ),
  );
}

class VillageProfilePage extends StatelessWidget {
  const VillageProfilePage({super.key, required this.api, required this.onFaq});
  final ComplaintApi api;
  final VoidCallback onFaq;

  static const String _gmapsUrl = 'https://maps.app.goo.gl/YHjpTJTCzvhxgpzU8';
  static const String _coordinates = '-7.0725293, 110.3515725';

  void _copyToClipboard(BuildContext context, String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CepokoColors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => pagePadding(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const ActiveBadge(label: 'PROFIL DESA & KELURAHAN'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: CepokoColors.greenLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Kec. Gunungpati',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: CepokoColors.green,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const PageHeading(
          kicker: 'GUNUNGPATI · KOTA SEMARANG',
          title: 'Kelurahan Cepoko',
          description:
              'Pusat pelayanan administrasi, informasi wilayah, dan lokasi kantor kelurahan.',
        ),
        const SizedBox(height: 12),
        // Foto Kantor Kelurahan Cepoko
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.asset(
                'assets/branding/kantor_kelurahan_cepoko.jpg',
                width: double.infinity,
                height: 210,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 210,
                  color: CepokoColors.greenLight,
                  child: const Center(
                    child: Icon(LucideIcons.landmark, size: 48, color: CepokoColors.green),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.camera, size: 12, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        'Kantor Kelurahan Cepoko',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 24, 14, 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: .85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kantor Kelurahan Cepoko',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Kecamatan Gunungpati, Kota Semarang, Jawa Tengah 50223',
                        style: TextStyle(
                          color: Color(0xFFD7DEB1),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Google Maps Card Preview
        const Eyebrow('LOKASI GOOGLE MAPS'),
        const SizedBox(height: 6),
        Text(
          'Titik Lokasi Kantor',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Titik koordinat presisi Kantor Kelurahan Cepoko pada Google Maps.',
          style: TextStyle(fontSize: 11, color: CepokoColors.muted),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F7F2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: CepokoColors.green.withValues(alpha: .2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map graphic simulation
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EDE3),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFDFE9DC),
                      CepokoColors.greenSoft.withValues(alpha: .2),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CepokoColors.green,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: CepokoColors.green.withValues(alpha: .3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(LucideIcons.mapPin, color: Colors.white, size: 24),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          _coordinates,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: CepokoColors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(LucideIcons.mapPin, size: 14, color: CepokoColors.green),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Jl. Cepoko Raya No. 2, RT 04 / RW 01',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Kelurahan Cepoko, Kecamatan Gunungpati, Kota Semarang 50223',
                      style: TextStyle(fontSize: 11, color: CepokoColors.muted),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _copyToClipboard(
                              context,
                              _gmapsUrl,
                              'Tautan Google Maps berhasil disalin: $_gmapsUrl',
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: CepokoColors.green,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Icon(LucideIcons.externalLink, size: 14),
                            label: const Text('Buka / Salin Maps', style: TextStyle(fontSize: 11)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () => _copyToClipboard(
                            context,
                            _coordinates,
                            'Koordinat berhasil disalin: $_coordinates',
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                          icon: const Icon(LucideIcons.copy, size: 14),
                          label: const Text('Koordinat', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Jam Pelayanan
        const Eyebrow('PELAYANAN KANTOR'),
        const SizedBox(height: 6),
        Text(
          'Jam Pelayanan Publik',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        UiCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _serviceHourRow(
                day: 'Senin \u2013 Kamis',
                time: '07.30 \u2013 16.00 WIB',
                icon: LucideIcons.calendarCheck,
                status: 'Buka',
              ),
              const Divider(height: 16),
              _serviceHourRow(
                day: 'Jumat',
                time: '07.30 \u2013 14.30 WIB',
                icon: LucideIcons.calendarCheck,
                status: 'Buka',
              ),
              const Divider(height: 16),
              _serviceHourRow(
                day: 'Sabtu & Minggu',
                time: 'Libur Pelayanan',
                icon: LucideIcons.calendarX,
                status: 'Tutup',
                isClosed: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Visi dan Misi
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CepokoColors.greenDeep,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow('VISI & MISI', light: true),
              SizedBox(height: 8),
              Text(
                'Terwujudnya Kelurahan Cepoko yang Mandiri, Sejahtera, dan Berbudaya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Kelurahan Cepoko mengedepankan pelayanan yang transparan, percepatan penanganan aspirasi warga, serta pemanfaatan potensi agrowisata perkebunan lokal.',
                style: TextStyle(
                  color: Color(0xFFD1D8CA),
                  fontSize: 11,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        // FAQ & Admin Access
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onFaq,
                icon: const Icon(LucideIcons.circleHelp, size: 15),
                label: const Text('FAQ & Bantuan', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => AdminPage(
                      api: api,
                      onLogout: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: CepokoColors.green,
                ),
                icon: const Icon(LucideIcons.shieldCheck, size: 15),
                label: const Text('Panel Petugas', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  static Widget _serviceHourRow({
    required String day,
    required String time,
    required IconData icon,
    required String status,
    bool isClosed = false,
  }) => Row(
    children: [
      Icon(icon, size: 16, color: isClosed ? CepokoColors.muted : CepokoColors.green),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(day, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            Text(time, style: const TextStyle(fontSize: 11, color: CepokoColors.muted)),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isClosed ? const Color(0xFFF1F1F1) : CepokoColors.greenLight,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isClosed ? CepokoColors.muted : CepokoColors.green,
          ),
        ),
      ),
    ],
  );
}

class _MissionLine extends StatelessWidget {
  const _MissionLine({
    required this.number,
    required this.title,
    required this.detail,
  });
  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Color(0xFFD7DEB1),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                style: const TextStyle(
                  color: Color(0xFFC3CFC0),
                  fontSize: 9,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _VerifiedMapCard extends StatelessWidget {
  const _VerifiedMapCard({
    required this.icon,
    required this.badge,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String badge;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => UiCard(
    padding: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 92,
          decoration: const BoxDecoration(color: Color(0xFFEDF0E7)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: CepokoColors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              Positioned(
                right: 8,
                bottom: 6,
                child: Text(
                  badge.contains('ALAMAT')
                      ? 'PETA TIDAK DITAMPILKAN'
                      : 'KOORDINAT GIS 2021',
                  style: TextStyle(
                    color: CepokoColors.muted.withValues(alpha: .8),
                    fontSize: 7,
                    letterSpacing: .8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                badge,
                style: const TextStyle(
                  color: CepokoColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 9,
                  color: CepokoColors.muted,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
