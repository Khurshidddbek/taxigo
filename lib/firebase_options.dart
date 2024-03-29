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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHrHjULBK-V354VmFlqVUIl1NZLKrd6EA',
    appId: '1:258910643577:android:937dc8ca13115af74b7ba8',
    messagingSenderId: '258910643577',
    projectId: 'taxigo-c63b1',
    databaseURL: 'https://taxigo-c63b1-default-rtdb.firebaseio.com',
    storageBucket: 'taxigo-c63b1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2hwKcHegYXVE0Pmy8PW4LIVMEEvM_unw',
    appId: '1:258910643577:ios:00885b5cd8436b0d4b7ba8',
    messagingSenderId: '258910643577',
    projectId: 'taxigo-c63b1',
    databaseURL: 'https://taxigo-c63b1-default-rtdb.firebaseio.com',
    storageBucket: 'taxigo-c63b1.appspot.com',
    iosClientId:
        '258910643577-1nncph86g681kugeb5j4unch44d97bvj.apps.googleusercontent.com',
    iosBundleId: 'com.gotaxi.taxigo.taxigo',
  );
}
