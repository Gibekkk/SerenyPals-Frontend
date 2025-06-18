import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenypals_frontend/blocs/diary/diary_bloc.dart';
import 'package:serenypals_frontend/blocs/diary/diary_event.dart';
import 'package:serenypals_frontend/blocs/forum/forum_event.dart';
import 'package:serenypals_frontend/blocs/profile/profile_bloc.dart';

import 'package:serenypals_frontend/routes.dart';
import 'package:serenypals_frontend/blocs/auth/auth_bloc.dart';
import 'package:serenypals_frontend/repositories/auth_repository.dart';
import 'package:serenypals_frontend/services/auth_services.dart';
import 'package:serenypals_frontend/services/diary_services.dart';
import 'package:serenypals_frontend/services/forum_services.dart';
import 'blocs/forum/forum_bloc.dart';
import 'blocs/meditation/mediation_event.dart';
import 'blocs/meditation/meditation_bloc.dart';
import 'blocs/profile/profile_event.dart';
import 'blocs/virtual_pet/pet_bloc.dart';
import 'repositories/diary_repository.dart';
import 'repositories/meditation_repository.dart';
import 'services/auth_services.dart';
import 'services/meditation_service.dart';

void main({String initialRoute = '/'}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initializeDateFormatting('id_ID', null);

  final authRepository = AuthRepository(apiService: AuthService());
  final authRepository = AuthRepository(
    apiService: AuthService(),
  );
  final diaryRepository = DiaryRepository(DiaryApiService());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(
          create: (_) => ForumBloc(forumRepository: ForumApiService())
            ..add(LoadForumData()),
        ),
        BlocProvider(create: (_) => PetBloc()),
        BlocProvider(
          create: (_) =>
              VirtualDiaryBloc(diaryRepository)..add(LoadDiaryEntries()),
        ),
        BlocProvider(
          create: (context) => MeditationTipsBloc(
            meditationRepository: MeditationRepository(MeditationApiService()),
          )..add(LoadMeditationTips()),
        ),
        BlocProvider(
            create: (_) => ProfileBloc(authRepository: authRepository)
              ..add(FetchProfile(authRepository as String))),
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
