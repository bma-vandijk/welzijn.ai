// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVgmW9723miLQfKo0KApp8Vg2nlARHHFI',
    appId: '1:115948612340:android:2c2393dccf5e4f4024cca1',
    messagingSenderId: '115948612340',
    projectId: 'welzijnai-faa46',
    storageBucket: 'welzijnai-faa46.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDWEr21EkK-VMnrTUd9UWgBA-loVFJDRoQ',
    appId: '1:115948612340:ios:98e086103c7b524924cca1',
    messagingSenderId: '115948612340',
    projectId: 'welzijnai-faa46',
    storageBucket: 'welzijnai-faa46.appspot.com',
    iosBundleId: 'com.example.welzijnai',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAED0X5ChNG5LVPOP-e2a7wvlbIcrNrD-g',
    appId: '1:115948612340:web:cd034cf3f254eaaf24cca1',
    messagingSenderId: '115948612340',
    projectId: 'welzijnai-faa46',
    authDomain: 'welzijnai-faa46.firebaseapp.com',
    storageBucket: 'welzijnai-faa46.appspot.com',
    measurementId: 'G-8RNCWTP6VT',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDWEr21EkK-VMnrTUd9UWgBA-loVFJDRoQ',
    appId: '1:115948612340:ios:98e086103c7b524924cca1',
    messagingSenderId: '115948612340',
    projectId: 'welzijnai-faa46',
    storageBucket: 'welzijnai-faa46.appspot.com',
    iosBundleId: 'com.example.welzijnai',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAED0X5ChNG5LVPOP-e2a7wvlbIcrNrD-g',
    appId: '1:115948612340:web:bce0194f5eecfd5924cca1',
    messagingSenderId: '115948612340',
    projectId: 'welzijnai-faa46',
    authDomain: 'welzijnai-faa46.firebaseapp.com',
    storageBucket: 'welzijnai-faa46.appspot.com',
    measurementId: 'G-9RM2TGQTSZ',
  );

}