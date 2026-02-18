class AppUser {
  final String uid;
  final String displayName;
  final String school;
  final String state;
  final String grade;
  final int tokens;
  final int totalWagered;
  final int totalWon;
  final int predictionsCount;
  final int predictionsWon;
  final DateTime? createdAt;

  const AppUser({
    required this.uid,
    required this.displayName,
    required this.school,
    this.state = '',
    this.grade = '',
    required this.tokens,
    this.totalWagered = 0,
    this.totalWon = 0,
    this.predictionsCount = 0,
    this.predictionsWon = 0,
    this.createdAt,
  });

  double get winRate =>
      predictionsCount > 0 ? predictionsWon / predictionsCount * 100 : 0;

  /// "Biggest cajones" score: average wager size relative to total tokens.
  /// Higher = more aggressive bettor.
  double get boldnessScore =>
      predictionsCount > 0 && tokens > 0
          ? (totalWagered / predictionsCount) / tokens * 100
          : 0;

  factory AppUser.fromFirestore(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      displayName: data['displayName'] as String? ?? 'Player',
      school: data['school'] as String? ?? '',
      state: data['state'] as String? ?? '',
      grade: data['grade'] as String? ?? '',
      tokens: data['tokens'] as int? ?? 0,
      totalWagered: data['totalWagered'] as int? ?? 0,
      totalWon: data['totalWon'] as int? ?? 0,
      predictionsCount: data['predictionsCount'] as int? ?? 0,
      predictionsWon: data['predictionsWon'] as int? ?? 0,
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  factory AppUser.fromDemo(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] as String,
      displayName: data['displayName'] as String,
      school: data['school'] as String? ?? '',
      state: data['state'] as String? ?? 'Colorado',
      grade: data['grade'] as String? ?? 'Junior (11th)',
      tokens: data['tokens'] as int? ?? 0,
      totalWagered: data['totalWagered'] as int? ?? 245,
      totalWon: data['totalWon'] as int? ?? 180,
      predictionsCount: data['predictionsCount'] as int? ?? 12,
      predictionsWon: data['predictionsWon'] as int? ?? 7,
    );
  }
}
