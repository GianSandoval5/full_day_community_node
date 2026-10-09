import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/profile.dart';
import '../domain/profile_repository.dart';
import 'personal_profile_data_source.dart';

class FirebaseProfileRepository implements ProfileRepository {
  FirebaseProfileRepository(this._dataSource, {required this.userId});

  @override
  final String userId;

  final PersonalProfileDataSource _dataSource;

  @override
  Stream<Profile?> watchProfile() {
    return _dataSource.watchProfile(userId).map((data) {
      if (data == null) return null;
      return Profile(
        uid: _string(data['uid'], fallback: userId),
        name: _string(data['name']),
        role: _string(data['role']),
        community: _string(data['community']),
        bio: _string(data['bio']),
        createdAt: _dateTime(data['createdAt']),
        updatedAt: _dateTime(data['updatedAt']),
      );
    });
  }

  @override
  Future<void> saveProfile(Profile profile) {
    return _dataSource.saveProfile(
      uid: userId,
      name: profile.name,
      role: profile.role,
      community: profile.community,
      bio: profile.bio,
    );
  }

  String _string(Object? value, {String fallback = ''}) {
    return value is String ? value : fallback;
  }

  DateTime? _dateTime(Object? value) {
    return value is Timestamp ? value.toDate() : null;
  }
}
