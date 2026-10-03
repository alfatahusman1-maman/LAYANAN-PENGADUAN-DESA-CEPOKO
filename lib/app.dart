import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'data/complaint_api.dart';
import 'data/demo_auth_service.dart';
import 'pages/home_page.dart';
import 'pages/information_pages.dart';
import 'pages/report_page.dart';
import 'pages/status_page.dart';
import 'theme.dart';
import 'widgets/ui.dart';

class CepokoApp extends StatefulWidget {
  const CepokoApp({
    super.key,
    required this.api,
    required this.account,
    required this.authService,
    required this.onLogout,
  });

  final ComplaintApi api;
  final DemoAccount account;
  final DemoAuthService authService;
  final VoidCallback onLogout;

  @override
  State<CepokoApp> createState() => _CepokoAppState();
}

class _CepokoAppState extends State<CepokoApp> {
  int _page = 0;
  String _trackingCode = '';
  late DemoAccount _account;

  @override
  void initState() {
    super.initState();
    _account = widget.account;
  }

  void _openTracking(String code) => setState(() {
    _trackingCode = code;
    _page = 2;
  });

  void _openPage(int page) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _page = page);
  }

  void _openProfileManager() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ProfileSheet(
        account: _account,
        authService: widget.authService,
        onProfileUpdated: (updated) {
          setState(() => _account = updated);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil warga berhasil diperbarui!'),
              backgroundColor: CepokoColors.green,
            ),
          );
        },
        onLogout: () {
          Navigator.pop(ctx);
          widget.onLogout();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          _TopBar(
            account: _account,
            onHelp: () => _openPage(3),
            onProfile: _openProfileManager,
          ),
          Expanded(
            child: IndexedStack(
              index: _page,
              children: [
                HomePage(
                  api: widget.api,
                  account: _account,
                  onReport: () => _openPage(1),
                  onTrack: () => _openPage(2),
                  onFaq: () => _openPage(3),
                ),
                ReportPage(
                  api: widget.api,
                  account: _account,
                  onTrack: _openTracking,
                  onFaq: () => _openPage(3),
                ),
                StatusPage(api: widget.api, initialCode: _trackingCode),
                const FAQPage(),
                VillageProfilePage(api: widget.api, onFaq: () => _openPage(3)),
              ],
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: _BottomNav(
      currentIndex: _page,
      onTap: _openPage,
    ),
  );
}

// ─────────────────────────────────────────────────
// Premium Top Bar
// ─────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.account,
    required this.onHelp,
    required this.onProfile,
  });

  final DemoAccount account;
  final VoidCallback onHelp;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) => Material(
    color: CepokoColors.paper,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const BrandMark(size: 36),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESA CEPOKO',
                      style: TextStyle(
                        color: CepokoColors.muted,
                        fontSize: 8,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Lapor Desa Cepoko',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              // Notification bell
              Stack(
                children: [
                  IconButton(
                    onPressed: onHelp,
                    tooltip: 'Notifikasi',
                    icon: const Icon(LucideIcons.bell, color: CepokoColors.ink, size: 20),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: CepokoColors.tan,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              // Avatar (Opens Profile Management)
              GestureDetector(
                onTap: onProfile,
                child: Tooltip(
                  message: 'Kelola Profil',
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: CepokoColors.greenLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: CepokoColors.green, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        account.name.isNotEmpty ? account.name[0].toUpperCase() : 'W',
                        style: const TextStyle(
                          color: CepokoColors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────
// Clean 5-Item Bottom Navigation (No Center FAB)
// ─────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: CepokoColors.paper,
      border: Border(top: BorderSide(color: CepokoColors.line, width: 0.5)),
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            _NavItem(
              icon: LucideIcons.house,
              label: 'Beranda',
              active: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: LucideIcons.fileText,
              label: 'Pengaduan',
              active: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: LucideIcons.inbox,
              label: 'Inbox',
              active: currentIndex == 2,
              onTap: () => onTap(2),
              badge: true,
            ),
            _NavItem(
              icon: LucideIcons.circleHelp,
              label: 'FAQ',
              active: currentIndex == 3,
              onTap: () => onTap(3),
            ),
            _NavItem(
              icon: LucideIcons.info,
              label: 'Info',
              active: currentIndex == 4,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    ),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.badge = false,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: active ? CepokoColors.green : CepokoColors.muted,
                ),
                if (badge)
                  Positioned(
                    right: -4,
                    top: -2,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: CepokoColors.tan,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: active ? CepokoColors.green : CepokoColors.muted,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────
// Kelola Profil Warga (Profile Management Sheet)
// ─────────────────────────────────────────────────

class _ProfileSheet extends StatefulWidget {
  const _ProfileSheet({
    required this.account,
    required this.authService,
    required this.onProfileUpdated,
    required this.onLogout,
  });

  final DemoAccount account;
  final DemoAuthService authService;
  final ValueChanged<DemoAccount> onProfileUpdated;
  final VoidCallback onLogout;

  @override
  State<_ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<_ProfileSheet> {
  late DemoAccount _account;

  @override
  void initState() {
    super.initState();
    _account = widget.account;
  }

  void _openEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _account.name);
    final phoneCtrl = TextEditingController(text: _account.phone);
    final nikCtrl = TextEditingController(text: _account.nik);
    final rtRwCtrl = TextEditingController(text: _account.rtRw);
    final addressCtrl = TextEditingController(text: _account.address);

    showDialog<void>(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        title: const Text('Edit Data Diri Warga'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nikCtrl,
                decoration: const InputDecoration(labelText: 'NIK (16 Digit)'),
                keyboardType: TextInputType.number,
                maxLength: 16,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Nomor WhatsApp / HP'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: rtRwCtrl,
                decoration: const InputDecoration(labelText: 'Wilayah (RT / RW / Dusun)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressCtrl,
                decoration: const InputDecoration(labelText: 'Alamat Domisili'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final updated = widget.authService.updateProfile(
                email: _account.email,
                name: nameCtrl.text.trim().isEmpty ? _account.name : nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                nik: nikCtrl.text.trim(),
                rtRw: rtRwCtrl.text.trim(),
                address: addressCtrl.text.trim(),
              );
              if (updated != null) {
                setState(() => _account = updated);
                widget.onProfileUpdated(updated);
              }
              Navigator.pop(dlgCtx);
            },
            style: FilledButton.styleFrom(backgroundColor: CepokoColors.green),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _openChangePasswordDialog() {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    String? err;

    showDialog<void>(
      context: context,
      builder: (dlgCtx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('Ubah Kata Sandi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Kata Sandi Saat Ini'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Kata Sandi Baru'),
              ),
              if (err != null) ...[
                const SizedBox(height: 8),
                Text(err!, style: const TextStyle(color: CepokoColors.error, fontSize: 11)),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgCtx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (newPassCtrl.text.length < 6) {
                  setDlgState(() => err = 'Kata sandi baru minimal 6 karakter.');
                  return;
                }
                final ok = widget.authService.changePassword(
                  email: _account.email,
                  oldPassword: oldPassCtrl.text,
                  newPassword: newPassCtrl.text,
                );
                if (ok) {
                  Navigator.pop(dlgCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kata sandi berhasil diperbarui!'),
                      backgroundColor: CepokoColors.green,
                    ),
                  );
                } else {
                  setDlgState(() => err = 'Kata sandi saat ini tidak cocok.');
                }
              },
              style: FilledButton.styleFrom(backgroundColor: CepokoColors.green),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: CepokoColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // User Avatar & Name
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: CepokoColors.greenLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: CepokoColors.green, width: 2),
                ),
                child: Center(
                  child: Text(
                    _account.name.isNotEmpty ? _account.name[0].toUpperCase() : 'W',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: CepokoColors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _account.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _account.email,
                      style: const TextStyle(fontSize: 12, color: CepokoColors.muted),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: CepokoColors.greenLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _account.role == AccountRole.admin ? 'Petugas Kelurahan' : 'Warga Terverifikasi',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: CepokoColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          const Text('Data Profil Warga', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _profileInfoRow(LucideIcons.idCard, 'NIK', _account.nik.isNotEmpty ? _account.nik : 'Belum diisi'),
          _profileInfoRow(LucideIcons.phone, 'No. WhatsApp', _account.phone.isNotEmpty ? _account.phone : 'Belum diisi'),
          _profileInfoRow(LucideIcons.mapPin, 'Wilayah', _account.rtRw.isNotEmpty ? _account.rtRw : 'Belum diisi'),
          _profileInfoRow(LucideIcons.home, 'Alamat', _account.address.isNotEmpty ? _account.address : 'Belum diisi'),
          const SizedBox(height: 14),
          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openEditProfileDialog,
                  icon: const Icon(LucideIcons.pencil, size: 14),
                  label: const Text('Edit Profil', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openChangePasswordDialog,
                  icon: const Icon(LucideIcons.lock, size: 14),
                  label: const Text('Ubah Sandi', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.onLogout,
              style: FilledButton.styleFrom(
                backgroundColor: CepokoColors.error,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(LucideIcons.logOut, size: 16),
              label: const Text('Keluar dari Akun', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _profileInfoRow(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(icon, size: 15, color: CepokoColors.muted),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(fontSize: 11, color: CepokoColors.muted)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
