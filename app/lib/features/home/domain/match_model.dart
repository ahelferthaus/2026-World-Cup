import 'team_model.dart';

class MatchModel {
  final int fixtureId;
  final String kickoff;
  final String status;
  final String statusLong;
  final int? elapsed;
  final TeamModel homeTeam;
  final TeamModel awayTeam;
  final int? scoreHome;
  final int? scoreAway;

  const MatchModel({
    required this.fixtureId,
    required this.kickoff,
    required this.status,
    required this.statusLong,
    this.elapsed,
    required this.homeTeam,
    required this.awayTeam,
    this.scoreHome,
    this.scoreAway,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      fixtureId: json['fixtureId'] as int,
      kickoff: json['kickoff'] as String,
      status: json['status'] as String,
      statusLong: json['statusLong'] as String,
      elapsed: json['elapsed'] as int?,
      homeTeam: TeamModel.fromJson(json['homeTeam'] as Map<String, dynamic>),
      awayTeam: TeamModel.fromJson(json['awayTeam'] as Map<String, dynamic>),
      scoreHome: json['score']?['home'] as int?,
      scoreAway: json['score']?['away'] as int?,
    );
  }

  bool get isUpcoming => status == 'NS';
  bool get isLive => ['1H', '2H', 'HT', 'ET'].contains(status);
  bool get isFinished => ['FT', 'AET', 'PEN'].contains(status);
}
