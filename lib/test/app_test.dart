import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app integration test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Verify Home screen
    expect(find.text('Welcome to BookBuddy!'), findsOneWidget);

    // Navigate to Search page
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    // Search for a book
    await tester.enterText(find.byType(TextField), 'Harry Potter');
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Verify search results
    expect(find.textContaining('Harry Potter'), findsWidgets);

    // Navigate to Add Book page and add a book
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key('bookTitle')), 'Test Book');
    await tester.enterText(find.byKey(Key('bookAuthor')), 'Author Name');
    await tester.tap(find.text('Add Book'));
    await tester.pumpAndSettle();

    // Verify book is added
    expect(find.text('Test Book'), findsOneWidget);
  });
}
