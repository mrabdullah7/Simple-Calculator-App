import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterproject/main.dart';

void main() {
  testWidgets('Calculator app test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const CalculatorApp());

    // Verify that our calculator starts with '0'
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '1' button and verify the output
    await tester.tap(find.text('1'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    // Tap the '+' button
    await tester.tap(find.text('+'));
    await tester.pump();

    // Tap the '2' button
    await tester.tap(find.text('2'));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    // Tap the '=' button and verify the result
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('3'), findsOneWidget);
  });
}