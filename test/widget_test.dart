import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nutri_app_project/main.dart';

void main() {
  testWidgets('NutriViverApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NutriViverApp());

    // Verify that our app builds successfully.
    expect(find.byType(NutriViverApp), findsOneWidget);
  });
}

