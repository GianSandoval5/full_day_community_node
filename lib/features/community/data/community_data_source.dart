import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityDataSource {
  CommunityDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> join({
    required String uid,
    required String name,
    required String role,
    required String community,
  }) async {
    final reference = _firestore.collection('participants').doc(uid);
    final current = await reference.get();
    await reference.set({
      'uid': uid,
      'name': name.trim(),
      'role': role.trim(),
      'community': community.trim(),
      'joinedAt': current.data()?['joinedAt'] ?? FieldValue.serverTimestamp(),
      'lastSeenAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<CommunityDocument>> watchMessages({required int limit}) {
    return _firestore
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (document) =>
                    CommunityDocument(id: document.id, data: document.data()),
              )
              .toList(growable: false),
        );
  }

  Stream<int> watchParticipantsCount() {
    return _firestore
        .collection('participants')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Future<void> sendMessage({
    required String authorId,
    required String authorName,
    required String authorRole,
    required String authorCommunity,
    required String text,
  }) async {
    final reference = _firestore.collection('messages').doc();
    await reference.set({
      'id': reference.id,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'authorCommunity': authorCommunity,
      'text': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

class CommunityDocument {
  const CommunityDocument({required this.id, required this.data});

  final String id;
  final Map<String, dynamic> data;
}
