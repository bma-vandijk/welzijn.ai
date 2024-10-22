import 'package:flutter/material.dart';

/// Navigationbar button
/// Specifies layout for the buttons in the navigation abr
/// File path: lib/src/components/navbutton.dart
class NavButton extends StatelessWidget {
  final bool selected;
  final String selectedImagePath;
  final String unSelectedImagePath;
  final String label;
  final VoidCallback onTap; // Specified by parent
  const NavButton({
    super.key,
    required this.selected,
    required this.selectedImagePath,
    required this.unSelectedImagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child:
                Image.asset(selected ? selectedImagePath : unSelectedImagePath),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: selected
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface)
                  : TextStyle(color: Theme.of(context).colorScheme.surface)),
        ],
      ),
    );
  }
}
