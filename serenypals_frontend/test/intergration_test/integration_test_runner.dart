import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:serenypals_frontend/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Page - Basic Validation Test', () {
    testWidgets('Form muncul dengan lengkap', (tester) async {
      app.main(initialRoute: '/login');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('login_button')), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
    });

    testWidgets('Validasi ketika field kosong', (tester) async {
      app.main(initialRoute: '/login');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Email wajib diisi'), findsOneWidget);
      expect(find.text('Password wajib diisi'), findsOneWidget);
    });

    testWidgets('Validasi email salah format', (tester) async {
      app.main(initialRoute: '/login');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'fanny@outlook.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Gunakan format email'), findsOneWidget);
    });

    testWidgets('Login sukses (navigasi diuji jika bisa)', (tester) async {
      app.main(initialRoute: '/login');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'fanny@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('splash_screen')), findsOneWidget);
    });
  });
}
