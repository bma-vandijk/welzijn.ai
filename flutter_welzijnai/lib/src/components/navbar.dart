import 'package:flutter/material.dart';
import 'package:welzijnai/src/components/navbutton.dart';
import 'package:welzijnai/src/pages/chat.dart';
import 'package:welzijnai/src/pages/history.dart';
import 'package:welzijnai/src/pages/settings.dart';

/// Bottom navigation bar
/// Provides the overview of the pages and the navigation to 3 pages:
/// to the chatpage, the history page and the settings page
/// Filepath: lib/src/components/navbar.dart
class NavBar extends StatefulWidget {
  // selected[0] is the chatpage, selected[1] the history page and
  // selected[2] is the settingspage. True if selected, false if not
  final List<bool> selected;

  const NavBar({
    super.key,
    required this.selected,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  void onItemTapped(dynamic page, BuildContext context) {
    // Navigate to the correct page
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 80,
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavButton(
            selected: widget.selected[0],
            selectedImagePath: "assets/images/messages_selected.png",
            unSelectedImagePath: "assets/images/messages_unselected.png",
            label: "Chat",
            onTap: () {
              onItemTapped(const ChatPage(), context);
            },
          ),
          NavButton(
            selected: widget.selected[1],
            selectedImagePath: "assets/images/history_selected.png",
            unSelectedImagePath: "assets/images/history_unselected.png",
            label: "Geschiedenis",
            onTap: () {
              onItemTapped(const HistoryPage(), context);
            },
          ),
          NavButton(
            selected: widget.selected[2],
            selectedImagePath: "assets/images/settings_selected.png",
            unSelectedImagePath: "assets/images/settings_unselected.png",
            label: "Instellingen",
            onTap: () {
              onItemTapped(const SettingsPage(), context);
            },
          )
        ],
      ),
    );
  }
}
