import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:serenypals_frontend/blocs/auth/auth_bloc.dart';
import 'package:serenypals_frontend/blocs/auth/auth_event.dart';
import 'package:serenypals_frontend/blocs/auth/auth_state.dart';
import 'package:serenypals_frontend/screen/loginscreen.dart';
import 'package:serenypals_frontend/screen/dashboardpage.dart';

import '../mocks/mock_auth.mocks.dart';

@GenerateMocks([AuthBloc])
void main() {
  late MockAuthBloc mockAuthBloc;
  late StreamController<AuthState> streamController;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    streamController = StreamController<AuthState>.broadcast();

    when(mockAuthBloc.stream).thenAnswer((_) => streamController.stream);
    when(mockAuthBloc.state).thenReturn(AuthInitial());
  });

  tearDown(() async {
    await streamController.close();
    await mockAuthBloc.close();
  });

  GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
      ],
    );
  }

  testWidgets('Login sukses langsung ke dashboard', (tester) async {
    final router = createRouter();

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: MaterialApp.router(
          routerConfig: router,
          builder: (context, child) {
            return MediaQuery(data: MediaQueryData(), child: child!);
          },
        ),
      ),
    );

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('email_field')),
      'user@gmail.com',
    );
    await tester.enterText(
      find.byKey(const Key('password_field')),
      'password123',
    );
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    verify(
      mockAuthBloc.add(
        LoginUser(email: 'user@gmail.com', password: 'password123'),
      ),
    ).called(1);

    // Simulasi login sukses langsung navigasi ke dashboard
    streamController.add(LoginSuccess());
    await tester.pumpAndSettle();

    // Pastikan halaman dashboard muncul
    expect(find.byType(DashboardPage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('Login gagal menampilkan pesan error', (tester) async {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      ],
    );

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: MaterialApp.router(
          routerConfig: router,
          builder: (context, child) {
            return MediaQuery(data: MediaQueryData(), child: child!);
          },
        ),
      ),
    );

    // Isi form valid tapi password salah
    await tester.enterText(
      find.byKey(const Key('email_field')),
      'user@gmail.com',
    );
    await tester.enterText(
      find.byKey(const Key('password_field')),
      'wrongpass',
    );

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();

    verify(
      mockAuthBloc.add(
        LoginUser(email: 'user@gmail.com', password: 'wrongpass'),
      ),
    ).called(1);

    // Simulasikan login gagal
    streamController.add(AuthFailure('Login gagal'));
    await tester.pumpAndSettle();

    // Pesan error harus muncul
    expect(find.text('Login gagal'), findsOneWidget);
  });

  testWidgets('Validasi email wajib diisi', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    // Email dikosongkan
    await tester.enterText(find.byKey(const Key('email_field')), '');
    await tester.enterText(
      find.byKey(const Key('password_field')),
      'password123',
    );

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    // Pastikan muncul pesan error bahwa email wajib diisi
    expect(find.text('Email wajib diisi'), findsOneWidget);

    // Login tidak dipanggil
    verifyNever(mockAuthBloc.add(any));
  });

  testWidgets('Validasi email format salah', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    // Email salah format, tidak ada '@gmail.com'
    await tester.enterText(find.byKey(const Key('email_field')), 'salahemail');
    await tester.enterText(
      find.byKey(const Key('password_field')),
      'password123',
    );

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    // Harus muncul pesan bahwa format email salah
    expect(
      find.text('Gunakan format email yang valid dan domain @gmail.com'),
      findsOneWidget,
    );

    // Login tidak dipanggil
    verifyNever(mockAuthBloc.add(any));
  });

  testWidgets('Validasi password kosong', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('email_field')),
      'fanny@gmail.com',
    );
    await tester.enterText(find.byKey(const Key('password_field')), '');

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    // Validasi password wajib diisi gagal dan tampil error
    expect(find.text('Password wajib diisi'), findsOneWidget);

    // Event LoginUser tidak boleh dipanggil
    verifyNever(mockAuthBloc.add(any));
  });
}
