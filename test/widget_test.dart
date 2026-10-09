import 'package:flutter_test/flutter_test.dart';
import 'package:full_day_community_node/app/app.dart';
import 'package:full_day_community_node/features/community/domain/community_message.dart';
import 'package:full_day_community_node/features/community/domain/community_repository.dart';
import 'package:full_day_community_node/features/profile/domain/profile.dart';
import 'package:full_day_community_node/features/profile/domain/profile_repository.dart';

void main() {
  testWidgets('renders My Space from injected capabilities', (tester) async {
    await tester.pumpWidget(
      CommunityNodeApp(
        profileRepository: _FakeProfileRepository(),
        communityRepository: _FakeCommunityRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MY COMMUNITY NODE'), findsOneWidget);
    expect(find.text('My Space'), findsOneWidget);
    expect(find.text('Configure your node'), findsOneWidget);
  });
}

class _FakeProfileRepository implements ProfileRepository {
  @override
  String get userId => 'personal-user';

  @override
  Future<void> saveProfile(Profile profile) async {}

  @override
  Stream<Profile?> watchProfile() => Stream.value(null);
}

class _FakeCommunityRepository implements CommunityRepository {
  @override
  Future<void> join(Profile profile) async {}

  @override
  Future<void> sendMessage(String text) async {}

  @override
  Stream<List<CommunityMessage>> watchMessages({int limit = 50}) {
    return Stream.value(const []);
  }

  @override
  Stream<int> watchParticipantsCount() => Stream.value(0);
}
