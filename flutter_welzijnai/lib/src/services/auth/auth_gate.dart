import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:welzijnai/src/services/auth/login_or_register.dart';
import 'package:welzijnai/src/pages/chat.dart';

/// Authentication gate
/// Show chatpage if the user is logged in, otherwise show
/// either the login or the sign-up page
/// Filepath: lib/src/services/auth/auth_gate.dart

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const ChatPage();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
