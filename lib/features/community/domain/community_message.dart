class CommunityMessage {
  const CommunityMessage({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.authorCommunity,
    required this.text,
    this.createdAt,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String authorCommunity;
  final String text;
  final DateTime? createdAt;

  @override
  bool operator ==(Object other) {
    return other is CommunityMessage &&
        other.id == id &&
        other.authorId == authorId &&
        other.authorName == authorName &&
        other.authorRole == authorRole &&
        other.authorCommunity == authorCommunity &&
        other.text == text &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    authorId,
    authorName,
    authorRole,
    authorCommunity,
    text,
    createdAt,
  );
}
