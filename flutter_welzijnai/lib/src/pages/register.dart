import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:welzijnai/src/components/mybutton.dart';
import 'package:welzijnai/src/components/textfield.dart';
import 'package:welzijnai/src/services/auth/auth_service.dart';

/// Register page
/// Creates a new account in the database (Firebase/Firestore)
/// The user inputs their email and password and confirms their password.
/// Provides link to toggle back to the login page
/// File path: lib/src/pages/register.dart
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Function executing the toggle to the register page, specified in
  // File path: lib/src/services/auth/auth_service.dart
  final void Function()? onTap;
  static const routeName = '/register';

  // Register using Firebase
  void register(BuildContext context) async {
    final authService = AuthService();
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        authService.signUpWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
      } catch (e) {
        if (!context.mounted) return;
        Logger().e(e);
      }
    } else {
      if (!context.mounted) return;
      Logger().e("Wachtwoorden komen niet overeen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),

            // Instructions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Maak een account aan.",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Voer uw e-mail adres in en kies een wachtwoord.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // Enter email
            LoginTextField(
              hintText: 'E-mail',
              controller: _emailController,
            ),
            const SizedBox(
              height: 10,
            ),

            // Enter password
            LoginTextField(
              hintText: 'Wachtwoord',
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(
              height: 10,
            ),

            // Confirm password
            LoginTextField(
              hintText: 'Bevestig wachtwoord',
              obscureText: true,
              controller: _confirmPasswordController,
            ),
            const SizedBox(
              height: 20,
            ),

            // Sign up
            Align(
                alignment: Alignment.center,
                child: MyButton(
                  text: 'Meld aan',
                  onPressed: () => register(context),
                )),

            // Back to login page
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Heeft u al een account?"),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      " Log hier in.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
