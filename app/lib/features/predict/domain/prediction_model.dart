class PredictionModel {
  final String id;
  final String uid;
  final String matchId;
  final String type;
  final String selection;
  final int? scoreHome;
  final int? scoreAway;
  final int wager;
  final String status;
  final int payout;
  final DateTime createdAt;

  const PredictionModel({
    required this.id,
    required this.uid,
    required this.matchId,
    required this.type,
    required this.selection,
    this.scoreHome,
    this.scoreAway,
    required this.wager,
    required this.status,
    required this.payout,
    required this.createdAt,
  });

  factory PredictionModel.fromFirestore(String id, Map<String, dynamic> data) {
    return PredictionModel(
      id: id,
      uid: data['uid'] as String,
      matchId: data['matchId'] as String,
      type: data['type'] as String,
      selection: data['selection'] as String,
      scoreHome: data['scoreHome'] as int?,
      scoreAway: data['scoreAway'] as int?,
      wager: data['wager'] as int,
      status: data['status'] as String,
      payout: data['payout'] as int? ?? 0,
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  factory PredictionModel.fromDemo(Map<String, dynamic> data) {
    return PredictionModel(
      id: data['id'] as String,
      uid: data['uid'] as String,
      matchId: data['matchId'] as String,
      type: data['type'] as String,
      selection: data['selection'] as String,
      wager: data['wager'] as int,
      status: data['status'] as String,
      payout: data['payout'] as int? ?? 0,
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }

  bool get isPending => status == 'pending';
  bool get isWon => status == 'won';
  bool get isLost => status == 'lost';

  String get selectionLabel {
    if (type == 'exactScore') {
      return '$scoreHome - $scoreAway';
    }
    switch (selection) {
      case 'home':
        return 'Home Win';
      case 'away':
        return 'Away Win';
      case 'draw':
        return 'Draw';
      default:
        return selection;
    }
  }
}
