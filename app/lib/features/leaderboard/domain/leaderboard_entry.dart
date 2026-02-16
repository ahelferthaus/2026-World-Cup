class LeaderboardEntry {
  final int rank;
  final String uid;
  final String displayName;
  final String school;
  final int tokens;

  const LeaderboardEntry({
    required this.rank,
    required this.uid,
    required this.displayName,
    required this.school,
    required this.tokens,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      school: json['school'] as String,
      tokens: json['tokens'] as int,
    );
  }
}
