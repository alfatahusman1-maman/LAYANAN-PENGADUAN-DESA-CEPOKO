import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/complaint_api.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key, required this.api, required this.initialCode});
  final ComplaintApi api;
  final String initialCode;

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  late final TextEditingController _code;
  ComplaintStatus? _result;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _code = TextEditingController(text: widget.initialCode);
    if (widget.initialCode.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _lookup());
    }
  }

  @override
  void didUpdateWidget(covariant StatusPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCode != oldWidget.initialCode &&
        widget.initialCode.isNotEmpty) {
      _code.text = widget.initialCode;
      WidgetsBinding.instance.addPostFrameCallback((_) => _lookup());
    }
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _lookup() async {
    if (_code.text.trim().isEmpty) {
      setState(() => _error = 'Masukkan kode pelacakan laporan.');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
      _result = null;
    });
    try {
      final result = await widget.api.lookup(_code.text);
      if (mounted) setState(() => _result = result);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Status belum dapat dimuat. Periksa jaringan lalu coba lagi.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => pagePadding(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Eyebrow('RUANG ASPIRASI WARGA'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: CepokoColors.greenLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CepokoColors.green.withValues(alpha: .2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.shieldCheck, size: 12, color: CepokoColors.green),
                  const SizedBox(width: 5),
                  const Text(
                    'Transparan & Terpantau',
                    style: TextStyle(
                      color: CepokoColors.green,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Status Pengaduan',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -.65,
          ),
        ),
        const SizedBox(height: 14),
        // Search bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: CepokoColors.line),
            boxShadow: CepokoShadows.card,
          ),
          child: TextField(
            controller: _code,
            textInputAction: TextInputAction.search,
            autocorrect: false,
            enableSuggestions: false,
            onSubmitted: (_) => _lookup(),
            decoration: InputDecoration(
              hintText: 'Masukkan kode pelacakan laporan (UUID)...',
              prefixIcon: const Icon(LucideIcons.search, size: 18, color: CepokoColors.muted),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Filter chips
        _FilterChips(hasResult: _result != null),
        const SizedBox(height: 16),
        // Search button
        GradientButton(
          label: _busy ? 'Mencari laporan…' : 'Tampilkan Status',
          icon: LucideIcons.search,
          onPressed: _busy ? null : _lookup,
          busy: _busy,
        ),
        const SizedBox(height: 12),
        const InlineNotice(
          message:
              'Kode bersifat pribadi. Jangan bagikan kepada orang lain; pemilik kode dapat membaca ringkasan laporan.',
          icon: LucideIcons.lockKeyhole,
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          InlineNotice(
            message: _error!,
            icon: LucideIcons.circleAlert,
            tan: true,
          ),
        ],
        if (_result case final result?) ...[
          const SizedBox(height: 20),
          _StatusResult(result: result),
        ],
        const SizedBox(height: 20),
        // Bottom motto card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: CepokoColors.cardGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.shieldCheck, size: 20, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pelayanan Terpadu Kelurahan Cepoko',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Setiap laporan warga ditindaklanjuti secara transparan dan akuntabel oleh aparatur Kelurahan Cepoko.',
                      style: TextStyle(color: Colors.white.withValues(alpha: .75), fontSize: 10, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        const _StatusHelpCard(),
      ],
    ),
  );
}

// ─── Filter Chips ───

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.hasResult});
  final bool hasResult;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _FilterChip(label: 'Semua', active: true),
        const SizedBox(width: 6),
        _FilterChip(label: 'Diproses', count: null, active: false),
        const SizedBox(width: 6),
        _FilterChip(label: 'Selesai', count: null, active: false),
      ],
    ),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.count, this.active = false});
  final String label;
  final int? count;
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: active ? CepokoColors.green : CepokoColors.canvas,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: active ? CepokoColors.green : CepokoColors.line,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : CepokoColors.ink,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: active ? Colors.white.withValues(alpha: .2) : CepokoColors.line,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: active ? Colors.white : CepokoColors.muted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

// ─── Status Result ───

class _StatusResult extends StatelessWidget {
  const _StatusResult({required this.result});
  final ComplaintStatus result;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('d MMMM yyyy', 'id_ID').format(result.createdAt);
    final reviewed = result.status != 'received';
    final resolved = result.status == 'resolved';
    return PremiumCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: CepokoColors.canvas,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '# ',
                      style: TextStyle(color: CepokoColors.green, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      result.id.length > 12 ? result.id.substring(0, 12) : result.id,
                      style: const TextStyle(color: CepokoColors.muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              StatusBadge(result.status),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            result.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(LucideIcons.tag, size: 12, color: CepokoColors.muted),
              const SizedBox(width: 5),
              Text(
                result.category,
                style: const TextStyle(fontSize: 11, color: CepokoColors.muted),
              ),
              const SizedBox(width: 12),
              const Icon(LucideIcons.calendar, size: 12, color: CepokoColors.muted),
              const SizedBox(width: 5),
              Text(
                date,
                style: const TextStyle(fontSize: 11, color: CepokoColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Timeline
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: CepokoColors.canvas,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text('TAHAPAN TINDAK LANJUT', style: TextStyle(color: CepokoColors.muted, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: .8)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _TimelineRow(
            steps: [
              ('Diterima', true),
              ('Diverifikasi', reviewed),
              ('Diproses', reviewed && !resolved),
              ('Selesai', resolved),
            ],
          ),
          const SizedBox(height: 16),
          // Admin note
          if (result.adminNote != null && result.adminNote!.isNotEmpty) ...[
            PremiumCard(
              color: CepokoColors.greenLight,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.messageSquare, size: 14, color: CepokoColors.green),
                      const SizedBox(width: 7),
                      const Text(
                        'Tanggapan Pelayanan',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\u201c${result.adminNote}\u201d',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                      color: CepokoColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Progress stepper
          const SizedBox(height: 16),
          _ProgressStep(
            title: 'Laporan diterima',
            description:
                'Laporan berhasil masuk ke layanan warga Kelurahan Cepoko.',
            complete: true,
          ),
          _ProgressStep(
            title: 'Ditinjau petugas',
            description: reviewed
                ? 'Laporan sedang ditinjau petugas kelurahan.'
                : 'Laporan menunggu ditinjau petugas kelurahan.',
            complete: reviewed,
          ),
          _ProgressStep(
            title: resolved ? 'Selesai ditangani' : 'Tindak lanjut',
            description:
                result.adminNote ??
                (resolved
                    ? 'Laporan telah diselesaikan.'
                    : 'Catatan perkembangan akan ditampilkan di sini.'),
            complete: resolved,
            last: true,
          ),
          if (result.status == 'declined') ...[
            const SizedBox(height: 8),
            InlineNotice(
              message:
                  result.adminNote ??
                  'Laporan memerlukan informasi tambahan. Hubungi kantor kelurahan setelah kontak layanan dikonfirmasi.',
              icon: LucideIcons.messageCircle,
              tan: true,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Timeline Row (Horizontal stepper) ───

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.steps});
  final List<(String, bool)> steps;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < steps.length; i++) ...[
        Expanded(
          child: Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: steps[i].$2 ? CepokoColors.green : CepokoColors.canvas,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: steps[i].$2 ? CepokoColors.green : CepokoColors.line,
                    width: 1.5,
                  ),
                ),
                child: steps[i].$2
                    ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 6),
              Text(
                steps[i].$1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: steps[i].$2 ? FontWeight.w700 : FontWeight.w500,
                  color: steps[i].$2 ? CepokoColors.green : CepokoColors.muted,
                ),
              ),
            ],
          ),
        ),
        if (i < steps.length - 1)
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 18),
              color: steps[i].$2 && steps[i + 1].$2
                  ? CepokoColors.green
                  : CepokoColors.line,
            ),
          ),
      ],
    ],
  );
}

// ─── Progress Step ───

class _ProgressStep extends StatelessWidget {
  const _ProgressStep({
    required this.title,
    required this.description,
    required this.complete,
    this.last = false,
  });
  final String title;
  final String description;
  final bool complete;
  final bool last;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 25,
          child: Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: complete
                      ? CepokoColors.green
                      : const Color(0xFFF1F4EC),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: complete
                        ? CepokoColors.green
                        : const Color(0xFFD9E0D4),
                  ),
                ),
                child: complete
                    ? const Icon(
                        LucideIcons.check,
                        size: 11,
                        color: Colors.white,
                      )
                    : null,
              ),
              if (!last)
                Expanded(
                  child: Container(
                    width: 1,
                    color: complete
                        ? const Color(0xFFB2C3A8)
                        : CepokoColors.line,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: complete ? CepokoColors.ink : CepokoColors.muted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 9,
                    height: 1.55,
                    color: CepokoColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── Help Card ───

class _StatusHelpCard extends StatelessWidget {
  const _StatusHelpCard();
  @override
  Widget build(BuildContext context) => UiCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.messagesSquare,
              size: 17,
              color: CepokoColors.green,
            ),
            const SizedBox(width: 9),
            Text(
              'Sudah menyiapkan kode?',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 7),
        const Text(
          'Gunakan kode unik dari bukti pengiriman laporan. Jika kehilangan kode, mintalah bantuan kepada petugas melalui kontak kelurahan setelah informasinya dikonfirmasi.',
          style: TextStyle(
            fontSize: 10,
            color: CepokoColors.muted,
            height: 1.7,
          ),
        ),
      ],
    ),
  );
}
