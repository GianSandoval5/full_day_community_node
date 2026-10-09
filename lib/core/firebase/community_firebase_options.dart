// This file intentionally lives apart from firebase_options.dart.
// Running `flutterfire configure` for an attendee's personal project must not
// overwrite the shared Community Hub configuration.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

abstract final class CommunityFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => throw UnsupportedError(
        'Register com.example.full_day_community_node as an Android app in '
        'the Hub project, then add its options to CommunityFirebaseOptions.',
      ),
      TargetPlatform.iOS => throw UnsupportedError(
        'Register com.example.fullDayCommunityNode as an iOS app in the Hub '
        'project, then add its options to CommunityFirebaseOptions.',
      ),
      _ => throw UnsupportedError(
        'The Community Hub is configured for Web, Android, and iOS.',
      ),
    };
  }

  static const web = FirebaseOptions(
    apiKey: 'AIzaSyB5We87jn0PKYQIEjz78cGHYWFG6cHUkh4',
    appId: '1:813547703892:web:f676cec8da30f13069e7c1',
    messagingSenderId: '813547703892',
    projectId: 'full-day-comunnity-hub',
    authDomain: 'full-day-comunnity-hub.firebaseapp.com',
    storageBucket: 'full-day-comunnity-hub.firebasestorage.app',
    measurementId: 'G-Z63QH9XPV0',
  );
}
