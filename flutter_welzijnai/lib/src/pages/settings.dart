import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welzijnai/src/components/navbar.dart';
import 'package:welzijnai/src/components/text_bubble.dart';
import 'package:welzijnai/src/services/auth/auth_gate.dart';
import 'package:welzijnai/src/services/auth/auth_service.dart';
import 'package:welzijnai/src/services/setings/settingsprovider.dart';

/// Settings page
/// Provides options to log out and to set the input mode for conversations
/// File path: lib/src/pages/history.dart

class SettingsPage extends StatefulWidget {
  static const chatModeKey = "chatModeKey";
  const SettingsPage({super.key});
  static const routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// Options for input modes
enum ChatMode { text, speech, textAndSpeech }

class _SettingsPageState extends State<SettingsPage> {
  ChatMode? chatmode = ChatMode.text;

  // Sign out using the auth service
  // File path: lib/src/services/auth/auth_service.dart
  void logout(BuildContext context) {
    final auth = AuthService();
    auth.signOut();

    // After signing out, show the login page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AuthGate(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Center(
          child: Text("Instellingen"),
        ),
        shape: const Border(bottom: BorderSide(width: 1)),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 10),
            buildLogout(context),
            const SizedBox(height: 10),
            buildChatMode(context),
            const SizedBox(height: 10),
            buildDebug(context),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(selected: [false, false, true]),
    );
  }

  Widget buildDebug(BuildContext context) {
    return TextBubble(
      onTap: () {},
      color: Theme.of(context).colorScheme.secondary,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: SizedBox(
              height: 25,
              width: 25,
              child: Image.asset("assets/images/debuginfo.png"),
            ),
          ),
          const Text(
            "Debugmodus",
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: Container(),
          ),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Switch(
                    value: settings.selectedDebug,
                    onChanged: (value) {
                      settings.selectedDebug = value;
                    }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildLogout(BuildContext context) {
    return TextBubble(
      onTap: () => logout(context),
      color: Theme.of(context).colorScheme.secondary,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: SizedBox(
              height: 25,
              width: 25,
              child: Image.asset("assets/images/logout.png"),
            ),
          ),
          const Text(
            style: TextStyle(fontSize: 18),
            "Uitloggen",
          ),
        ],
      ),
    );
  }

  // Input options in list of radio buttons
  Widget buildChatMode(BuildContext context) {
    return TextBubble(
      color: Theme.of(context).colorScheme.secondary,
      onTap: () {},
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 23, top: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset("assets/images/chatmode.png"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    style: TextStyle(fontSize: 18),
                    "Chat Modus",
                  ),
                ],
              ),
            ),
          ),
          _buildChatModeListItem(context, "Tekst", ChatMode.text),
          _buildChatModeListItem(context, "Spraak", ChatMode.speech),
          _buildChatModeListItem(
              context, "Tekst en spraak", ChatMode.textAndSpeech),
        ],
      ),
    );
  }

  // Provides the functionality of selecting a chatmode
  // Set the state, so that the proper icons an functionalities
  // are visible on the chatpage
  // Provides layout for radio buttons (size and whitespace)
  Widget _buildChatModeListItem(
      BuildContext context, String text, ChatMode value) {
    var chatModeProvider = Provider.of<SettingsProvider>(context);
    var scale = 1.0; // Size of radiobutton

    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        title: Text(text),
        leading: Transform.scale(
          scale: scale,
          child: Radio<ChatMode>(
            value: value,
            groupValue: chatModeProvider.selectedChatMode,
            onChanged: (ChatMode? value) {
              setState(() {
                if (value != null) {
                  chatModeProvider.selectedChatMode = value;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
