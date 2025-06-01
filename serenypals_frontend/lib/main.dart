import 'package:flutter/material.dart';
import 'package:serenypals_frontend/routes.dart';

void main({String initialRoute = '/Onboarding'}) {
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
      theme: ThemeData(fontFamily: 'Overlock'),
      debugShowCheckedModeBanner: false,
    );
  }
}
