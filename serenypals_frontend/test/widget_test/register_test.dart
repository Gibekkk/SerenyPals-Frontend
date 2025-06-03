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
import 'package:serenypals_frontend/screen/registerscreen.dart';
import 'package:serenypals_frontend/screen/otpscreen.dart';

import '../mocks/mocks.mocks.dart';

@GenerateMocks([AuthBloc])
void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(mockAuthBloc.state).thenReturn(AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => Stream.empty());
  });

  tearDown(() {
    reset(mockAuthBloc);
  });

  group('Register Page Tests', () {
    testWidgets('Register button memicu AuthEventRegister', (tester) async {
      final controller = StreamController<AuthState>.broadcast();

      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => controller.stream);

      addTearDown(() async {
        await controller.close();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: RegisterPage(),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('name_field')), 'Test User');
      await tester.enterText(
        find.byKey(const Key('birthdate_field')),
        '01-01-2000',
      );
      await tester.enterText(
        find.byKey(const Key('phone_field')),
        '08123456789',
      );
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      await tester.ensureVisible(
        find.byKey(const Key('newsletter_checkbox_input')),
      );
      await tester.tap(find.byKey(const Key('newsletter_checkbox_input')));
      await tester.pump();

      await tester.ensureVisible(find.byKey(const Key('register_button')));
      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      verify(
        mockAuthBloc.add(
          RegisterUser(
            name: 'Test User',
            birthDate: '01-01-2000',
            phone: '08123456789',
            email: 'test@gmail.com',
            password: 'password123',
            subscribeNewsletter: true,
          ),
        ),
      ).called(1);
    });

    testWidgets('Setelah register sukses pindah ke halaman OTP', (
      tester,
    ) async {
      final controller = StreamController<AuthState>.broadcast();

      when(mockAuthBloc.state).thenReturn(AuthInitial());
      when(mockAuthBloc.stream).thenAnswer((_) => controller.stream);

      final router = GoRouter(
        initialLocation: '/register',
        routes: [
          GoRoute(
            path: '/register',
            builder:
                (context, state) => BlocProvider<AuthBloc>.value(
                  value: mockAuthBloc,
                  child: RegisterPage(),
                ),
          ),
          GoRoute(
            path: '/OTP',
            builder:
                (context, state) => OtpForm(
                  key: const Key('otp_form'),
                  email: state.extra as String? ?? 'user@gmail.com',
                ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      // Fill form
      await tester.enterText(find.byKey(const Key('name_field')), 'Test User');
      await tester.enterText(
        find.byKey(const Key('birthdate_field')),
        '01-01-2000',
      );
      await tester.enterText(
        find.byKey(const Key('phone_field')),
        '08123456789',
      );
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // Tap checkbox
      await tester.ensureVisible(
        find.byKey(const Key('newsletter_checkbox_input')),
      );
      await tester.tap(find.byKey(const Key('newsletter_checkbox_input')));
      await tester.pump();

      // Tap register button
      await tester.ensureVisible(find.byKey(const Key('register_button')));
      await tester.tap(
        find.byKey(const Key('register_button')),
        warnIfMissed: false,
      );
      await tester.pump();

      // Emit success state
      controller.add(AuthRegisterSuccess());
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.byKey(const Key('otp_form')), findsOneWidget);

      await controller.close();
    });
  });
}
