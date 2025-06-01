import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:serenypals_frontend/main.dart' as app;

// Fungsi bantu scroll ke widget dan tap tanpa warning hit-test
Future<void> scrollToAndTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();

  // Tap tombol dengan suppress warning supaya tidak muncul warning hit-test
  await tester.tap(finder, warnIfMissed: false);
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Register Page - Full UI & Validation Test', () {
    testWidgets('Semua elemen muncul dengan lengkap', (tester) async {
      app.main(initialRoute: '/register');
      await tester.pumpAndSettle();

      expect(find.text('SerenyPals'), findsOneWidget);
      expect(find.text('Daftarkan Akun'), findsOneWidget);

      expect(find.byKey(const Key('name_field')), findsOneWidget);
      expect(find.byKey(const Key('birthdate_field')), findsOneWidget);
      expect(find.byKey(const Key('phone_field')), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('newsletter_checkbox')), findsOneWidget);
      expect(find.byKey(const Key('register_button')), findsOneWidget);

      final richText = tester.widget<RichText>(
        find.byKey(const Key('login_navigation')),
      );
      expect(richText.text.toPlainText(), contains('Masuk'));
    });

    testWidgets('Validasi ketika field kosong', (tester) async {
      app.main(initialRoute: '/register');
      await tester.pumpAndSettle();

      await scrollToAndTap(tester, find.byKey(const Key('register_button')));

      expect(find.text('Nama wajib diisi'), findsOneWidget);
      expect(find.text('Tanggal Lahir wajib diisi'), findsOneWidget);
      expect(find.text('No. Telepon wajib diisi'), findsOneWidget);
      expect(find.text('Email wajib diisi'), findsOneWidget);
      expect(find.text('Password wajib diisi'), findsOneWidget);
    });

    testWidgets('Validasi format email salah', (tester) async {
      app.main(initialRoute: '/register');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'fanny@yahoo.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      await scrollToAndTap(tester, find.byKey(const Key('register_button')));

      expect(find.textContaining('Gunakan format email'), findsOneWidget);
    });

    testWidgets('Validasi nomor telepon salah', (tester) async {
      app.main(initialRoute: '/register');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('phone_field')), '0812-abc');

      await scrollToAndTap(tester, find.byKey(const Key('register_button')));

      expect(find.text('No. Telepon hanya boleh angka'), findsOneWidget);
    });

    testWidgets('Register sukses (navigasi ke OTP)', (tester) async {
      app.main(initialRoute: '/register');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('name_field')), 'Fanny');
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
        'fanny@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      await scrollToAndTap(tester, find.byKey(const Key('register_button')));

      expect(find.byKey(const Key('otp_screen')), findsOneWidget);
    });
  });

  testWidgets('OTP screen muncul dengan benar', (tester) async {
    app.main(initialRoute: '/OTP');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('otp_screen')), findsOneWidget);
  });
}
