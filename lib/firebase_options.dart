// Settings for the Firebase project `family-habits-77d62`, in the format
// `flutterfire configure` writes. Android is connected; other platforms throw
// and the app runs with in-memory accounts and the demo family until they are
// added. These values identify the project and are not secrets: access is
// controlled by firestore.rules.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError(
      'Firebase is not configured for this platform yet. '
      'Run `flutterfire configure` to add it.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACEjWDOw7kg-YbRf_v9L0Z-XgeW1oHFHE',
    appId: '1:988310827185:android:5cef4ea859f18b39fcb290',
    messagingSenderId: '988310827185',
    projectId: 'family-habits-77d62',
    storageBucket: 'family-habits-77d62.firebasestorage.app',
  );
}
