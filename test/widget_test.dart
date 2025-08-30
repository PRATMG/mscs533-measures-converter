// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:measures_converter/app.dart';

void main() {
  testWidgets('App loads ConverterPage with expected UI', (tester) async {
    // Build the app
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Navbar title (you renamed it to "Measures Converter")
    expect(find.text('Measures Converter'), findsOneWidget);

    // Segmented control labels should be present
    expect(find.text('Length'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('Temp'), findsOneWidget);

    // The "Convert" primary button should be visible
    expect(find.text('Convert'), findsOneWidget);
  });
}

