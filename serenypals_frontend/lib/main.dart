import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:serenypals_frontend/routes.dart';
import 'package:serenypals_frontend/blocs/auth/auth_bloc.dart';
import 'package:serenypals_frontend/repositories/auth_repository.dart';
import 'package:serenypals_frontend/services/forum_services.dart';
import 'blocs/forum/forum_bloc.dart';

void main({String initialRoute = '/'}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi lokal tanggal/waktu untuk bahasa Indonesia
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi repository
  final authRepository = AuthRepository();
  final forumRepository = ForumApiService();

  runApp(
    MultiBlocProvider(
      providers: [
        // Bloc Auth dengan passing authRepository
        BlocProvider(
          create: (_) => AuthBloc(authRepository),
        ),
        // Bloc Forum dengan passing forumRepository (instance, bukan class)
        BlocProvider(
          create: (_) => ForumBloc(forumRepository: forumRepository),
        ),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final goRouter = router(initialRoute);

    return MaterialApp.router(
      routerConfig: goRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('id', 'ID')],
      theme: ThemeData(fontFamily: 'Overlock'),
      debugShowCheckedModeBanner: false,
    );
  }
}
