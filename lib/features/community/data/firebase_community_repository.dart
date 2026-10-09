import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/community_firebase.dart';
import '../../profile/domain/profile.dart';
import '../domain/community_message.dart';
import '../domain/community_repository.dart';
import 'community_data_source.dart';

class FirebaseCommunityRepository implements CommunityRepository {
  FirebaseCommunityRepository(this._communityFirebase);

  final CommunityFirebase _communityFirebase;

  CommunityDataSource? _dataSource;
  String? _communityUid;
  Profile? _profile;

  @override
  Future<void> join(Profile profile) async {
    final connection = await _communityFirebase.connect();
    final dataSource = CommunityDataSource(connection.firestore);

    // WORKSHOP STEP 12: copy identity across Firebase projects, not UIDs.
    await dataSource.join(
      uid: connection.user.uid,
      name: profile.name,
      role: profile.role,
      community: profile.community,
    );

    _communityUid = connection.user.uid;
    _profile = profile;
    _dataSource = dataSource;
  }

  @override
  Stream<List<CommunityMessage>> watchMessages({int limit = 50}) {
    return _connectedDataSource
        .watchMessages(limit: limit)
        .map((documents) => documents.map(_messageFromDocument).toList());
  }

  @override
  Stream<int> watchParticipantsCount() {
    return _connectedDataSource.watchParticipantsCount();
  }

  @override
  Future<void> sendMessage(String text) {
    final profile = _profile;
    final uid = _communityUid;
    if (profile == null || uid == null) {
      throw StateError('Join the Community before sending messages.');
    }
    final normalized = text.trim();
    if (normalized.isEmpty || normalized.length > 280) {
      throw ArgumentError.value(
        text,
        'text',
        'Use between 1 and 280 characters.',
      );
    }

    return _connectedDataSource.sendMessage(
      authorId: uid,
      authorName: profile.name,
      authorRole: profile.role,
      authorCommunity: profile.community,
      text: normalized,
    );
  }

  CommunityDataSource get _connectedDataSource {
    return _dataSource ??
        (throw StateError('Join the Community before reading its data.'));
  }

  CommunityMessage _messageFromDocument(CommunityDocument document) {
    final data = document.data;
    return CommunityMessage(
      id: _string(data['id'], fallback: document.id),
      authorId: _string(data['authorId']),
      authorName: _string(data['authorName'], fallback: 'Anonymous node'),
      authorRole: _string(data['authorRole'], fallback: 'Flutter Developer'),
      authorCommunity: _string(data['authorCommunity'], fallback: 'Community'),
      text: _string(data['text']),
      createdAt: _dateTime(data['createdAt']),
    );
  }

  String _string(Object? value, {String fallback = ''}) {
    return value is String && value.trim().isNotEmpty ? value : fallback;
  }

  DateTime? _dateTime(Object? value) {
    return value is Timestamp ? value.toDate() : null;
  }
}
