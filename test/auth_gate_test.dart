import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layanan_desa_cepoko/data/complaint_api.dart';
import 'package:layanan_desa_cepoko/data/demo_auth_service.dart';
import 'package:layanan_desa_cepoko/pages/auth_page.dart';
import 'package:layanan_desa_cepoko/theme.dart';

void main() {
  testWidgets('shows splash before the shared sign-in page', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildCepokoTheme(),
      home: AuthGate(api: ComplaintApi(), authService: DemoAuthService()),
    ));

    expect(find.text('Lapor Cepoko'), findsOneWidget);
    expect(find.text('Selamat datang'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pump();

    expect(find.text('Selamat datang'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Panel petugas'), findsNothing);
  });
}
