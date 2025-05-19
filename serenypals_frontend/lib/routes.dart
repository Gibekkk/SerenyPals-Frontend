import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/screen/customloading.dart';
import 'package:serenypals_frontend/screen/navbarlayout.dart';
import 'package:serenypals_frontend/screen/otpscreen.dart';
import 'package:serenypals_frontend/screen/psikiaterscreen.dart';
import 'screen/registerscreen.dart';
import 'screen/dashboardpage.dart';
import 'screen/profile_page.dart';
import 'screen/loginscreen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
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
      path: '/Home',
      name: 'Home',
      builder: (context, state) => const MainTabScaffold(),
    ),
    GoRoute(
      path: '/Dashboard',
      name: 'Dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/SharingForum',
      name: 'SharingForum',
      builder: (context, state) => const ForumPage(),
    ),
    GoRoute(
      path: '/AI',
      name: 'AI',
      builder: (context, state) => const AIPage(),
    ),
    GoRoute(
      path: '/Psikiater',
      name: 'Psikiater',
      builder: (context, state) => const PsikiaterPage(),
    ),
    GoRoute(
      path: '/profile/:id',
      name: 'profile',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProfilePage(userId: id);
      },
    ),
  ],
);
