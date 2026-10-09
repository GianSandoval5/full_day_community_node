class Profile {
  const Profile({
    required this.uid,
    required this.name,
    required this.role,
    required this.community,
    required this.bio,
    this.createdAt,
    this.updatedAt,
  });

  final String uid;
  final String name;
  final String role;
  final String community;
  final String bio;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  bool operator ==(Object other) {
    return other is Profile &&
        other.uid == uid &&
        other.name == name &&
        other.role == role &&
        other.community == community &&
        other.bio == bio &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      Object.hash(uid, name, role, community, bio, createdAt, updatedAt);
}
