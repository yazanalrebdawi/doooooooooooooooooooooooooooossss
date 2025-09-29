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
  });
}
