// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC3ADLycGsmCICMGtDX-_90_sXZlTz_XQc',
    appId: '1:700284481883:web:f32eb069f6b8b20225ea7e',
    messagingSenderId: '700284481883',
    projectId: 'medical-mind',
    authDomain: 'medical-mind.firebaseapp.com',
    storageBucket: 'medical-mind.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfjVNKsqcy1K3JjPmE2A2SVsPamv7HBzI',
    appId: '1:700284481883:android:2e9d031d7a1805d525ea7e',
    messagingSenderId: '700284481883',
    projectId: 'medical-mind',
    storageBucket: 'medical-mind.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAhAK__2dq5Ir5LLgsx7kouWBTjb9r9HIo',
    appId: '1:700284481883:ios:9b38f62e739fded325ea7e',
    messagingSenderId: '700284481883',
    projectId: 'medical-mind',
    storageBucket: 'medical-mind.appspot.com',
    iosClientId:
        '700284481883-7ahgdfdspipfr8g2kapnr5pf8vs65d6o.apps.googleusercontent.com',
    iosBundleId: 'com.example.medical',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAhAK__2dq5Ir5LLgsx7kouWBTjb9r9HIo',
    appId: '1:700284481883:ios:9b38f62e739fded325ea7e',
    messagingSenderId: '700284481883',
    projectId: 'medical-mind',
    storageBucket: 'medical-mind.appspot.com',
    iosClientId:
        '700284481883-7ahgdfdspipfr8g2kapnr5pf8vs65d6o.apps.googleusercontent.com',
    iosBundleId: 'com.example.medical',
  );
}
