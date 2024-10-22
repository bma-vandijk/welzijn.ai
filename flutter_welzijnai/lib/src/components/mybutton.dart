import 'package:flutter/material.dart';

/// uttons for login and register page
/// File path: lib/src/components/mybutton.dart

class MyButton extends StatelessWidget {
  final void Function()? onPressed; // Callback function defined by parent
  final String text;

  const MyButton({
    super.key,
    this.text = '',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
