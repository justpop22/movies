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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCzrXRuscuoeA71AIiqN7_PmdsMY4RIPOY',
    appId: '1:935304448442:web:6a122df943c3d013ca7583',
    messagingSenderId: '935304448442',
    projectId: 'movies-b17e8',
    authDomain: 'movies-b17e8.firebaseapp.com',
    storageBucket: 'movies-b17e8.firebasestorage.app',
    measurementId: 'G-V7JYH1MHRL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1BXYJsvqLdTPQIta1TkCCu8glGDt4JmM',
    appId: '1:935304448442:android:488bcc39c2aad46dca7583',
    messagingSenderId: '935304448442',
    projectId: 'movies-b17e8',
    storageBucket: 'movies-b17e8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCY-eaeXkG-lvMfUmXlQ8zeBygY8OdkImo',
    appId: '1:935304448442:ios:e822804dab842500ca7583',
    messagingSenderId: '935304448442',
    projectId: 'movies-b17e8',
    storageBucket: 'movies-b17e8.firebasestorage.app',
    iosBundleId: 'com.example.movies',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCY-eaeXkG-lvMfUmXlQ8zeBygY8OdkImo',
    appId: '1:935304448442:ios:e822804dab842500ca7583',
    messagingSenderId: '935304448442',
    projectId: 'movies-b17e8',
    storageBucket: 'movies-b17e8.firebasestorage.app',
    iosBundleId: 'com.example.movies',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCzrXRuscuoeA71AIiqN7_PmdsMY4RIPOY',
    appId: '1:935304448442:web:28da2afd6355110bca7583',
    messagingSenderId: '935304448442',
    projectId: 'movies-b17e8',
    authDomain: 'movies-b17e8.firebaseapp.com',
    storageBucket: 'movies-b17e8.firebasestorage.app',
    measurementId: 'G-X5SLX5SDM9',
  );
}
