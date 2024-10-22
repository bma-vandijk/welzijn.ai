import 'package:flutter/material.dart';
import 'package:welzijnai/src/pages/login.dart';
import 'package:welzijnai/src/pages/register.dart';

/// Toggle between the login and the register page
/// Filepath: lib/src/services/auth/login_or_register.dart
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;
  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
