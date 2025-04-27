import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodapp/screens/SignInSignUpPage.dart'; // Import your SignInSignUpPage
import 'package:moodapp/main.dart'; // Import your main.dart if you want to test the full app flow

void main() {
  testWidgets('Verify SignInSignUpPage is the first screen displayed', (WidgetTester tester) async {
    // Build the widget tree with the app's starting page
    await tester.pumpWidget(MyApp()); // Removed 'const' because MyApp is not a const constructor

    // Verify that the SignInSignUpPage is shown
    expect(find.text('Sign In'), findsOneWidget); // Check if the "Sign In" text is present (assuming you have this text in your SignInSignUpPage)

    // Now, let's simulate user interaction by entering email and password
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com'); // Email field
    await tester.enterText(find.byType(TextField).at(1), 'password123'); // Password field
    await tester.tap(find.byType(ElevatedButton)); // Tap the sign-in button
    await tester.pumpAndSettle(); // Wait for the navigation to complete

    // Verify that we have navigated to the next screen (WelcomeScreen)
    expect(find.text('Welcome'), findsOneWidget); // Assuming 'Welcome' is displayed in your WelcomeScreen
  });
}
