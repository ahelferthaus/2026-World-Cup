class LeaderboardEntry {
  final int rank;
  final String uid;
  final String displayName;
  final String school;
  final String state;
  final int tokens;
  final double winRate;
  final double boldness;

  const LeaderboardEntry({
    required this.rank,
    required this.uid,
    required this.displayName,
    required this.school,
    this.state = '',
    required this.tokens,
    this.winRate = 0,
    this.boldness = 0,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      school: json['school'] as String,
      state: json['state'] as String? ?? '',
      tokens: json['tokens'] as int,
      winRate: (json['winRate'] as num?)?.toDouble() ?? 0,
      boldness: (json['boldness'] as num?)?.toDouble() ?? 0,
    );
  }
}

class AggregateEntry {
  final int rank;
  final String name;
  final int totalTokens;
  final double avgWinRate;
  final double avgBoldness;
  final int playerCount;
  final int? schoolCount;

  const AggregateEntry({
    required this.rank,
    required this.name,
    required this.totalTokens,
    required this.avgWinRate,
    required this.avgBoldness,
    required this.playerCount,
    this.schoolCount,
  });

  factory AggregateEntry.fromJson(Map<String, dynamic> json) {
    return AggregateEntry(
      rank: json['rank'] as int,
      name: (json['name'] ?? json['school'] ?? json['state']) as String,
      totalTokens: json['totalTokens'] as int,
      avgWinRate: (json['avgWinRate'] as num).toDouble(),
      avgBoldness: (json['avgBoldness'] as num).toDouble(),
      playerCount: json['playerCount'] as int,
      schoolCount: json['schoolCount'] as int?,
    );
  }
}
