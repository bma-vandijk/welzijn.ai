import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:welzijnai/src/pages/login.dart';

void main() {
  testWidgets('LoginPage Golden test', (WidgetTester tester) async {
    // Define the widget
    final widget = MaterialApp(
      home: LoginPage(onTap: () {}),
    );

    // Build the widget
    await tester.pumpWidget(widget);

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    //await expectLater(find.byType(LoginPage),
      //matchesGoldenFile('goldens/login_page.png'));

    // Verify if the widget matches the snapshot
    try {
      await expectLater(find.byType(LoginPage), 
        matchesGoldenFile('goldens/login_page.png'));
    } catch (e) {
      // Log the error if comparison fails
      //print("Golden file comparison failed: $e"); //comment this line to hide the explanation of the error
      rethrow;
    }
  });
}