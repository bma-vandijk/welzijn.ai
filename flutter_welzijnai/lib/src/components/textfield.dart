import 'package:flutter/material.dart';

/// Textfield
/// Custom input fields for text used in the forms
/// Filepath: lib/src/components/textfield.dart
class LoginTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText; // Hide the input text with dots
  final TextEditingController controller;
  final FocusNode? focusNode;
  const LoginTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
    );
  }
}
