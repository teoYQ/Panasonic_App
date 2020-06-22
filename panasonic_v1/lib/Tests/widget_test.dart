// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:panasonic_v1/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);

    expect(find.text('1'), findsNothing);
    final Finder email = find.widgetWithText(TextFormField, 'Email');
    
    final Finder pw = find.widgetWithText(TextFormField, 'Password');
    await tester.enterText(email, 'yongquan13s105@gmail.com');
    await tester.enterText(pw, '123456');

    await tester.tap(find.text("Log In"));
    await tester.pump();

    expect(find.text("Welcome"),findsOneWidget);
    // Tap the '+' icon and trigger a frame.
/*SIGN UP CHECK
    await tester.tap(find.text("Sign Up"));
    //expect(find.byIcon(Icons.camera_alt), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsNWidgets(3));*/
    /*await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
*/
    // Verify that our counter has incremented.
    /*expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);*/
  });
}
