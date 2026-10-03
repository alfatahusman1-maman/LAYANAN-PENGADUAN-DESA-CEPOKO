import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/complaint_api.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, required this.api, required this.onLogout});
  final ComplaintApi api;
  final VoidCallback onLogout;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _noteController = TextEditingController();
  List<AdminComplaint> _rows = [];
  String? _error;
  bool _busy = false;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final rows = await widget.api.adminInbox();
      if (mounted) setState(() => _rows = rows);
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Daftar laporan belum dapat dimuat. Silakan periksa jaringan.';
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _edit(AdminComplaint row) async {
    var status = row.status;
    _noteController.text = row.adminNote ?? '';
    final updated = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Perbarui Laporan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${row.name} · ${row.neighbourhood}',
                  style: const TextStyle(fontSize: 11, color: CepokoColors.muted),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Status Baru'),
                  items: const [
                    ('received', 'Diterima'),
                    ('in_review', 'Sedang Ditinjau'),
                    ('resolved', 'Tuntas / Selesai'),
                    ('declined', 'Perlu Informasi / Ditolak'),
                  ]
                      .map(
                        (item) => DropdownMenuItem(
                          value: item.$1,
                          child: Text(
                            item.$2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => status = value ?? status),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _noteController,
                  maxLength: 1500,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Catatan Petugas untuk Warga',
                    hintText: 'Jelaskan perkembangan atau instruksi tindak lanjut...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
    if (updated != true || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.api.updateStatus(
        null,
        row.id,
        status,
        _noteController.text.trim(),
      );
      await _load();
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Status belum dapat disimpan. Coba lagi.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete(AdminComplaint row) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pengaduan'),
        content: Text('Apakah Anda yakin ingin menghapus laporan "${row.title}"? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: CepokoColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await widget.api.deleteComplaint(row.id);
      await _load();
    }
  }

  List<AdminComplaint> get _filteredRows {
    if (_selectedFilter == 'all') return _rows;
    return _rows.where((r) => r.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Panel Peturahan Cepoko',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          onPressed: _load,
          tooltip: 'Muat ulang data',
          icon: const Icon(LucideIcons.refreshCw, size: 18),
        ),
        IconButton(
          onPressed: widget.onLogout,
          tooltip: 'Keluar dari akun petugas',
          icon: const Icon(LucideIcons.logOut, size: 18),
        ),
      ],
    ),
    body: RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Row(
            children: [
              const ActiveBadge(label: 'PANEL PETUGAS AKTIF'),
              const Spacer(),
              Text(
                '${_rows.length} Total Laporan',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: CepokoColors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const PageHeading(
            kicker: 'Layanan Aparatur',
            title: 'Kelola Pengaduan Warga',
            description:
                'Tinjau aspirasi masyarakat, ubah status perkembangan, dan catat hasil tindak lanjut.',
          ),
          const SizedBox(height: 10),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('all', 'Semua (${_rows.length})'),
                const SizedBox(width: 8),
                _filterChip('received', 'Diterima (${_rows.where((r) => r.status == "received").length})'),
                const SizedBox(width: 8),
                _filterChip('in_review', 'Ditangani (${_rows.where((r) => r.status == "in_review").length})'),
                const SizedBox(width: 8),
                _filterChip('resolved', 'Tuntas (${_rows.where((r) => r.status == "resolved").length})'),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            InlineNotice(
              message: _error!,
              tan: true,
              icon: LucideIcons.circleAlert,
            ),
          ],
          const SizedBox(height: 16),
          if (_busy) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
          ] else if (_filteredRows.isEmpty) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(LucideIcons.inbox, size: 40, color: CepokoColors.muted.withValues(alpha: .5)),
                    const SizedBox(height: 10),
                    const Text(
                      'Belum ada laporan pada filter ini',
                      style: TextStyle(color: CepokoColors.muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            for (final row in _filteredRows) ...[
              _AdminReportCard(
                row: row,
                onEdit: () => _edit(row),
                onDelete: () => _delete(row),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    ),
  );

  Widget _filterChip(String key, String label) {
    final active = _selectedFilter == key;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 11, fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
      selected: active,
      selectedColor: CepokoColors.greenLight,
      onSelected: (_) => setState(() => _selectedFilter = key),
    );
  }
}

class _AdminReportCard extends StatelessWidget {
  const _AdminReportCard({
    required this.row,
    required this.onEdit,
    required this.onDelete,
  });

  final AdminComplaint row;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => UiCard(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: CepokoColors.greenLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          row.category,
                          style: const TextStyle(
                            color: CepokoColors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        row.neighbourhood,
                        style: const TextStyle(
                          color: CepokoColors.muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    row.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(row.status),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(LucideIcons.user, size: 12, color: CepokoColors.muted),
            const SizedBox(width: 4),
            Text(
              '${row.name}${row.contact?.isNotEmpty == true ? ' (${row.contact})' : ''}',
              style: const TextStyle(fontSize: 11, color: CepokoColors.ink, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          row.description,
          style: const TextStyle(
            fontSize: 11,
            color: CepokoColors.ink,
            height: 1.5,
          ),
        ),
        if (row.adminNote != null && row.adminNote!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: CepokoColors.green.withValues(alpha: .2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.messageSquare, size: 14, color: CepokoColors.green),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Catatan Petugas: ${row.adminNote}',
                    style: const TextStyle(fontSize: 10, color: CepokoColors.ink, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (row.attachmentName case final name?) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                LucideIcons.paperclip,
                size: 13,
                color: CepokoColors.green,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CepokoColors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              DateFormat('d MMM yyyy · HH:mm', 'id_ID').format(row.createdAt),
              style: const TextStyle(color: CepokoColors.muted, fontSize: 9),
            ),
            const Spacer(),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(LucideIcons.trash2, size: 16, color: CepokoColors.error),
              tooltip: 'Hapus laporan',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 14),
            FilledButton.icon(
              onPressed: onEdit,
              style: FilledButton.styleFrom(
                backgroundColor: CepokoColors.green,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              icon: const Icon(LucideIcons.pencil, size: 13),
              label: const Text('Perbarui Status', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ],
    ),
  );
}
