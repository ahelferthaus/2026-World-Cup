import 'team_model.dart';

class GroupStanding {
  final String name;
  final List<GroupTeamEntry> teams;

  const GroupStanding({required this.name, required this.teams});

  factory GroupStanding.fromJson(Map<String, dynamic> json) {
    return GroupStanding(
      name: json['name'] as String,
      teams: (json['teams'] as List)
          .map((t) => GroupTeamEntry.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GroupTeamEntry {
  final int rank;
  final TeamModel team;
  final int points;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDiff;

  const GroupTeamEntry({
    required this.rank,
    required this.team,
    required this.points,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDiff,
  });

  factory GroupTeamEntry.fromJson(Map<String, dynamic> json) {
    return GroupTeamEntry(
      rank: json['rank'] as int,
      team: TeamModel.fromJson(json['team'] as Map<String, dynamic>),
      points: json['points'] as int,
      played: json['played'] as int,
      won: json['won'] as int,
      drawn: json['drawn'] as int,
      lost: json['lost'] as int,
      goalsFor: json['goalsFor'] as int,
      goalsAgainst: json['goalsAgainst'] as int,
      goalDiff: json['goalDiff'] as int,
    );
  }
}
