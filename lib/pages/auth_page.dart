import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/complaint_api.dart';
import '../data/demo_auth_service.dart';
import '../theme.dart';
import '../widgets/ui.dart';
import 'admin_page.dart';
import '../app.dart';

enum _AuthView { splash, login, register, forgot }

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.api, required this.authService});

  final ComplaintApi api;
  final DemoAuthService authService;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  _AuthView _view = _AuthView.splash;
  Timer? _splashTimer;
  DemoAccount? _account;

  @override
  void initState() {
    super.initState();
    _splashTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _view = _AuthView.login);
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  void _signIn(DemoAccount account) => setState(() => _account = account);

  void _signOut() => setState(() {
        _account = null;
        _view = _AuthView.login;
      });

  @override
  Widget build(BuildContext context) {
    final account = _account;
    if (account != null) {
      if (account.role == AccountRole.admin) {
        return AdminPage(api: widget.api, onLogout: _signOut);
      }
      return CepokoApp(
        api: widget.api,
        account: account,
        authService: widget.authService,
        onLogout: _signOut,
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: switch (_view) {
        _AuthView.splash => const _SplashScreen(key: ValueKey('splash')),
        _AuthView.login => _LoginPage(
            key: const ValueKey('login'),
            authService: widget.authService,
            onSignIn: _signIn,
            onRegister: () => setState(() => _view = _AuthView.register),
            onForgot: () => setState(() => _view = _AuthView.forgot),
          ),
        _AuthView.register => _RegisterPage(
            key: const ValueKey('register'),
            authService: widget.authService,
            onBack: () => setState(() => _view = _AuthView.login),
            onRegistered: _signIn,
          ),
        _AuthView.forgot => _ForgotPasswordPage(
            key: const ValueKey('forgot'),
            authService: widget.authService,
            onBack: () => setState(() => _view = _AuthView.login),
          ),
      },
    );
  }
}

// ─────────────────────────────────────────────────────
// Premium Splash Screen
// ─────────────────────────────────────────────────────

class _SplashScreen extends StatefulWidget {
  const _SplashScreen({super.key});

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  String _statusText = 'Menghubungkan ke layanan…';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.addListener(_updateStatus);
    _controller.forward();
  }

  void _updateStatus() {
    final v = _progress.value;
    final newText = v < 0.4
        ? 'Menghubungkan ke layanan…'
        : v < 0.7
            ? 'Menyiapkan formulir…'
            : 'Selamat Datang di Cepoko';
    if (newText != _statusText && mounted) {
      setState(() => _statusText = newText);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: CepokoColors.heroGradient),
          child: Stack(
            children: [
              // Topographic background
              const Positioned.fill(
                child: CustomPaint(painter: TopographicPainter()),
              ),
              // Ambient glow top-right
              Positioned(
                top: -60,
                right: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CepokoColors.greenSoft.withValues(alpha: .08),
                  ),
                ),
              ),
              // Ambient glow bottom-left
              Positioned(
                bottom: -80,
                left: -50,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CepokoColors.tan.withValues(alpha: .06),
                  ),
                ),
              ),
              // Main content
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                    children: [
                      // Top badge
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ActiveBadge(
                          label: 'PORTAL WARGA AKTIF',
                          light: true,
                        ),
                      ),
                      // Center content
                      const Spacer(flex: 2),
                      const BrandLogo(size: 130),
                      const SizedBox(height: 28),
                      // System badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Sistem Pengaduan Digital Masyarakat',
                          style: TextStyle(
                            color: CepokoColors.greenSoft,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Lapor Cepoko',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Aplikasi Resmi Pelayanan Aspirasi & Pengaduan\nWarga Kelurahan Cepoko',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .75),
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 26),
                      // Feature pillars
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FeaturePill(
                              icon: LucideIcons.zap,
                              label: 'Cepat',
                              light: true),
                          const SizedBox(width: 10),
                          FeaturePill(
                              icon: LucideIcons.scale,
                              label: 'Transparan',
                              light: true),
                          const SizedBox(width: 10),
                          FeaturePill(
                              icon: LucideIcons.messageSquare,
                              label: 'Tanggap',
                              light: true),
                        ],
                      ),
                      const Spacer(flex: 1),
                      // Tagline card
                      GlassCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.trees,
                                    size: 14,
                                    color: CepokoColors.greenSoft),
                                const SizedBox(width: 7),
                                Text(
                                  'AMANAH MEMBANGUN DESA',
                                  style: TextStyle(
                                    color: CepokoColors.greenSoft,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\u201cMewujudkan Pelayanan Desa Transparan, Cepat, dan Tanggap.\u201d',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .9),
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Progress bar
                      AnimatedBuilder(
                        animation: _progress,
                        builder: (context, _) => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: CepokoColors.greenSoft,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      _statusText,
                                      style: TextStyle(
                                        color: CepokoColors.greenSoft,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${(_progress.value * 100).round()}%',
                                  style: TextStyle(
                                    color: CepokoColors.greenSoft,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: SizedBox(
                                height: 5,
                                child: Stack(
                                  children: [
                                    Container(
                                      color:
                                          Colors.black.withValues(alpha: .25),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: _progress.value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              CepokoColors.greenSoft,
                                              CepokoColors.tan
                                                  .withValues(alpha: .7),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
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
                      // Footer
                      Text(
                        'v1.0.0 \u2022 Pemerintah Kelurahan Cepoko',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .55),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Kecamatan Gunungpati \u2022 Kota Semarang',
                        style: TextStyle(
                          color: CepokoColors.greenSoft.withValues(alpha: .7),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),
);
}

// ─────────────────────────────────────────────────────
// Login Page – Premium Redesign
// ─────────────────────────────────────────────────────

class _LoginPage extends StatefulWidget {
  const _LoginPage(
      {super.key,
      required this.authService,
      required this.onSignIn,
      required this.onRegister,
      required this.onForgot});
  final DemoAuthService authService;
  final ValueChanged<DemoAccount> onSignIn;
  final VoidCallback onRegister;
  final VoidCallback onForgot;

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = true;
  String? _error;
  int _tabIndex = 0; // 0 = Warga, 1 = Admin

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final account = widget.authService.signIn(_email.text, _password.text);
    if (account == null) {
      setState(() => _error =
          'Email atau kata sandi belum cocok. Periksa kembali data masuk Anda.');
      return;
    }
    widget.onSignIn(account);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            // Gradient Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: CepokoColors.heroGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                  child: Column(
                    children: [
                      const BrandLogo(size: 72),
                      const SizedBox(height: 14),
                      const Text(
                        'Lapor Desa Cepoko',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.3,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Sistem Pengaduan Digital Masyarakat\nKelurahan Cepoko',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .7),
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pelayanan Cepat, Transparan, & Akuntabel',
                          style: TextStyle(
                            color: CepokoColors.greenSoft,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Tab Switcher
            Container(
              color: CepokoColors.paper,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Transform.translate(
                offset: const Offset(0, -18),
                child: Container(
                  decoration: BoxDecoration(
                    color: CepokoColors.canvas,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: CepokoColors.line),
                  ),
                  child: Row(
                    children: [
                      _tabButton(0, LucideIcons.user, 'Warga Cepoko'),
                      _tabButton(1, LucideIcons.settings, 'Petugas Kelurahan'),
                    ],
                  ),
                ),
              ),
            ),
            // Scrollable form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mode badge
                      ActiveBadge(
                        label: _tabIndex == 0
                            ? 'Aspirasi Warga RT/RW'
                            : 'Panel Petugas Kelurahan',
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Selamat datang',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _tabIndex == 0
                            ? 'Masuk Sebagai Warga'
                            : 'Masuk Sebagai Petugas Kelurahan',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: CepokoColors.green,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _tabIndex == 0
                            ? 'Akses layanan pelaporan warga dan pantau progres penanganan.'
                            : 'Kelola laporan warga dan catat tindak lanjut penanganan.',
                        style: const TextStyle(
                            color: CepokoColors.muted,
                            fontSize: 12,
                            height: 1.6),
                      ),
                      const SizedBox(height: 22),
                      // Form
                      PremiumCard(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FieldLabel(
                                label: 'Email atau NIK (16 digit)',
                                required: true,
                                child: TextFormField(
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [
                                    AutofillHints.username,
                                    AutofillHints.email
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'warga@cepoko.desa.id',
                                    prefixIcon: Icon(LucideIcons.idCard,
                                        size: 18),
                                  ),
                                  validator: (value) =>
                                      value == null || !value.contains('@')
                                          ? 'Masukkan alamat email yang valid.'
                                          : null,
                                  onFieldSubmitted: (_) => _submit(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              FieldLabel(
                                label: 'Kata Sandi',
                                required: true,
                                child: TextFormField(
                                  controller: _password,
                                  obscureText: _obscure,
                                  autofillHints: const [
                                    AutofillHints.password
                                  ],
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        LucideIcons.lockKeyhole,
                                        size: 18),
                                    suffixIcon: IconButton(
                                      tooltip: _obscure
                                          ? 'Tampilkan kata sandi'
                                          : 'Sembunyikan kata sandi',
                                      onPressed: () => setState(
                                          () => _obscure = !_obscure),
                                      icon: Icon(
                                          _obscure
                                              ? LucideIcons.eye
                                              : LucideIcons.eyeOff,
                                          size: 18),
                                    ),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Kata sandi perlu diisi.'
                                          : null,
                                  onFieldSubmitted: (_) => _submit(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (v) => setState(
                                              () => _rememberMe = v ?? false),
                                          activeColor: CepokoColors.green,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize
                                                  .shrinkWrap,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Ingat Saya',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: widget.onForgot,
                                    child: const Text('Lupa Password?',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                              if (_error != null) ...[
                                const SizedBox(height: 10),
                                InlineNotice(
                                    message: _error!,
                                    tan: true,
                                    icon: LucideIcons.circleAlert),
                              ],
                              const SizedBox(height: 16),
                              GradientButton(
                                label: 'Masuk',
                                icon: LucideIcons.logIn,
                                onPressed: _submit,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Register CTA
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CepokoColors.greenLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: InkWell(
                          onTap: widget.onRegister,
                          child: Row(
                            children: [
                              const Icon(LucideIcons.userPlus,
                                  size: 18, color: CepokoColors.green),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                        color: CepokoColors.ink,
                                        fontSize: 13),
                                    children: [
                                      TextSpan(
                                          text: 'Belum punya akun warga? '),
                                      TextSpan(
                                        text: 'Daftar Akun Baru',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Footer
                      Center(
                        child: Text(
                          'v1.0.0 \u2022 Pemerintah Kelurahan Cepoko\nKecamatan Gunungpati \u2022 Kota Semarang',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: CepokoColors.muted,
                              fontSize: 10,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _tabButton(int index, IconData icon, String label) => Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _tabIndex = index),
            borderRadius: BorderRadius.circular(13),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _tabIndex == index
                    ? CepokoColors.green
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon,
                      size: 16,
                      color: _tabIndex == index
                          ? Colors.white
                          : CepokoColors.muted),
                  const SizedBox(width: 7),
                  Text(
                    label,
                    style: TextStyle(
                      color: _tabIndex == index
                          ? Colors.white
                          : CepokoColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────
// Register Page
// ─────────────────────────────────────────────────────

class _RegisterPage extends StatefulWidget {
  const _RegisterPage(
      {super.key,
      required this.authService,
      required this.onBack,
      required this.onRegistered});
  final DemoAuthService authService;
  final VoidCallback onBack;
  final ValueChanged<DemoAccount> onRegistered;

  @override
  State<_RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<_RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final ok = widget.authService
        .register(name: _name.text, email: _email.text, password: _password.text);
    if (!ok) {
      setState(() =>
          _error = 'Email ini sudah terdaftar. Silakan masuk menggunakan akun tersebut.');
      return;
    }
    final account = widget.authService.signIn(_email.text, _password.text)!;
    widget.onRegistered(account);
  }

  @override
  Widget build(BuildContext context) => _AuthScaffold(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _BackButton(onPressed: widget.onBack),
          const SizedBox(height: 20),
          const Text('Buat akun warga',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.7)),
          const SizedBox(height: 8),
          const Text(
              'Akun warga digunakan untuk masuk ke layanan pengaduan.',
              style: TextStyle(
                  color: CepokoColors.muted, fontSize: 13, height: 1.55)),
          const SizedBox(height: 22),
          PremiumCard(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                          labelText: 'Nama',
                          prefixIcon: Icon(LucideIcons.user, size: 18)),
                      validator: (v) => v == null || v.trim().length < 2
                          ? 'Masukkan nama yang valid.'
                          : null),
                  const SizedBox(height: 12),
                  TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(LucideIcons.mail, size: 18)),
                      validator: (v) => v == null || !v.contains('@')
                          ? 'Masukkan alamat email yang valid.'
                          : null),
                  const SizedBox(height: 12),
                  TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Buat kata sandi',
                          prefixIcon:
                              Icon(LucideIcons.lockKeyhole, size: 18)),
                      validator: (v) => v == null || v.length < 8
                          ? 'Gunakan sedikitnya 8 karakter.'
                          : null),
                ])),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            InlineNotice(
                message: _error!, tan: true, icon: LucideIcons.circleAlert)
          ],
          const SizedBox(height: 18),
          GradientButton(
              label: 'Daftar',
              onPressed: _submit,
              icon: LucideIcons.userRoundPlus),
          const SizedBox(height: 18),
          const _DemoNotice(),
        ]),
      );
}

// ─────────────────────────────────────────────────────
// Forgot Password Page
// ─────────────────────────────────────────────────────

class _ForgotPasswordPage extends StatefulWidget {
  const _ForgotPasswordPage(
      {super.key, required this.authService, required this.onBack});
  final DemoAuthService authService;
  final VoidCallback onBack;

  @override
  State<_ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<_ForgotPasswordPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _message;
  bool _success = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final ok = widget.authService
        .resetPassword(email: _email.text, password: _password.text);
    setState(() {
      _success = ok;
      _message = ok
          ? 'Kata sandi demo berhasil diubah. Silakan masuk kembali.'
          : 'Akun warga tidak ditemukan. Pada layanan resmi, gunakan proses pemulihan melalui kanal terverifikasi.';
    });
  }

  @override
  Widget build(BuildContext context) => _AuthScaffold(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _BackButton(onPressed: widget.onBack),
        const SizedBox(height: 20),
        const Text('Atur ulang kata sandi',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                letterSpacing: -.7)),
        const SizedBox(height: 8),
        const Text(
            'Masukkan email akun warga dan kata sandi baru. Alur ini hanya bekerja di sesi demo pada perangkat ini.',
            style: TextStyle(
                color: CepokoColors.muted, fontSize: 13, height: 1.55)),
        const SizedBox(height: 22),
        PremiumCard(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: 'Email akun warga',
                        prefixIcon: Icon(LucideIcons.mail, size: 18)),
                    validator: (v) => v == null || !v.contains('@')
                        ? 'Masukkan alamat email yang valid.'
                        : null),
                const SizedBox(height: 12),
                TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Kata sandi baru',
                        prefixIcon: Icon(LucideIcons.lockKeyhole, size: 18)),
                    validator: (v) => v == null || v.length < 8
                        ? 'Gunakan sedikitnya 8 karakter.'
                        : null),
                const SizedBox(height: 12),
                TextFormField(
                    controller: _confirm,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Ulangi kata sandi',
                        prefixIcon: Icon(LucideIcons.lockKeyhole, size: 18)),
                    validator: (v) => v != _password.text
                        ? 'Kata sandi belum sama.'
                        : null),
              ])),
        ),
        if (_message != null) ...[
          const SizedBox(height: 12),
          InlineNotice(
              message: _message!,
              tan: !_success,
              icon: _success
                  ? LucideIcons.circleCheck
                  : LucideIcons.circleAlert)
        ],
        const SizedBox(height: 18),
        GradientButton(
            label: 'Simpan kata sandi baru',
            onPressed: _submit,
            icon: LucideIcons.keyRound),
        const SizedBox(height: 18),
        const _DemoNotice(),
      ]));
}

// ─── Shared Widgets ───

class _AuthScaffold extends StatelessWidget {
  const _AuthScaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32), child: child),
        ))),
      );
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(LucideIcons.arrowLeft, size: 17),
      label: const Text('Kembali ke masuk'));
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice();
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: CepokoColors.canvas,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CepokoColors.line)),
        child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.info, size: 16, color: CepokoColors.muted),
              SizedBox(width: 9),
              Expanded(
                  child: Text(
                      'Mode prototipe. Data akun demo hanya disimpan sementara selama aplikasi berjalan.',
                      style: TextStyle(
                          color: CepokoColors.muted,
                          fontSize: 11,
                          height: 1.5)))
            ]),
      );
}
