import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart'; // Replace with your project name

void main() {
  testWidgets('Home page shows welcome message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(),
      ),
    );

    // Check if "Welcome to BookBuddy!" text is present
    expect(find.text('Welcome to BookBuddy!'), findsOneWidget);
  });
}
