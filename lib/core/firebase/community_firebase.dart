import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'community_firebase_options.dart';

class CommunityFirebase {
  static const appName = 'community';

  Future<CommunityFirebaseConnection> connect() async {
    // WORKSHOP STEP 10: this app coexists with [DEFAULT].
    final existing = Firebase.apps.where((app) => app.name == appName);
    final app = existing.isNotEmpty
        ? existing.first
        : await Firebase.initializeApp(
            name: appName,
            options: CommunityFirebaseOptions.currentPlatform,
          );

    final auth = FirebaseAuth.instanceFor(app: app);
    final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
    if (user == null) {
      throw StateError('Firebase did not return a Community user.');
    }

    return CommunityFirebaseConnection(
      user: user,
      firestore: FirebaseFirestore.instanceFor(app: app),
    );
  }
}

class CommunityFirebaseConnection {
  const CommunityFirebaseConnection({
    required this.user,
    required this.firestore,
  });

  final User user;
  final FirebaseFirestore firestore;
}
