// This is a basic Flutter widget test for the SFMC example app.
//
// It mocks the plugin's method channel so the example app can be
// built inside the test binding without a real platform implementation,
// then verifies that the demo UI renders without throwing.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sfmc_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('sfmc');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'isAnalyticsEnabled':
          case 'isPiAnalyticsEnabled':
            return false;
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('Example app builds and shows the SFMC demo UI',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: MyApp()));
    await tester.pumpAndSettle();

    // Verify the app rendered without throwing.
    expect(tester.takeException(), isNull);

    // Verify the SFMC demo UI is shown.
    expect(find.text('SFMC Flutter SDK Example'), findsOneWidget);
    expect(find.text('GET SYSTEM TOKEN'), findsOneWidget);
  });
}
