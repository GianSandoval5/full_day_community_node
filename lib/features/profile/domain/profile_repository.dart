import 'profile.dart';

abstract interface class ProfileRepository {
  String get userId;

  Stream<Profile?> watchProfile();

  Future<void> saveProfile(Profile profile);
}
