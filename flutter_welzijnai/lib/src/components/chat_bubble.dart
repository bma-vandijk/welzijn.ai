import "package:flutter/material.dart";

/// Chatbubble component
/// Provides layout for the text messages sent to and by the user
/// File path: lib/src/components/chat_bubble.dart
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser; // The user and the chatbot will have a different colour
  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        // Set maximum width to half of the screen width
        maxWidth: MediaQuery.of(context).size.width / 2,
      ),
      padding: isUser
          ? const EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10)
          : const EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: isUser
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.secondary,
        borderRadius: isUser
            ? const BorderRadius.only(
                topLeft: Radius.circular(19),
                bottomLeft: Radius.circular(19),
                topRight: Radius.circular(19))
            : const BorderRadius.only(
                topLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
                topRight: Radius.circular(19)),
      ),
      child: Text(message),
    );
  }
}
