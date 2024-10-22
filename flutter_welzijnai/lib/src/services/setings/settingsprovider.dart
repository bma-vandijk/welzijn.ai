import 'package:flutter/material.dart';
import 'package:welzijnai/src/pages/settings.dart';

/// Settings provider
/// Notifies the chatpage if the mode of input has changed
/// Filepath: lib/src/services/setings/settingsprovider.dart

class SettingsProvider with ChangeNotifier {
  ChatMode _selectedChatMode = ChatMode.text;
  bool _selectedDebug = false;

  bool get selectedDebug => _selectedDebug;
  set selectedDebug(bool mode) {
    _selectedDebug = mode;
    notifyListeners();
  }

  ChatMode get selectedChatMode => _selectedChatMode;
  set selectedChatMode(ChatMode mode) {
    _selectedChatMode = mode;
    notifyListeners();
  }
}
