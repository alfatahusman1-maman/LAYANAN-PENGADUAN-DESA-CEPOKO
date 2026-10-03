import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'app.dart';
import 'data/complaint_api.dart';
import 'data/demo_auth_service.dart';
import 'pages/auth_page.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  runApp(const CepokoBootstrap());
}

class CepokoBootstrap extends StatelessWidget {
  const CepokoBootstrap({super.key});

  @override
  Widget build(BuildContext context) => ShadApp.custom(
    theme: ShadThemeData(
      brightness: Brightness.light,
      colorScheme: const ShadGreenColorScheme.light(
        primary: CepokoColors.green,
      ),
    ),
    appBuilder: (context) => MaterialApp(
      title: 'Layanan Warga — Kelurahan Cepoko',
      debugShowCheckedModeBanner: false,
      theme: buildCepokoTheme().copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: CepokoColors.green,
          secondary: CepokoColors.tan,
          surface: CepokoColors.paper,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('id', 'ID')],
      builder: (context, child) => ShadAppBuilder(child: child!),
      home: AuthGate(api: ComplaintApi(), authService: DemoAuthService()),
    ),
  );
}
