import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../data/complaint_api.dart';
import '../data/demo_auth_service.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.api,
    required this.account,
    required this.onReport,
    required this.onTrack,
    required this.onFaq,
  });
  final ComplaintApi api;
  final DemoAccount account;
  final VoidCallback onReport;
  final VoidCallback onTrack;
  final VoidCallback onFaq;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ComplaintStats> _stats;

  @override
  void initState() {
    super.initState();
    _stats = widget.api.fetchStats();
  }

  @override
  Widget build(BuildContext context) => pagePadding(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Card
        _WelcomeCard(
          account: widget.account,
          onReport: widget.onReport,
        ),
        const SizedBox(height: 20),
        // Quick Action CTA
        _QuickActionCard(onReport: widget.onReport),
        const SizedBox(height: 24),
        // Stats Section
        const Eyebrow('Ringkasan laporan'),
        const SizedBox(height: 12),
        FutureBuilder<ComplaintStats>(
          future: _stats,
          builder: (context, snapshot) => _StatsRow(
            stats: snapshot.data,
            loading: snapshot.connectionState == ConnectionState.waiting,
            onRetry: () => setState(() => _stats = widget.api.fetchStats()),
          ),
        ),
        const SizedBox(height: 28),
        // Process Steps
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.route, size: 16, color: CepokoColors.green),
                const SizedBox(width: 7),
                Text(
                  'Alur Penanganan Warga',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: widget.onTrack,
              child: const Text('Transparan', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const _StepsGrid(),
        const SizedBox(height: 28),
        // Announcements Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.megaphone, size: 16, color: CepokoColors.green),
                const SizedBox(width: 7),
                Text(
                  'Pengumuman & Informasi Kelurahan',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Informasi', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const _AnnouncementCard(),
        const SizedBox(height: 20),
        // Bottom CTA
        _BottomCTACard(onReport: widget.onReport),
        const SizedBox(height: 20),
        // Posko Card
        _PoskoCard(onFaq: widget.onFaq),
        const SizedBox(height: 16),
        const _FooterInfo(),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────
// Welcome Card – Personal greeting
// ─────────────────────────────────────────────────────

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.account, required this.onReport});
  final DemoAccount account;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
    final firstName = account.name.split(' ').first;

    return PremiumCard(
      color: CepokoColors.greenLight,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.calendar, size: 13, color: CepokoColors.muted),
                  const SizedBox(width: 6),
                  Text(
                    today,
                    style: const TextStyle(color: CepokoColors.muted, fontSize: 11),
                  ),
                ],
              ),
              const Spacer(),
              const ActiveBadge(label: 'Sistem Aktif'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Halo, $firstName \uD83D\uDC4B',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -.5,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(LucideIcons.mapPin, size: 13, color: CepokoColors.muted),
              const SizedBox(width: 5),
              Text(
                'Warga Kelurahan Cepoko',
                style: const TextStyle(color: CepokoColors.muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CepokoColors.line),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Ada keluhan infrastruktur, keamanan, atau saran untuk kemajuan Desa Cepoko hari ini?',
                    style: TextStyle(
                      color: CepokoColors.muted,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Quick Action CTA
// ─────────────────────────────────────────────────────

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.onReport});
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) => PremiumCard(
    color: const Color(0xFFF0F4EB),
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.radio, size: 15, color: CepokoColors.green),
            const SizedBox(width: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: CepokoColors.greenLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CepokoColors.green.withValues(alpha: .2)),
              ),
              child: const Text(
                'Layanan Responsif',
                style: TextStyle(
                  color: CepokoColors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Laporkan Masalah di Sekitar Anda',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -.3,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Jalan rusak, lampu padam, bantuan sosial, atau kendala pelayanan surat menyurat warga.',
          style: TextStyle(color: CepokoColors.muted, fontSize: 12, height: 1.6),
        ),
        const SizedBox(height: 16),
        GradientButton(
          label: 'Tulis Pengaduan Baru',
          icon: LucideIcons.penLine,
          onPressed: onReport,
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────
// Stats Row
// ─────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({this.stats, required this.loading, required this.onRetry});
  final ComplaintStats? stats;
  final bool loading;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StatCard(
                  label: 'Total',
                  value: stats?.total,
                  icon: LucideIcons.fileText,
                  loading: loading,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  label: 'Proses',
                  value: stats?.processing,
                  icon: LucideIcons.clock3,
                  loading: loading,
                  badgeColor: CepokoColors.tan,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  label: 'Tuntas',
                  value: stats?.completed,
                  icon: LucideIcons.badgeCheck,
                  loading: loading,
                  badgeColor: CepokoColors.resolvedGreen,
                ),
              ),
            ],
          ),
        ),
        if (!loading && stats == null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 13),
              label: const Text('Muat ulang rekap', style: TextStyle(fontSize: 10)),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
// Steps Grid
// ─────────────────────────────────────────────────────

class _StepsGrid extends StatelessWidget {
  const _StepsGrid();
  static const steps = [
    ('1', LucideIcons.penLine, 'Tulis Laporan', 'Isi formulir ringkas dan unggah bukti pendukung.'),
    ('2', LucideIcons.shieldCheck, 'Verifikasi', 'Ditinjau dan diperiksa oleh petugas kelurahan.'),
    ('3', LucideIcons.settings, 'Penanganan', 'Tindak lanjut lapangan sesuai kewenangan wilayah.'),
    ('4', LucideIcons.circleCheck, 'Selesai', 'Pembaruan catatan tindak lanjut dapat dipantau di aplikasi.'),
  ];

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth < 430 ? 2 : 4;
      const gap = 8.0;
      final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final (number, icon, title, detail) in steps)
            SizedBox(
              width: width,
              child: PremiumCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: CepokoColors.greenLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              number,
                              style: const TextStyle(
                                color: CepokoColors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Icon(icon, size: 17, color: CepokoColors.green),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      detail,
                      style: const TextStyle(
                        color: CepokoColors.muted,
                        fontSize: 10,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );
}

// ─────────────────────────────────────────────────────
// Announcement Card
// ─────────────────────────────────────────────────────

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard();

  @override
  Widget build(BuildContext context) => UiCard(
    padding: const EdgeInsets.all(14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(LucideIcons.newspaper, size: 18, color: CepokoColors.green),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Belum ada pengumuman',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Kabar resmi akan ditampilkan setelah informasi dan sumbernya diverifikasi.',
                style: TextStyle(
                  color: CepokoColors.muted,
                  fontSize: 10,
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

// ─────────────────────────────────────────────────────
// Bottom CTA Card
// ─────────────────────────────────────────────────────

class _BottomCTACard extends StatelessWidget {
  const _BottomCTACard({required this.onReport});
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: CepokoColors.cardGradient,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Aspirasi Anda berarti', light: true),
        const SizedBox(height: 9),
        const Text(
          'Mulai dari hal kecil\nyang perlu dibenahi.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            height: 1.2,
            fontWeight: FontWeight.w700,
            letterSpacing: -.6,
          ),
        ),
        const SizedBox(height: 14),
        ShadButton(
          onPressed: onReport,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Buat pengaduan'),
              SizedBox(width: 9),
              Icon(LucideIcons.arrowRight, size: 16),
            ],
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────
// Posko Card
// ─────────────────────────────────────────────────────

class _PoskoCard extends StatelessWidget {
  const _PoskoCard({required this.onFaq});
  final VoidCallback onFaq;

  @override
  Widget build(BuildContext context) => PremiumCard(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: CepokoColors.green.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(LucideIcons.shieldCheck, size: 20, color: CepokoColors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pusat Layanan Warga Cepoko',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 3),
              const Text(
                'Layanan pengaduan responsif.',
                style: TextStyle(color: CepokoColors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
        ShadButton.outline(
          onPressed: onFaq,
          child: const Text('Bantuan'),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────
// Footer Info
// ─────────────────────────────────────────────────────

class _FooterInfo extends StatelessWidget {
  const _FooterInfo();
  @override
  Widget build(BuildContext context) => const UiCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BrandMark(),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layanan Warga',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2),
                Text(
                  'KELURAHAN CEPOKO',
                  style: TextStyle(
                    fontSize: 8,
                    letterSpacing: 1.1,
                    color: CepokoColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 11),
        Text(
          'Ruang informasi dan pengaduan warga Kelurahan Cepoko.',
          style: TextStyle(
            fontSize: 10,
            color: CepokoColors.muted,
            height: 1.65,
          ),
        ),
        SizedBox(height: 11),
        InlineNotice(
          message:
              'Jam pelayanan dan kontak kelurahan akan dicantumkan setelah data terkini dikonfirmasi.',
        ),
      ],
    ),
  );
}
