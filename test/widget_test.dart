import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrovedham/core/services/local_storage_service.dart';
import 'package:astrovedham/main.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.instance.init();
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('App launches and builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ta')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const AstroVedhamApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(AstroVedhamApp), findsOneWidget);
  });
}
