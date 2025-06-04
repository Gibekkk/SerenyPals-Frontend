import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:serenypals_frontend/screen/otpscreen.dart';
import 'package:serenypals_frontend/views/view/registerscreen.dart';
import 'package:serenypals_frontend/blocs/auth/auth_bloc.dart';

GoRouter createTestRouter({required AuthBloc authBloc}) {
  return GoRouter(
    initialLocation: '/register',
    routes: [
      GoRoute(
        path: '/register',
        builder: (context, state) {
          return BlocProvider<AuthBloc>.value(
            value: authBloc,
            child: const RegisterPage(),
          );
        },
      ),
    ],
  );
}
