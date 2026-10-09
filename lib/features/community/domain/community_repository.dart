import '../../profile/domain/profile.dart';
import 'community_message.dart';

abstract interface class CommunityRepository {
  Future<void> join(Profile profile);

  Stream<List<CommunityMessage>> watchMessages({int limit = 50});

  Stream<int> watchParticipantsCount();

  Future<void> sendMessage(String text);
}
