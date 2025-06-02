import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/screen/konselingpage.dart';
import 'package:serenypals_frontend/screen/onboarding.dart';
import 'package:serenypals_frontend/screen/profile_page.dart';
import 'package:serenypals_frontend/screen/splashscreen.dart';
import 'screen/chatpsikologpage.dart';
import 'screen/dashboardpage.dart';
import 'screen/halamanai.dart';
import 'screen/loginscreen.dart';
import 'screen/moodjournaling.dart';
import 'screen/navbarlayout.dart';
import 'screen/otpscreen.dart';
import 'screen/registerscreen.dart';
import 'screen/topup.dart';
import 'screen/virtualdiaryscreen.dart';
import 'widget/customloading.dart';

GoRouter router(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      // Routes di luar layout
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/Onboarding',
        name: 'Onboarding',
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: '/splashscreen',
        name: 'splashscreen',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/loading',
        name: 'loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'Register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/OTP',
        name: 'OTP',
        builder: (context, state) => const OtpForm(),
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
