// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vivi_bday_app/main.dart';

void main() {
  // Test login page widgets
  testWidgets('Login page button, email and password user information', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that button is found
    expect(find.byType(MaterialButton), findsOneWidget);

    // Verify that email text form field is found
    // Enter text to be verified later
    expect(find.byKey(Key('emailtextformfield')), findsOneWidget);
    expect(find.byKey(Key('passwordtextformfield')), findsOneWidget);
    await tester.pump();
    await tester.enterText(find.byKey(Key('emailtextformfield')), "a@a.com");
    await tester.enterText(find.byKey(Key('passwordtextformfield')), "aaaaaa");
    await tester.pump();

    // Verify that the email and password were entered for login
    expect(find.text("a@a.com"), findsOneWidget); 
    expect(find.text("aaaaaa"), findsOneWidget); 
  });
}
