class AppUser {
  final String uid;
  final String displayName;
  final String school;
  final int tokens;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.displayName,
    required this.school,
    required this.tokens,
    required this.createdAt,
  });

  factory AppUser.fromFirestore(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      displayName: data['displayName'] as String? ?? 'Player',
      school: data['school'] as String? ?? 'Centaurus High School',
      tokens: data['tokens'] as int? ?? 0,
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }
}
