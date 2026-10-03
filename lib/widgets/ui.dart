import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme.dart';

// ─────────────────────────────────────────────
// CepokoButton – primary action button
// ─────────────────────────────────────────────

class CepokoButton extends StatelessWidget {
  const CepokoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.outline = false,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leading;
  final bool outline;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (busy)
          const SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else if (leading != null)
          Icon(leading, size: 17),
        if (busy || leading != null) const SizedBox(width: 8),
        Text(label),
      ],
    );
    if (outline) {
      return ShadButton.outline(onPressed: onPressed, child: child);
    }
    return ShadButton(onPressed: onPressed, child: child);
  }
}

// ─────────────────────────────────────────────
// GradientButton – elevated CTA
// ─────────────────────────────────────────────

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: CepokoColors.cardGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: CepokoShadows.elevated,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: busy ? null : onPressed,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (busy)
                    const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else if (icon != null)
                    Icon(icon, size: 18, color: Colors.white),
                  if (busy || icon != null) const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(LucideIcons.arrowRight,
                      size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────
// BrandMark – logo mark widget
// ─────────────────────────────────────────────

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 38});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/branding/logo_cepoko.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: CepokoColors.green,
              child: Icon(LucideIcons.house, color: Colors.white, size: size * 0.5),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────
// BrandLogo – circular logo for splash/auth
// ─────────────────────────────────────────────

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 120});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .18),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/branding/logo_cepoko.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: CepokoColors.green,
              child: Icon(
                LucideIcons.landmark,
                color: Colors.white,
                size: size * 0.45,
              ),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────
// Eyebrow – section label
// ─────────────────────────────────────────────

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.label, {super.key, this.light = false});
  final String label;
  final bool light;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 16,
            height: 1,
            color: light ? const Color(0xFFCED7B1) : CepokoColors.green,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color:
                    light ? const Color(0xFFD1D8C1) : const Color(0xFF75816F),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.35,
              ),
            ),
          ),
        ],
      );
}

// ─────────────────────────────────────────────
// UiCard – styled card wrapper
// ─────────────────────────────────────────────

class UiCard extends StatelessWidget {
  const UiCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => ShadCard(
        child: Padding(padding: padding, child: child),
      );
}

// ─────────────────────────────────────────────
// PremiumCard – card with optional gradient border
// ─────────────────────────────────────────────

class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CepokoColors.line),
          boxShadow: CepokoShadows.card,
        ),
        child: Padding(padding: padding, child: child),
      );
}

// ─────────────────────────────────────────────
// GlassCard – frosted glass effect
// ─────────────────────────────────────────────

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: Colors.white.withValues(alpha: .15), width: 1),
        ),
        child: Padding(padding: padding, child: child),
      );
}

// ─────────────────────────────────────────────
// FeaturePill – small chip for features
// ─────────────────────────────────────────────

class FeaturePill extends StatelessWidget {
  const FeaturePill({
    super.key,
    required this.icon,
    required this.label,
    this.light = false,
  });
  final IconData icon;
  final String label;
  final bool light;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: light
              ? Colors.white.withValues(alpha: .08)
              : CepokoColors.greenLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: light
                ? Colors.white.withValues(alpha: .12)
                : CepokoColors.line,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: light ? const Color(0xFF99D4A4) : CepokoColors.green,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: light ? Colors.white.withValues(alpha: .9) : CepokoColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────
// ActiveBadge – status indicator pill
// ─────────────────────────────────────────────

class ActiveBadge extends StatelessWidget {
  const ActiveBadge({super.key, required this.label, this.light = false});
  final String label;
  final bool light;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: light
              ? Colors.white.withValues(alpha: .12)
              : CepokoColors.greenLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: light ? const Color(0xFF99D4A4) : CepokoColors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: light ? const Color(0xFF99D4A4) : CepokoColors.green,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: .3,
              ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────
// PageHeading – page top section
// ─────────────────────────────────────────────

class PageHeading extends StatelessWidget {
  const PageHeading({
    super.key,
    required this.kicker,
    required this.title,
    required this.description,
  });
  final String kicker;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow(kicker),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.65,
                    height: 1.18,
                  ),
            ),
            const SizedBox(height: 7),
            Text(
              description,
              style: const TextStyle(
                color: CepokoColors.muted,
                fontSize: 12,
                height: 1.8,
              ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────
// FieldLabel – form field label
// ─────────────────────────────────────────────

class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.label,
    this.required = false,
    this.child,
  });
  final String label;
  final bool required;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF344035),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(text: label),
                  if (required)
                    const TextSpan(
                      text: '  *',
                      style: TextStyle(color: CepokoColors.tan),
                    ),
                ],
              ),
            ),
          ),
          ?child,
        ],
      );
}

// ─────────────────────────────────────────────
// InlineNotice – info/warning notice
// ─────────────────────────────────────────────

class InlineNotice extends StatelessWidget {
  const InlineNotice({
    super.key,
    required this.message,
    this.icon = LucideIcons.info,
    this.tan = false,
  });
  final String message;
  final IconData icon;
  final bool tan;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: tan ? const Color(0xFFFAF7F0) : const Color(0xFFF0F4EB),
          border: Border.all(
            color: tan ? const Color(0xFFD8C9AD) : const Color(0xFFE0E8D8),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 17,
              color: tan ? const Color(0xFF796446) : CepokoColors.green,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.7,
                  color: CepokoColors.muted,
                ),
              ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────
// StatusBadge & helpers
// ─────────────────────────────────────────────

Widget pagePadding(Widget child) => SafeArea(
      top: false,
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: child,
          ),
        ),
      ),
    );

String statusLabel(String status) => switch (status) {
      'received' => 'Diterima',
      'in_review' => 'Sedang ditinjau',
      'resolved' => 'Selesai',
      'declined' => 'Perlu informasi',
      _ => 'Diperbarui',
    };

Color statusColor(String status) => switch (status) {
      'in_review' => const Color(0xFF906937),
      'resolved' => const Color(0xFF326448),
      'declined' => const Color(0xFF915347),
      _ => const Color(0xFF627449),
    };

Color statusBg(String status) => switch (status) {
      'in_review' => const Color(0xFFFFF3E0),
      'resolved' => const Color(0xFFE8F5E9),
      'declined' => const Color(0xFFFCE4EC),
      _ => const Color(0xFFF0F4EB),
    };

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    final bg = statusBg(status);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              statusLabel(status),
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// StatCard – animated stat display
// ─────────────────────────────────────────────

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.loading = false,
    this.color,
    this.badgeColor,
  });
  final String label;
  final int? value;
  final IconData icon;
  final bool loading;
  final Color? color;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) => PremiumCard(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: (badgeColor ?? CepokoColors.green)
                        .withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: badgeColor ?? CepokoColors.green,
                  ),
                ),
                const Spacer(),
                Text(
                  label,
                  style: TextStyle(
                    color: color ?? CepokoColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (loading && value == null)
              const SizedBox(
                width: 35,
                child: LinearProgressIndicator(minHeight: 3),
              )
            else
              Text(
                value?.toString() ?? '—',
                style: const TextStyle(
                  color: CepokoColors.ink,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────
// TopographicPainter – decorative background
// ─────────────────────────────────────────────

class TopographicPainter extends CustomPainter {
  const TopographicPainter({this.color = Colors.white, this.opacity = 0.06});
  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final cx = size.width * 0.5;
    final cy = size.height * 0.45;

    for (var i = 0; i < 4; i++) {
      final r = 60.0 + i * 50;
      final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
      canvas.drawOval(rect, paint);
    }

    // Small dashed center circle
    final dashPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const dashCount = 24;
    for (var i = 0; i < dashCount; i++) {
      final angle = (i / dashCount) * 2 * math.pi;
      final r = 30.0;
      final x1 = cx + r * math.cos(angle);
      final y1 = cy + r * math.sin(angle);
      final x2 = cx + (r + 4) * math.cos(angle);
      final y2 = cy + (r + 4) * math.sin(angle);
      if (i % 2 == 0) {
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TopographicPainter oldDelegate) => false;
}
