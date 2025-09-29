<<<<<<< HEAD
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
  
import 'package:dooss_business_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SimpleReelsApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
=======
import 'package:dooss_business_app/core/models/enums/app_them_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dooss_business_app/main.dart';

void main() {
  testWidgets('App loads with initial light theme', (
    WidgetTester tester,
  ) async {
    // Build the app with light theme
    await tester.pumpWidget(
      const SimpleReelsApp(initialTheme: AppThemeEnum.light),
    );

    // Trigger a frame
    await tester.pumpAndSettle();

    // Verify MaterialApp is present
    expect(find.byType(MaterialApp), findsOneWidget);

    // Optional: Check if theme is light by finding a widget with light background
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme, isNotNull);
>>>>>>> zoz
  });
}
