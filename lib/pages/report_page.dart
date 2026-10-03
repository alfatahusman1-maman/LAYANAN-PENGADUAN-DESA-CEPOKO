import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/complaint_api.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/ui.dart';

import '../data/demo_auth_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({
    super.key,
    required this.api,
    this.account,
    required this.onTrack,
    required this.onFaq,
  });
  final ComplaintApi api;
  final DemoAccount? account;
  final ValueChanged<String> onTrack;
  final VoidCallback onFaq;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _area = TextEditingController();
  final _contact = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController();
  String _category = 'Infrastruktur';
  final List<PlatformFile> _attachments = [];
  bool _consent = false;
  bool _anonymous = false;
  bool _sending = false;
  String? _error;
  ReportReceipt? _receipt;

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _name.text = widget.account!.name;
      _area.text = widget.account!.rtRw;
      _contact.text = widget.account!.phone.isNotEmpty ? widget.account!.phone : widget.account!.email;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _area.dispose();
    _contact.dispose();
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
        withData: true,
        allowMultiple: true,
      );
      if (result == null || result.files.isEmpty || !mounted) return;
      for (final file in result.files) {
        if (file.size > 4 * 1024 * 1024) {
          setState(() => _error = 'Ukuran file maksimal 4 MB per berkas.');
          return;
        }
        if (file.bytes == null || file.bytes!.isEmpty) {
          setState(() => _error = 'File tidak dapat dibaca. Pilih berkas lain.');
          return;
        }
        if (_attachments.length >= 3) {
          setState(() => _error = 'Maksimal 3 berkas lampiran.');
          return;
        }
        setState(() {
          _attachments.add(file);
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Berkas belum dapat dibuka. Silakan coba lagi.',
        );
      }
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_consent) {
      setState(
        () => _error = 'Centang persetujuan privasi sebelum mengirim laporan.',
      );
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final file = _attachments.isNotEmpty ? _attachments.first : null;
      final ext = file?.extension?.toLowerCase();
      final mime = ext == 'pdf'
          ? 'application/pdf'
          : (ext == 'png' ? 'image/png' : 'image/jpeg');
      final receipt = await widget.api.submitReport(
        fullName: _anonymous
            ? 'Warga Anonim'
            : (_name.text.trim().isEmpty ? 'Warga Cepoko' : _name.text.trim()),
        neighbourhood: _area.text.trim().isEmpty ? 'Kelurahan Cepoko' : _area.text.trim(),
        contact: _contact.text.trim(),
        category: _category,
        title: _title.text.trim(),
        description: _description.text.trim(),
        attachmentName: file?.name,
        attachmentMime: file == null ? null : mime,
        attachmentBytes: file?.bytes,
      );
      if (!mounted) return;
      setState(() => _receipt = receipt);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Belum dapat mengirim laporan. Periksa jaringan lalu coba lagi.',
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => pagePadding(
    _receipt == null ? _buildForm(context) : _buildReceipt(context, _receipt!),
  );

  Widget _buildForm(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header
      Row(
        children: [
          const ActiveBadge(label: 'FORMULIR ASPIRASI WARGA'),
          const Spacer(),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: CepokoColors.greenLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(LucideIcons.checkSquare, size: 17, color: CepokoColors.green),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        'Buat Laporan Baru',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -.5,
        ),
      ),
      const SizedBox(height: 6),
      const Text(
        'Sampaikan aspirasi dengan data akurat untuk percepatan verifikasi aparatur.',
        style: TextStyle(color: CepokoColors.muted, fontSize: 12, height: 1.6),
      ),
      const SizedBox(height: 18),
      // Guide card
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CepokoColors.green.withValues(alpha: .08),
              CepokoColors.greenLight,
            ],
          ),
          border: Border.all(color: CepokoColors.green.withValues(alpha: .2)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: CepokoColors.green.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.lightbulb, size: 16, color: CepokoColors.green),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panduan Pelaporan Warga',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Tuliskan laporan secara objektif dan jelas, tentukan lokasi spesifik dusun/RT, dan sertakan lampiran foto pendukung agar tim aparatur Desa Cepoko dapat segera menindaklanjuti.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.65,
                        color: CepokoColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category picker
            FieldLabel(
              label: 'Kategori Pengaduan',
              required: true,
              child: _categoryPicker(),
            ),
            const SizedBox(height: 16),
            // Title
            FieldLabel(
              label: 'Judul Pengaduan',
              required: true,
              child: TextFormField(
                controller: _title,
                textInputAction: TextInputAction.next,
                maxLength: 60,
                decoration: const InputDecoration(
                  hintText: 'Jelaskan pokok persoalan secara singkat dan padat.',
                  counterText: '',
                  prefixIcon: Icon(LucideIcons.type, size: 18),
                ),
                validator: (v) => (v?.trim().length ?? 0) < 5
                    ? 'Judul minimal 5 karakter.'
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            // Location
            FieldLabel(
              label: 'Wilayah Dusun / RT / RW',
              required: true,
              child: TextFormField(
                controller: _area,
                textInputAction: TextInputAction.next,
                maxLength: 30,
                decoration: const InputDecoration(
                  hintText: 'Dusun Krajan (RT 02 / RW 01)',
                  counterText: '',
                  prefixIcon: Icon(LucideIcons.mapPin, size: 18),
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'RT/RW wajib diisi.' : null,
              ),
            ),
            const SizedBox(height: 16),
            // Description with counter
            FieldLabel(
              label: 'Kronologi & Rincian Keluhan',
              required: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _description,
                    minLines: 4,
                    maxLines: 7,
                    maxLength: 500,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText:
                          'Jelaskan apa yang terjadi, kapan, dan titik lokasi yang mudah ditemukan.',
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => (v?.trim().length ?? 0) < 15
                        ? 'Uraian minimal 15 karakter.'
                        : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.messageCircle, size: 12, color: CepokoColors.muted),
                            const SizedBox(width: 4),
                            const Text(
                              'Bahasa sopan & santun',
                              style: TextStyle(color: CepokoColors.muted, fontSize: 9),
                            ),
                          ],
                        ),
                        Text(
                          '${_description.text.length} / 500',
                          style: TextStyle(
                            color: _description.text.length > 450 ? CepokoColors.error : CepokoColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Reporter name
            FieldLabel(
              label: 'Nama pelapor',
              required: true,
              child: TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                maxLength: 120,
                decoration: const InputDecoration(
                  hintText: 'Nama lengkap Anda',
                  counterText: '',
                  prefixIcon: Icon(LucideIcons.user, size: 18),
                ),
                validator: (v) => _anonymous
                    ? null
                    : ((v?.trim().length ?? 0) < 2
                        ? 'Nama minimal 2 karakter.'
                        : null),
              ),
            ),
            const SizedBox(height: 16),
            // Contact
            FieldLabel(
              label: 'Nomor atau email untuk dihubungi',
              child: TextFormField(
                controller: _contact,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                maxLength: 120,
                decoration: const InputDecoration(
                  hintText: 'Opsional, untuk klarifikasi',
                  counterText: '',
                  prefixIcon: Icon(LucideIcons.phone, size: 18),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Attachment Section
            _buildAttachmentSection(),
            const SizedBox(height: 18),
            // Anonymous toggle
            _buildAnonymousToggle(),
            const SizedBox(height: 16),
            // Consent
            CheckboxListTile(
              value: _consent,
              onChanged: (value) => setState(() => _consent = value ?? false),
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: CepokoColors.green,
              title: const Text(
                'Saya memahami informasi privasi laporan.',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Data digunakan untuk menindaklanjuti laporan dan tidak ditampilkan secara publik.',
                style: TextStyle(fontSize: 9, height: 1.6),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 9),
              InlineNotice(
                message: _error!,
                icon: LucideIcons.circleAlert,
                tan: true,
              ),
            ],
            const SizedBox(height: 16),
            // Submit
            GradientButton(
              label: _sending ? 'Mengirim laporan…' : 'Kirim Pengaduan Sekarang',
              icon: LucideIcons.send,
              onPressed: _sending ? null : _submit,
              busy: _sending,
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Laporan akan diteruskan langsung ke sistem verifikasi\nPemerintah Kelurahan Cepoko.',
                textAlign: TextAlign.center,
                style: TextStyle(color: CepokoColors.muted, fontSize: 9, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildAttachmentSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Text(
            'Bukti Foto & Dokumen',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF344035)),
          ),
          const SizedBox(width: 6),
          const Text('(Disarankan)', style: TextStyle(color: CepokoColors.muted, fontSize: 10)),
          const Spacer(),
          if (_attachments.isNotEmpty)
            Text(
              '${_attachments.length} Terpilih',
              style: const TextStyle(color: CepokoColors.green, fontSize: 10, fontWeight: FontWeight.w600),
            ),
        ],
      ),
      const SizedBox(height: 10),
      // Upload area
      Material(
        color: const Color(0xFFFBFCF9),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: _pickAttachment,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD3DACD), style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: CepokoColors.greenLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.camera, size: 22, color: CepokoColors.green),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sentuh untuk Unggah Berkas',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ambil foto kamera atau unggah (JPG, PNG, PDF maks. 4MB)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CepokoColors.muted, fontSize: 10),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionChip(icon: LucideIcons.camera, label: 'Kamera HP'),
                    const SizedBox(width: 8),
                    _ActionChip(icon: LucideIcons.file, label: 'Berkas Dokumen'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // Attachment previews
      if (_attachments.isNotEmpty) ...[
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _attachments.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) => _AttachmentPreview(
              file: _attachments[index],
              onRemove: () => setState(() => _attachments.removeAt(index)),
            ),
          ),
        ),
      ],
    ],
  );

  Widget _buildAnonymousToggle() => PremiumCard(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: CepokoColors.green.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(LucideIcons.eyeOff, size: 18, color: CepokoColors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Laporkan Secara Anonim',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  if (_anonymous)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: CepokoColors.greenLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Aktif', style: TextStyle(color: CepokoColors.green, fontSize: 9, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Identitas NIK dan nama Anda dirahasiakan dari publik, hanya dapat diverifikasi oleh petugas berwenang Pemerintah Kelurahan Cepoko.',
                style: TextStyle(color: CepokoColors.muted, fontSize: 10, height: 1.5),
              ),
            ],
          ),
        ),
        Switch(
          value: _anonymous,
          onChanged: (v) => setState(() => _anonymous = v),
          activeColor: CepokoColors.green,
        ),
      ],
    ),
  );

  void _openWhatsAppGateway(BuildContext context, ReportReceipt receipt) {
    final waMessage = '''*KONFIRMASI LAPORAN WARGA CEPOKO*
----------------------------------------
ID Laporan: ${receipt.id}
Kategori: $_category
Judul: ${_title.text.trim()}
Wilayah: ${_area.text.trim()}
Waktu: ${DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(DateTime.now())} WIB

Laporan ini telah tercatat dalam Sistem Pelayanan & Aspirasi Warga Kelurahan Cepoko, Kecamatan Gunungpati, Kota Semarang.
Mohon bantuan tindak lanjut aparatur/petugas terkait. Terima kasih.''';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: CepokoColors.paper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.messageSquare, color: Color(0xFF2E7D32), size: 19),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gateway WhatsApp Kelurahan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text('Draf konfirmasi untuk arsip & kontak warga', style: TextStyle(color: CepokoColors.muted, fontSize: 10)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  icon: const Icon(LucideIcons.x, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const InlineNotice(
              message: 'Nomor WhatsApp resmi kelurahan akan ditautkan secara langsung saat nomor layanan publik kelurahan telah terkonfirmasi. Format pesan konfirmasi di bawah ini dapat disalin untuk dikirimkan langsung ke nomor pengurus RT/RW atau pihak berwenang.',
              icon: LucideIcons.info,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CepokoColors.canvas,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CepokoColors.line),
              ),
              child: SelectableText(
                waMessage,
                style: const TextStyle(fontSize: 10, height: 1.5, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              label: 'Salin Format Pesan WhatsApp',
              icon: LucideIcons.copy,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: waMessage));
                if (sheetContext.mounted) {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Format pesan WhatsApp berhasil disalin ke clipboard.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceipt(BuildContext context, ReportReceipt receipt) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const PageHeading(
        kicker: 'Laporan terkirim',
        title: 'Terima kasih sudah bersuara.',
        description:
            'Laporan sudah diterima. Simpan kode rahasia di bawah untuk memeriksa kabar terbaru.',
      ),
      const SizedBox(height: 12),
      PremiumCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: CepokoColors.greenLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.check, color: CepokoColors.green, size: 24),
            ),
            const SizedBox(height: 17),
            const Eyebrow('Kode pelacakan pribadi'),
            const SizedBox(height: 9),
            SelectableText(
              receipt.id,
              style: const TextStyle(
                color: CepokoColors.green,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 11),
            const Text(
              'Simpan kode ini di tempat yang aman. Siapa pun yang memilikinya dapat melihat ringkasan status laporan.',
              style: TextStyle(
                color: CepokoColors.muted,
                fontSize: 11,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 17),
            GradientButton(
              label: 'Salin kode pelacakan',
              icon: LucideIcons.copy,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: receipt.id));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kode berhasil disalin.')),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: CepokoButton(
                label: 'Konfirmasi via WhatsApp Resmi',
                leading: LucideIcons.messageSquare,
                onPressed: () => _openWhatsAppGateway(context, receipt),
                outline: true,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: CepokoButton(
                label: 'Lacak laporan di Inbox',
                onPressed: () => widget.onTrack(receipt.id),
                leading: LucideIcons.search,
                outline: true,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _receipt = null;
                    _title.clear();
                    _description.clear();
                    _attachments.clear();
                    _error = null;
                  });
                },
                icon: const Icon(LucideIcons.plusCircle, size: 14),
                label: const Text('Buat Laporan Baru Lainnya', style: TextStyle(fontSize: 11)),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TrustBadge(icon: LucideIcons.shieldCheck, label: 'Dijamin Kerahasiaan'),
          const SizedBox(width: 12),
          _TrustBadge(icon: LucideIcons.zap, label: 'Respon Layanan'),
        ],
      ),
    ],
  );

  Widget _categoryPicker() {
    const categories = [
      ('Infrastruktur', 'Jalan, Lampu, Air', LucideIcons.construction),
      ('Ketertiban', 'Siskamling, Kamtib', LucideIcons.shield),
      ('Administrasi', 'Surat, Bansos, KTP', LucideIcons.fileText),
      ('Lingkungan', 'Sampah & Kebersih...', LucideIcons.trees),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final itemWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final (name, description, icon) in categories)
              SizedBox(
                width: itemWidth,
                child: Semantics(
                  button: true,
                  selected: _category == name,
                  label: '$name. $description',
                  child: Material(
                    color: _category == name
                        ? CepokoColors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => setState(() => _category = name),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 64),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _category == name
                                ? CepokoColors.green
                                : CepokoColors.line,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: _category == name
                                  ? Colors.white
                                  : CepokoColors.green,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: _category == name
                                          ? Colors.white
                                          : CepokoColors.ink,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: _category == name
                                          ? const Color(0xFFDCE8DD)
                                          : CepokoColors.muted,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_category == name) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                LucideIcons.circleCheck,
                                size: 16,
                                color: Colors.white,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ─── Small Widgets ───

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(color: CepokoColors.line),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: CepokoColors.muted),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 10, color: CepokoColors.ink)),
      ],
    ),
  );
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({required this.file, required this.onRemove});
  final PlatformFile file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Container(
        width: 130,
        decoration: BoxDecoration(
          color: CepokoColors.canvas,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CepokoColors.line),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CepokoColors.greenLight,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(LucideIcons.image, size: 28, color: CepokoColors.green),
                    ),
                    Positioned(
                      left: 6,
                      bottom: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .55),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB',
                          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Text(
                file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        right: -4,
        top: -4,
        child: GestureDetector(
          onTap: onRemove,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: CepokoColors.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.x, size: 12, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: CepokoColors.greenLight,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: CepokoColors.green.withValues(alpha: .2)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: CepokoColors.green),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: CepokoColors.green, fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
