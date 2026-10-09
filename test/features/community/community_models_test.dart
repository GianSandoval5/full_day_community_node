import 'package:flutter_test/flutter_test.dart';
import 'package:full_day_community_node/features/community/domain/community_message.dart';
import 'package:full_day_community_node/features/profile/domain/profile.dart';

void main() {
  test('Profile uses value equality', () {
    const first = Profile(
      uid: 'personal-user',
      name: 'Gian',
      role: 'Mobile Architect',
      community: 'Flutter Piura',
      bio: 'Building software and community.',
    );
    const second = Profile(
      uid: 'personal-user',
      name: 'Gian',
      role: 'Mobile Architect',
      community: 'Flutter Piura',
      bio: 'Building software and community.',
    );

    expect(first, second);
  });

  test('CommunityMessage uses value equality', () {
    const first = CommunityMessage(
      id: 'message-1',
      authorId: 'community-user',
      authorName: 'Gian',
      authorRole: 'Mobile Architect',
      authorCommunity: 'Flutter Piura',
      text: 'Hola Full Day 🚀',
    );
    const second = CommunityMessage(
      id: 'message-1',
      authorId: 'community-user',
      authorName: 'Gian',
      authorRole: 'Mobile Architect',
      authorCommunity: 'Flutter Piura',
      text: 'Hola Full Day 🚀',
    );

    expect(first, second);
  });
}
