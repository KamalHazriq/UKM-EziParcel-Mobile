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
    apiKey: 'AIzaSyDlBxlMczWA0u2rO8kFY7S6fRNjvrBK-jE',
    appId: '1:409550515516:android:5809ca5884e0ac3d028239',
    messagingSenderId: '409550515516',
    projectId: 'ukm-eziparcel-c71bc',
    databaseURL: 'https://ukm-eziparcel-c71bc-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ukm-eziparcel-c71bc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFdcz_UTolJl0ZQ6utNfsC54qgnSiixwI',
    appId: '1:409550515516:ios:1b95ff3593212fc4028239',
    messagingSenderId: '409550515516',
    projectId: 'ukm-eziparcel-c71bc',
    databaseURL: 'https://ukm-eziparcel-c71bc-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ukm-eziparcel-c71bc.appspot.com',
    iosBundleId: 'com.example.eziparcelMobile',
  );
}