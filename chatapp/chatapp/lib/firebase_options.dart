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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBeEj3wpuGyglWQfv0YB45TeOHWZScCZv0',
    appId: '1:147095519971:web:fb7fed8f0aff0799a83bd6',
    messagingSenderId: '147095519971',
    projectId: 'chatapp-aa755',
    authDomain: 'chatapp-aa755.firebaseapp.com',
    storageBucket: 'chatapp-aa755.appspot.com',
    measurementId: 'G-V5Q0Q09EL7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIQn0QdjJAdht-z85ki4_hNxhz-SXIiRU',
    appId: '1:147095519971:android:cbd73b8ca8d70befa83bd6',
    messagingSenderId: '147095519971',
    projectId: 'chatapp-aa755',
    storageBucket: 'chatapp-aa755.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-G1p-w1_az0sRAq29BPuldN1_5Q44bO0',
    appId: '1:147095519971:ios:ae2484a65155e67ca83bd6',
    messagingSenderId: '147095519971',
    projectId: 'chatapp-aa755',
    storageBucket: 'chatapp-aa755.appspot.com',
    iosBundleId: 'com.example.dialogue1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-G1p-w1_az0sRAq29BPuldN1_5Q44bO0',
    appId: '1:147095519971:ios:db6a2df542b34387a83bd6',
    messagingSenderId: '147095519971',
    projectId: 'chatapp-aa755',
    storageBucket: 'chatapp-aa755.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBeEj3wpuGyglWQfv0YB45TeOHWZScCZv0',
    appId: '1:147095519971:web:975cd1bdf1609ed1a83bd6',
    messagingSenderId: '147095519971',
    projectId: 'chatapp-aa755',
    authDomain: 'chatapp-aa755.firebaseapp.com',
    storageBucket: 'chatapp-aa755.appspot.com',
    measurementId: 'G-L4Y6EEZHVL',
  );
}
