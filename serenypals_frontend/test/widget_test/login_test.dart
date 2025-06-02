import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:serenypals_frontend/main.dart' as app;

Future<void> scrollToAndTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder, warnIfMissed: false);
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Page - Full UI & Validation Test', () {
    testWidgets('Semua elemen login muncul dengan lengkap', (tester) async {
      app.main(initialRoute: '/login');
      await tester.pumpAndSettle();

      expect(find.text('SerenyPals'), findsOneWidget);
      expect(find.byKey(const Key('masuk_text')), findsOneWidget);

      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);

      final richText = tester.widget<RichText>(
        find.byKey(const Key('register_navigation')),
      );
      expect(richText.text.toPlainText(), contains('Daftar'));
    });

    testWidgets('Validasi field kosong saat login', (tester) async {
      app.main(initialRoute: '/login');
      await tester.pumpAndSettle();

      await scrollToAndTap(tester, find.byKey(const Key('login_button')));

      expect(find.text('Email wajib diisi'), findsOneWidget);
      expect(find.text('Password wajib diisi'), findsOneWidget);
    });

    testWidgets('Validasi format email salah', (tester) async {
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

      await scrollToAndTap(tester, find.byKey(const Key('login_button')));

      expect(find.textContaining('Gunakan format email'), findsOneWidget);
    });

    testWidgets('Login sukses dan navigasi ke splash screen lalu dashboard', (
      tester,
    ) async {
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

      // Tap tombol login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump(); // Render frame navigasi ke SplashScreen

      await tester.pump(const Duration(seconds: 1)); // Tunggu animasi berjalan
      expect(find.byKey(const Key('splash_screen')), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('dashboard')), findsOneWidget);
    });
  });
}
