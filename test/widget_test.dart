import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_day_community_node/app/app.dart';
import 'package:full_day_community_node/features/community/domain/community_message.dart';
import 'package:full_day_community_node/features/community/domain/community_repository.dart';
import 'package:full_day_community_node/features/profile/domain/profile.dart';
import 'package:full_day_community_node/features/profile/domain/profile_repository.dart';
import 'package:full_day_community_node/features/profile/presentation/profile_screen.dart';
import 'package:full_day_community_node/features/profile/presentation/widgets/profile_form.dart';

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

  testWidgets('hides the keyboard when tapping outside the form', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ProfileScreen(repository: _FakeProfileRepository())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile-name-field')));
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.tap(find.text('Configure your node'));
    await tester.pump();
    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('locks a saved profile and enables explicit editing', (
    tester,
  ) async {
    Profile? savedProfile;
    const existingProfile = Profile(
      uid: 'personal-user',
      name: 'Ada',
      role: 'Flutter developer',
      community: 'Full Day',
      bio: 'Building a community node.',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProfileForm(
              userId: 'personal-user',
              profile: existingProfile,
              onSave: (profile) async => savedProfile = profile,
            ),
          ),
        ),
      ),
    );

    EditableText nameField() => tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(const Key('profile-name-field')),
        matching: find.byType(EditableText),
      ),
    );

    expect(nameField().readOnly, isTrue);
    expect(find.byKey(const Key('profile-edit-button')), findsOneWidget);
    expect(find.byKey(const Key('profile-save-button')), findsNothing);

    await tester.tap(find.byKey(const Key('profile-edit-button')));
    await tester.pump();

    expect(nameField().readOnly, isFalse);
    await tester.tap(find.byKey(const Key('profile-name-field')));
    await tester.enterText(
      find.byKey(const Key('profile-name-field')),
      'Ada Lovelace',
    );
    expect(tester.testTextInput.isVisible, isTrue);

    final saveButton = find.byKey(const Key('profile-save-button'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pump(const Duration(milliseconds: 250));

    expect(savedProfile?.name, 'Ada Lovelace');
    expect(nameField().readOnly, isTrue);
    expect(tester.testTextInput.isVisible, isFalse);
    expect(find.byKey(const Key('profile-edit-button')), findsOneWidget);
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
