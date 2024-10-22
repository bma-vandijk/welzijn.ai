import "package:flutter/material.dart";

/// Rectangle containing text or other data
/// Filepath: lib/src/components/text_bubble.dart

class TextBubble extends StatelessWidget {
  final Color color;
  final VoidCallback onTap; // Specified by parent
  final dynamic child;

  const TextBubble({
    super.key,
    required this.color,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(19))),
        child: child,
      ),
    );
  }
}
