import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalProfileDataSource {
  PersonalProfileDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<Map<String, dynamic>?> watchProfile(String uid) {
    return _firestore
        .collection('profiles')
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  Future<void> saveProfile({
    required String uid,
    required String name,
    required String role,
    required String community,
    required String bio,
  }) async {
    final reference = _firestore.collection('profiles').doc(uid);
    final current = await reference.get();

    await reference.set({
      'uid': uid,
      'name': name.trim(),
      'role': role.trim(),
      'community': community.trim(),
      'bio': bio.trim(),
      'createdAt': current.data()?['createdAt'] ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
