import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:welzijnai/src/components/mybutton.dart';
import 'package:welzijnai/src/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:welzijnai/src/services/auth/auth_service.dart';

/// Login page
/// Shows the textfields for email and passwords
/// Link to register page
/// File path: lib/src/pages/login.dart

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Function executing the toggle to the register page, specified in lib\src\services\auth
  final void Function()? onTap;

  static const routeName = '/login';

  // Login with FireBase
  void login(BuildContext context) async {
    // Service handling authentication, specified in
    // File path: lib/src/services/auth/auth_service.dart
    final authService = AuthService();
    try {
      await authService.signInWithEmailAndPassword(
          _emailController.text.trim(), _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Logger().e(e);
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
                "Welkom!",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Log in met uw e-mailadres en wachtwoord.",
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
              height: 20,
            ),

            // Login button
            Align(
                alignment: Alignment.center,
                child: MyButton(
                  text: 'Log in',
                  onPressed: () => login(context),
                )),

            // Reference to register page
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Nog geen account?"),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      " Meld u hier aan.",
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
