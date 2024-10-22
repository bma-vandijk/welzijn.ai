import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';
import 'package:welzijnai/src/services/setings/settingsprovider.dart';
import 'package:welzijnai/src/themes/light.dart';
import 'package:welzijnai/firebase_options.dart';
import 'src/services/auth/auth_gate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Main
/// Shows the first page that needs to be visible
/// Filepath: lib/main.dart3
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  await Settings.init(cacheProvider: SharePreferenceCache());
  runApp(ChangeNotifierProvider(
    create: (context) => SettingsProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightMode,
    );
  }
}
