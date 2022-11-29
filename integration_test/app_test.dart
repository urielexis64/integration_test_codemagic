import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:resocoder/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "Not inputting a text and wanting to go to the display page shows "
    "an error and prevents from going to the display page.",
    (WidgetTester tester) async {
      // Testing starts at the root widget in the widget tree
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byType(FloatingActionButton));
      // Wait for all the animations to finish
      await tester.pumpAndSettle();

      expect(find.byType(TypingPage), findsOneWidget);
      expect(find.byType(DisplayPage), findsNothing);
      // This is the text displayed by an error message on the TextFormField
      expect(find.text('Input at least one character'), findsOneWidget);
    },
  );

  testWidgets(
    "After inputting a text, go to the display page which contains that same text "
    "and then navigate back to the typing page where the input should be clear",
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Input this text
      const inputText = 'Hello there, this is an input.';
      await tester.enterText(
          find.byKey(const Key('your-text-field')), inputText);

      // Tap on a FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // We should be in the DisplayPage that displays the inputted text
      expect(find.byType(TypingPage), findsNothing);
      expect(find.byType(DisplayPage), findsOneWidget);
      expect(find.text(inputText), findsOneWidget);

      // Tap on the back arrow in the AppBar
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // We should be back in the TypingPage and the previously inputted text
      // should be cleared out
      expect(find.byType(TypingPage), findsOneWidget);
      expect(find.byType(DisplayPage), findsNothing);
      expect(find.text(inputText), findsNothing);
    },
  );
}
