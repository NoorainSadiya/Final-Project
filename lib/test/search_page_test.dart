import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../pages/search_page.dart';

void main() {
  testWidgets('Search Page shows search bar and handles empty state',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SearchPage()));

    // Verify search bar
    expect(find.byType(TextField), findsOneWidget);

    // Check empty state message
    expect(find.text('No results found.'), findsOneWidget);
  });
}
