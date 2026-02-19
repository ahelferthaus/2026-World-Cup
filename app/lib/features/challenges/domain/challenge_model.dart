import 'challenge_category.dart';

/// Status progression for a P2P challenge.
enum ChallengeStatus {
  pending,
  accepted,
  declined,
  awaitingOutcome,
  disputed,
  settled,
  expired;

  static ChallengeStatus fromString(String value) => switch (value) {
        'pending' => pending,
        'accepted' => accepted,
        'declined' => declined,
        'awaitingOutcome' || 'awaiting_outcome' => awaitingOutcome,
        'disputed' => disputed,
        'settled' => settled,
        'expired' => expired,
        _ => pending,
      };
}

/// Outcome of a resolved challenge.
enum ChallengeOutcome {
  fromWins,
  toWins,
  push;

  static ChallengeOutcome? fromString(String? value) => switch (value) {
        'fromWins' || 'from_wins' => fromWins,
        'toWins' || 'to_wins' => toWins,
        'push' => push,
        _ => null,
      };
}

/// A single P2P challenge between two users.
class ChallengeModel {
  final String id;
  final String fromUid;
  final String fromName;
  final String toUid;
  final String toName;
  final ChallengeCategory category;
  final String title;
  final String? matchId;
  final int wager;
  final ChallengeStatus status;
  final ChallengeOutcome? outcome;
  final bool fromConfirmed;
  final bool toConfirmed;
  final bool isSettledOffline; // 18+ settlement tracking
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const ChallengeModel({
    required this.id,
    required this.fromUid,
    required this.fromName,
    required this.toUid,
    required this.toName,
    required this.category,
    required this.title,
    this.matchId,
    required this.wager,
    required this.status,
    this.outcome,
    this.fromConfirmed = false,
    this.toConfirmed = false,
    this.isSettledOffline = false,
    required this.createdAt,
    this.resolvedAt,
  });

  // -----------------------------------------------------------------------
  // Factory constructors
  // -----------------------------------------------------------------------
  factory ChallengeModel.fromDemo(Map<String, dynamic> data) {
    return ChallengeModel(
      id: data['id'] as String,
      fromUid: data['fromUid'] as String,
      fromName: data['fromName'] as String,
      toUid: data['toUid'] as String,
      toName: data['toName'] as String,
      category: ChallengeCategory.fromString(data['category'] as String),
      title: data['title'] as String,
      matchId: data['matchId'] as String?,
      wager: data['wager'] as int,
      status: ChallengeStatus.fromString(data['status'] as String),
      outcome: ChallengeOutcome.fromString(data['outcome'] as String?),
      fromConfirmed: data['fromConfirmed'] as bool? ?? false,
      toConfirmed: data['toConfirmed'] as bool? ?? false,
      isSettledOffline: data['isSettledOffline'] as bool? ?? false,
      createdAt: data['createdAt'] is DateTime
          ? data['createdAt'] as DateTime
          : DateTime.parse(data['createdAt'] as String),
      resolvedAt: data['resolvedAt'] != null
          ? (data['resolvedAt'] is DateTime
              ? data['resolvedAt'] as DateTime
              : DateTime.parse(data['resolvedAt'] as String))
          : null,
    );
  }

  factory ChallengeModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ChallengeModel(
      id: id,
      fromUid: data['fromUid'] as String,
      fromName: data['fromName'] as String,
      toUid: data['toUid'] as String,
      toName: data['toName'] as String,
      category: ChallengeCategory.fromString(data['category'] as String),
      title: data['title'] as String,
      matchId: data['matchId'] as String?,
      wager: data['wager'] as int,
      status: ChallengeStatus.fromString(data['status'] as String),
      outcome: ChallengeOutcome.fromString(data['outcome'] as String?),
      fromConfirmed: data['fromConfirmed'] as bool? ?? false,
      toConfirmed: data['toConfirmed'] as bool? ?? false,
      isSettledOffline: data['isSettledOffline'] as bool? ?? false,
      createdAt: DateTime.parse(data['createdAt'] as String),
      resolvedAt: data['resolvedAt'] != null
          ? DateTime.parse(data['resolvedAt'] as String)
          : null,
    );
  }

  // -----------------------------------------------------------------------
  // Computed getters
  // -----------------------------------------------------------------------
  bool get isCustom => category == ChallengeCategory.custom;
  bool get isPartyGame => category == ChallengeCategory.partyGame;
  bool get isSports => category == ChallengeCategory.sports;
  bool get isPending => status == ChallengeStatus.pending;
  bool get isActive =>
      status == ChallengeStatus.accepted ||
      status == ChallengeStatus.awaitingOutcome;
  bool get isResolved => status == ChallengeStatus.settled;
  bool get isDisputed => status == ChallengeStatus.disputed;

  /// Whether this user needs to confirm the outcome.
  bool needsMyConfirmation(String uid) {
    if (status != ChallengeStatus.awaitingOutcome) return false;
    if (uid == fromUid) return !fromConfirmed;
    if (uid == toUid) return !toConfirmed;
    return false;
  }

  /// The uid of the winner, or null if unresolved/push.
  String? get winnerUid => switch (outcome) {
        ChallengeOutcome.fromWins => fromUid,
        ChallengeOutcome.toWins => toUid,
        _ => null,
      };

  /// Whether the given user won this challenge.
  bool didWin(String uid) => winnerUid == uid;

  /// Whether the given user lost this challenge.
  bool didLose(String uid) =>
      outcome != null &&
      outcome != ChallengeOutcome.push &&
      winnerUid != uid &&
      (uid == fromUid || uid == toUid);

  /// Get the opponent name for a given user.
  String opponentName(String uid) => uid == fromUid ? toName : fromName;

  /// Get the opponent uid for a given user.
  String opponentUid(String uid) => uid == fromUid ? toUid : fromUid;

  /// Whether the given user initiated this challenge.
  bool isMine(String uid) => fromUid == uid;

  /// Copy with updated fields.
  ChallengeModel copyWith({
    ChallengeStatus? status,
    ChallengeOutcome? outcome,
    bool? fromConfirmed,
    bool? toConfirmed,
    bool? isSettledOffline,
    DateTime? resolvedAt,
  }) {
    return ChallengeModel(
      id: id,
      fromUid: fromUid,
      fromName: fromName,
      toUid: toUid,
      toName: toName,
      category: category,
      title: title,
      matchId: matchId,
      wager: wager,
      status: status ?? this.status,
      outcome: outcome ?? this.outcome,
      fromConfirmed: fromConfirmed ?? this.fromConfirmed,
      toConfirmed: toConfirmed ?? this.toConfirmed,
      isSettledOffline: isSettledOffline ?? this.isSettledOffline,
      createdAt: createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
