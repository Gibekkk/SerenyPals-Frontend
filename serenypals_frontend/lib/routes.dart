import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/screen/profile_page.dart';

import 'screen/dashboardpage.dart';
import 'screen/loginscreen.dart';
import 'screen/moodjournaling.dart';
import 'screen/navbarlayout.dart';
import 'screen/otpscreen.dart';
import 'screen/psikiaterscreen.dart';
import 'screen/registerscreen.dart';
import 'screen/topup.dart';
import 'widget/customloading.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    // Routes di luar layout
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/Register',
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

    // ✅ ShellRoute untuk halaman utama dengan bottom nav
    ShellRoute(
      builder: (context, state, child) => MainTabScaffold(child: child),
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
          builder: (context, state) => const PsikiaterPage(),
        ),
        GoRoute(
          path: '/diary',
          name: 'diary',
          builder: (context, state) => const MyDiaryPage(),
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
