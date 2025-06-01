import 'package:flutter/material.dart';
import 'package:serenypals_frontend/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main({String initialRoute = '/Onboarding'}) async {
  await initializeDateFormatting(
    'id_ID',
    null,
  ); // Inisialisasi locale Indonesia

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final goRouter = router(initialRoute); // kita buat fungsi khusus
    return MaterialApp.router(
      routerConfig: goRouter,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('id', 'ID')],
      theme: ThemeData(fontFamily: 'Overlock'),
      debugShowCheckedModeBanner: false,
    );
  }
}
