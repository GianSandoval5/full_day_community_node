import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import '../../features/profile/data/firebase_profile_repository.dart';
import '../../features/profile/data/personal_profile_data_source.dart';
import '../../features/profile/domain/profile_repository.dart';

abstract final class PersonalFirebase {
  static Future<ProfileRepository> connect() async {
    // WORKSHOP STEP 05: [DEFAULT] is the attendee's personal Firebase.
    final app = Firebase.apps.isEmpty
        ? await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          )
        : Firebase.app();

    final auth = FirebaseAuth.instanceFor(app: app);
    final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
    if (user == null) {
      throw StateError('Firebase did not return a personal user.');
    }

    return FirebaseProfileRepository(
      PersonalProfileDataSource(FirebaseFirestore.instanceFor(app: app)),
      userId: user.uid,
    );
  }
}
