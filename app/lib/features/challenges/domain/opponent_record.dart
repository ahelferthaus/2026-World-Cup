/// Head-to-head record against a specific opponent.
class OpponentRecord {
  final String opponentUid;
  final String opponentName;
  final int wins;
  final int losses;
  final int pushes;
  final int tokensWon;
  final int tokensLost;
  final String currentStreakType; // 'W' or 'L' or ''
  final int currentStreakCount;
  final int unsettledAmount; // 18+ only — net tokens owed/owed-to
  final DateTime lastBetAt;

  const OpponentRecord({
    required this.opponentUid,
    required this.opponentName,
    required this.wins,
    required this.losses,
    this.pushes = 0,
    required this.tokensWon,
    required this.tokensLost,
    this.currentStreakType = '',
    this.currentStreakCount = 0,
    this.unsettledAmount = 0,
    required this.lastBetAt,
  });

  factory OpponentRecord.fromDemo(Map<String, dynamic> data) {
    return OpponentRecord(
      opponentUid: data['opponentUid'] as String,
      opponentName: data['opponentName'] as String,
      wins: data['wins'] as int,
      losses: data['losses'] as int,
      pushes: data['pushes'] as int? ?? 0,
      tokensWon: data['tokensWon'] as int,
      tokensLost: data['tokensLost'] as int,
      currentStreakType: data['currentStreakType'] as String? ?? '',
      currentStreakCount: data['currentStreakCount'] as int? ?? 0,
      unsettledAmount: data['unsettledAmount'] as int? ?? 0,
      lastBetAt: data['lastBetAt'] is DateTime
          ? data['lastBetAt'] as DateTime
          : DateTime.parse(data['lastBetAt'] as String),
    );
  }

  // -----------------------------------------------------------------------
  // Computed getters
  // -----------------------------------------------------------------------
  int get totalBets => wins + losses + pushes;
  int get netTokens => tokensWon - tokensLost;

  double get winRate => totalBets == 0 ? 0.0 : wins / totalBets;

  /// Boldness = average wager size relative to total wagered.
  /// Higher boldness = larger average bets.
  double get boldnessScore {
    if (totalBets == 0) return 0.0;
    final totalWagered = tokensWon + tokensLost;
    return totalWagered / totalBets;
  }

  bool get isOnWinStreak => currentStreakType == 'W' && currentStreakCount > 0;
  bool get isOnLossStreak => currentStreakType == 'L' && currentStreakCount > 0;

  String get streakDisplay {
    if (currentStreakCount == 0) return '-';
    return '$currentStreakType$currentStreakCount';
  }

  String get recordDisplay => '$wins-$losses${pushes > 0 ? '-$pushes' : ''}';
}
