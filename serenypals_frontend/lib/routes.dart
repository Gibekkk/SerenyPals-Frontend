import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/views/view/konselingpage.dart';
import 'package:serenypals_frontend/views/view/onboarding.dart';
import 'package:serenypals_frontend/views/view/profile_page.dart';
import 'package:serenypals_frontend/views/view/sharingforum.dart';
import 'package:serenypals_frontend/views/view/splashscreen.dart';
import 'views/view/chatpsikologpage.dart';
import 'views/view/dashboardpage.dart';
import 'views/view/halamanai.dart';
import 'views/view/loginscreen.dart';
import 'views/view/moodjournaling.dart';
import 'views/view/navbarlayout.dart';
import 'views/view/otpscreen.dart';
import 'views/view/registerscreen.dart';
import 'views/view/topup.dart';
import 'views/view/virtualdiaryscreen.dart';
import 'widget/customloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenypals_frontend/blocs/auth/auth_bloc.dart';
import 'package:serenypals_frontend/repositories/auth_repository.dart';

GoRouter router(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => AuthBloc(AuthRepository()),
            child: const LoginPage(),
          );
        },
      ),
      GoRoute(
        path: '/Onboarding',
        name: 'Onboarding',
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: '/splashscreen',
        name: 'splashscreen',
        builder: (context, state) => SplashScreen(delay: Duration(seconds: 2)),
      ),
      GoRoute(
        path: '/loading',
        name: 'loading',
        builder: (context, state) => const LoadingDialog(),
      ),
      GoRoute(
        path: '/register',
        name: 'Register',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => AuthBloc(AuthRepository()),
            child: const RegisterPage(),
          );
        },
      ),
      GoRoute(
        path: '/OTP',
        name: 'OTP',
        builder: (context, state) => const OtpForm(email: 'email@gmail.com'),
      ),
      GoRoute(
        path: '/mood-journaling',
        name: 'mood-journaling',
        builder: (context, state) => const MoodJournaling(),
      ),
      GoRoute(
        path: '/topup',
        name: 'topup',
        builder: (context, state) => const DiamondTopUpPage(),
      ),
      GoRoute(
        path: '/anabul',
        name: 'anabul',
        builder: (context, state) => const DiamondTopUpPage(),
      ),
      GoRoute(
        path: '/addforum',
        builder: (context, state) => AddForumScreen(),
      ),
      GoRoute(
        path: '/verify-forum',
        builder: (context, state) => AddForumVerificationScreen(),
      ),
      GoRoute(
        path: '/create-diary',
        builder: (context, state) => CreateDiaryScreen(),
      ),
      GoRoute(
        path: '/psikiater/chat/:name',
        name: 'chatPsikolog',
        builder: (context, state) {
          final name = state.pathParameters['name']!;
          return ChatPsikolog(name: name);
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          // Dapatkan path saat ini
          final location = state.uri.path;

          // Daftar tab (harus sama urutan dan isi seperti di MainTabScaffold)
          final tabPaths = [
            '/dashboard',
            '/forum',
            '/diary',
            '/profile',
            '/ai',
            '/psikiater',
          ];

          // Cari index tab sekarang
          final currentTab = tabPaths.indexWhere(
            (path) => location.startsWith(path),
          );

          return MainTabScaffold(
            currentIndex: currentTab != -1 ? currentTab : 0,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/forum',
            name: 'forum',
            builder: (context, state) => const ForumPage(),
          ),
          GoRoute(
            path: '/ai',
            name: 'ai',
            builder: (context, state) => const AIPage(),
          ),
          GoRoute(
            path: '/psikiater',
            name: 'psikiater',
            builder: (context, state) => const KonselingOnlinePage(),
          ),
          GoRoute(
            path: '/diary',
            name: 'diary',
            builder: (context, state) => MyDiaryPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
