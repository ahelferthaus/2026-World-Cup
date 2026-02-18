// Demo/mock data for testing the app without a live backend.
// Toggle useDemoData to switch between real API and demo mode.

const bool useDemoData = true;

class DemoData {
  DemoData._();

  static List<Map<String, dynamic>> get matches => [
    {
      'id': 1001,
      'homeTeam': {'name': 'United States', 'logo': 'https://media.api-sports.io/football/teams/2384.png'},
      'awayTeam': {'name': 'Mexico', 'logo': 'https://media.api-sports.io/football/teams/2385.png'},
      'homeScore': 2,
      'awayScore': 1,
      'status': '2H',
      'elapsed': 67,
      'kickoff': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
    },
    {
      'id': 1002,
      'homeTeam': {'name': 'Brazil', 'logo': 'https://media.api-sports.io/football/teams/6.png'},
      'awayTeam': {'name': 'Argentina', 'logo': 'https://media.api-sports.io/football/teams/26.png'},
      'homeScore': 0,
      'awayScore': 0,
      'status': '1H',
      'elapsed': 23,
      'kickoff': DateTime.now().subtract(const Duration(minutes: 23)).toIso8601String(),
    },
    {
      'id': 1003,
      'homeTeam': {'name': 'England', 'logo': 'https://media.api-sports.io/football/teams/10.png'},
      'awayTeam': {'name': 'Germany', 'logo': 'https://media.api-sports.io/football/teams/25.png'},
      'homeScore': null,
      'awayScore': null,
      'status': 'NS',
      'elapsed': null,
      'kickoff': DateTime.now().add(const Duration(hours: 3)).toIso8601String(),
    },
    {
      'id': 1004,
      'homeTeam': {'name': 'France', 'logo': 'https://media.api-sports.io/football/teams/2.png'},
      'awayTeam': {'name': 'Spain', 'logo': 'https://media.api-sports.io/football/teams/9.png'},
      'homeScore': null,
      'awayScore': null,
      'status': 'NS',
      'elapsed': null,
      'kickoff': DateTime.now().add(const Duration(hours: 6)).toIso8601String(),
    },
    {
      'id': 1005,
      'homeTeam': {'name': 'Japan', 'logo': 'https://media.api-sports.io/football/teams/12.png'},
      'awayTeam': {'name': 'South Korea', 'logo': 'https://media.api-sports.io/football/teams/17.png'},
      'homeScore': null,
      'awayScore': null,
      'status': 'NS',
      'elapsed': null,
      'kickoff': DateTime.now().add(const Duration(hours: 9)).toIso8601String(),
    },
    {
      'id': 1006,
      'homeTeam': {'name': 'Portugal', 'logo': 'https://media.api-sports.io/football/teams/27.png'},
      'awayTeam': {'name': 'Netherlands', 'logo': 'https://media.api-sports.io/football/teams/1118.png'},
      'homeScore': 3,
      'awayScore': 1,
      'status': 'FT',
      'elapsed': 90,
      'kickoff': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
    },
    {
      'id': 1007,
      'homeTeam': {'name': 'Canada', 'logo': 'https://media.api-sports.io/football/teams/5529.png'},
      'awayTeam': {'name': 'Colombia', 'logo': 'https://media.api-sports.io/football/teams/1066.png'},
      'homeScore': 0,
      'awayScore': 2,
      'status': 'FT',
      'elapsed': 90,
      'kickoff': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
    },
  ];

  static List<Map<String, dynamic>> get standings => [
    {
      'name': 'Group A',
      'teams': [
        _team('United States', 'https://media.api-sports.io/football/teams/2384.png', 1, 3, 2, 1, 0, 5, 1, 7),
        _team('Mexico', 'https://media.api-sports.io/football/teams/2385.png', 2, 3, 2, 0, 1, 4, 3, 6),
        _team('Colombia', 'https://media.api-sports.io/football/teams/1066.png', 3, 3, 1, 0, 2, 2, 4, 3),
        _team('Morocco', 'https://media.api-sports.io/football/teams/31.png', 4, 3, 0, 1, 2, 1, 4, 1),
      ],
    },
    {
      'name': 'Group B',
      'teams': [
        _team('Brazil', 'https://media.api-sports.io/football/teams/6.png', 1, 3, 3, 0, 0, 7, 1, 9),
        _team('England', 'https://media.api-sports.io/football/teams/10.png', 2, 3, 2, 0, 1, 4, 2, 6),
        _team('Japan', 'https://media.api-sports.io/football/teams/12.png', 3, 3, 1, 0, 2, 3, 5, 3),
        _team('Canada', 'https://media.api-sports.io/football/teams/5529.png', 4, 3, 0, 0, 3, 0, 6, 0),
      ],
    },
    {
      'name': 'Group C',
      'teams': [
        _team('France', 'https://media.api-sports.io/football/teams/2.png', 1, 3, 2, 1, 0, 6, 2, 7),
        _team('Argentina', 'https://media.api-sports.io/football/teams/26.png', 2, 3, 2, 0, 1, 5, 3, 6),
        _team('Germany', 'https://media.api-sports.io/football/teams/25.png', 3, 3, 1, 1, 1, 4, 4, 4),
        _team('South Korea', 'https://media.api-sports.io/football/teams/17.png', 4, 3, 0, 0, 3, 1, 7, 0),
      ],
    },
    {
      'name': 'Group D',
      'teams': [
        _team('Spain', 'https://media.api-sports.io/football/teams/9.png', 1, 3, 3, 0, 0, 8, 1, 9),
        _team('Portugal', 'https://media.api-sports.io/football/teams/27.png', 2, 3, 1, 1, 1, 4, 3, 4),
        _team('Netherlands', 'https://media.api-sports.io/football/teams/1118.png', 3, 3, 1, 0, 2, 3, 5, 3),
        _team('Saudi Arabia', 'https://media.api-sports.io/football/teams/23.png', 4, 3, 0, 1, 2, 2, 8, 1),
      ],
    },
  ];

  static Map<String, dynamic> _team(String name, String logo, int rank, int played, int won, int drawn, int lost, int goalsFor, int goalsAgainst, int points) => {
    'rank': rank,
    'team': {'name': name, 'logo': logo},
    'played': played,
    'won': won,
    'drawn': drawn,
    'lost': lost,
    'goalsFor': goalsFor,
    'goalsAgainst': goalsAgainst,
    'goalDiff': goalsFor - goalsAgainst,
    'points': points,
  };

  static List<Map<String, dynamic>> get leaderboardGlobal => [
    {'uid': 'demo_1', 'displayName': 'SoccerKing99', 'school': 'Centaurus High School', 'tokens': 487, 'rank': 1},
    {'uid': 'demo_2', 'displayName': 'GoalMaster', 'school': 'Fairview High School', 'tokens': 412, 'rank': 2},
    {'uid': 'demo_3', 'displayName': 'PredictPro', 'school': 'Centaurus High School', 'tokens': 385, 'rank': 3},
    {'uid': 'demo_user', 'displayName': 'You', 'school': 'Centaurus High School', 'tokens': 320, 'rank': 4},
    {'uid': 'demo_5', 'displayName': 'FutbolFan', 'school': 'Boulder High School', 'tokens': 298, 'rank': 5},
    {'uid': 'demo_6', 'displayName': 'WorldCup26', 'school': 'Monarch High School', 'tokens': 275, 'rank': 6},
    {'uid': 'demo_7', 'displayName': 'ScoreHunter', 'school': 'Centaurus High School', 'tokens': 250, 'rank': 7},
    {'uid': 'demo_8', 'displayName': 'MatchDay', 'school': 'Broomfield High School', 'tokens': 230, 'rank': 8},
    {'uid': 'demo_9', 'displayName': 'TopBins', 'school': 'Legacy High School', 'tokens': 210, 'rank': 9},
    {'uid': 'demo_10', 'displayName': 'Golazoo', 'school': 'Centaurus High School', 'tokens': 195, 'rank': 10},
  ];

  static List<Map<String, dynamic>> get leaderboardSchool => [
    {'uid': 'demo_1', 'displayName': 'SoccerKing99', 'school': 'Centaurus High School', 'tokens': 487, 'rank': 1},
    {'uid': 'demo_3', 'displayName': 'PredictPro', 'school': 'Centaurus High School', 'tokens': 385, 'rank': 2},
    {'uid': 'demo_user', 'displayName': 'You', 'school': 'Centaurus High School', 'tokens': 320, 'rank': 3},
    {'uid': 'demo_7', 'displayName': 'ScoreHunter', 'school': 'Centaurus High School', 'tokens': 250, 'rank': 4},
    {'uid': 'demo_10', 'displayName': 'Golazoo', 'school': 'Centaurus High School', 'tokens': 195, 'rank': 5},
  ];

  static Map<String, dynamic> get userProfile => {
    'uid': 'demo_user',
    'displayName': 'DemoPlayer',
    'school': 'Centaurus High School',
    'tokens': 320,
  };

  static List<Map<String, dynamic>> get predictions => [
    {
      'id': 'pred_1',
      'uid': 'demo_user',
      'matchId': '1006',
      'type': 'winner',
      'selection': 'home',
      'wager': 15,
      'status': 'won',
      'payout': 30,
      'homeTeamName': 'Portugal',
      'awayTeamName': 'Netherlands',
      'createdAt': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
    },
    {
      'id': 'pred_2',
      'uid': 'demo_user',
      'matchId': '1007',
      'type': 'exactScore',
      'selection': 'home_1_0',
      'wager': 10,
      'status': 'lost',
      'payout': 0,
      'homeTeamName': 'Canada',
      'awayTeamName': 'Colombia',
      'createdAt': DateTime.now().subtract(const Duration(hours: 7)).toIso8601String(),
    },
    {
      'id': 'pred_3',
      'uid': 'demo_user',
      'matchId': '1001',
      'type': 'winner',
      'selection': 'home',
      'wager': 20,
      'status': 'pending',
      'payout': 0,
      'homeTeamName': 'United States',
      'awayTeamName': 'Mexico',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    },
    {
      'id': 'pred_4',
      'uid': 'demo_user',
      'matchId': '1003',
      'type': 'winner',
      'selection': 'draw',
      'wager': 5,
      'status': 'pending',
      'payout': 0,
      'homeTeamName': 'England',
      'awayTeamName': 'Germany',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
    },
  ];
}
