// Demo/mock data for testing the app without a live backend.
// Toggle useDemoData to switch between real API and demo mode.

const bool useDemoData = true;

class DemoData {
  DemoData._();

  // ---------------------------------------------------------------------------
  // Matches
  // ---------------------------------------------------------------------------
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
      'odds': {'home': 1.85, 'draw': 3.40, 'away': 4.20, 'overUnder': 2.5, 'overOdds': 1.90, 'underOdds': 1.90},
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
      'odds': {'home': 2.10, 'draw': 3.20, 'away': 3.50, 'overUnder': 2.5, 'overOdds': 2.00, 'underOdds': 1.80},
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
      'odds': {'home': 2.50, 'draw': 3.10, 'away': 2.90, 'overUnder': 2.5, 'overOdds': 1.95, 'underOdds': 1.85},
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
      'odds': {'home': 2.30, 'draw': 3.25, 'away': 3.10, 'overUnder': 2.5, 'overOdds': 1.85, 'underOdds': 1.95},
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
      'odds': {'home': 2.60, 'draw': 3.15, 'away': 2.80, 'overUnder': 2.5, 'overOdds': 2.10, 'underOdds': 1.70},
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
      'odds': {'home': 2.00, 'draw': 3.30, 'away': 3.80, 'overUnder': 2.5, 'overOdds': 1.75, 'underOdds': 2.05},
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
      'odds': {'home': 3.50, 'draw': 3.20, 'away': 2.10, 'overUnder': 2.5, 'overOdds': 1.90, 'underOdds': 1.90},
    },
  ];

  // ---------------------------------------------------------------------------
  // Standings
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // Leaderboards (Global)
  // ---------------------------------------------------------------------------
  static List<Map<String, dynamic>> get leaderboardGlobal => [
    {'uid': 'demo_1', 'displayName': 'SoccerKing99', 'school': 'Centaurus High School', 'state': 'Colorado', 'tokens': 487, 'rank': 1, 'winRate': 72.0, 'boldness': 85.0},
    {'uid': 'demo_2', 'displayName': 'GoalMaster', 'school': 'Fairview High School', 'state': 'Colorado', 'tokens': 412, 'rank': 2, 'winRate': 65.0, 'boldness': 60.0},
    {'uid': 'demo_3', 'displayName': 'PredictPro', 'school': 'Centaurus High School', 'state': 'Colorado', 'tokens': 385, 'rank': 3, 'winRate': 61.0, 'boldness': 55.0},
    {'uid': 'demo_user', 'displayName': 'You', 'school': 'Centaurus High School', 'state': 'Colorado', 'tokens': 320, 'rank': 4, 'winRate': 58.0, 'boldness': 70.0},
    {'uid': 'demo_5', 'displayName': 'FutbolFan', 'school': 'Boulder High School', 'state': 'Colorado', 'tokens': 298, 'rank': 5, 'winRate': 55.0, 'boldness': 45.0},
    {'uid': 'demo_6', 'displayName': 'WorldCup26', 'school': 'Monarch High School', 'state': 'Colorado', 'tokens': 275, 'rank': 6, 'winRate': 52.0, 'boldness': 50.0},
    {'uid': 'demo_7', 'displayName': 'ScoreHunter', 'school': 'Centaurus High School', 'state': 'Colorado', 'tokens': 250, 'rank': 7, 'winRate': 48.0, 'boldness': 90.0},
    {'uid': 'demo_8', 'displayName': 'MatchDay', 'school': 'Broomfield High School', 'state': 'Colorado', 'tokens': 230, 'rank': 8, 'winRate': 46.0, 'boldness': 40.0},
    {'uid': 'demo_9', 'displayName': 'TopBins', 'school': 'Legacy High School', 'state': 'Colorado', 'tokens': 210, 'rank': 9, 'winRate': 43.0, 'boldness': 35.0},
    {'uid': 'demo_10', 'displayName': 'Golazoo', 'school': 'Centaurus High School', 'state': 'Colorado', 'tokens': 195, 'rank': 10, 'winRate': 40.0, 'boldness': 30.0},
    {'uid': 'demo_11', 'displayName': 'TXKicker', 'school': 'Highland Park High School', 'state': 'Texas', 'tokens': 510, 'rank': 0, 'winRate': 75.0, 'boldness': 80.0},
    {'uid': 'demo_12', 'displayName': 'NYCGoals', 'school': 'Stuyvesant High School', 'state': 'New York', 'tokens': 460, 'rank': 0, 'winRate': 70.0, 'boldness': 65.0},
    {'uid': 'demo_13', 'displayName': 'SunshineFC', 'school': 'Pine Crest School', 'state': 'Florida', 'tokens': 440, 'rank': 0, 'winRate': 68.0, 'boldness': 55.0},
    {'uid': 'demo_14', 'displayName': 'BayAreaBet', 'school': 'Palo Alto High School', 'state': 'California', 'tokens': 420, 'rank': 0, 'winRate': 66.0, 'boldness': 72.0},
  ];

  static List<Map<String, dynamic>> get leaderboardSchool => [
    {'uid': 'demo_1', 'displayName': 'SoccerKing99', 'school': 'Centaurus High School', 'state': 'Colorado', 'tokens': 487, 'rank': 1},
    {'uid': 'demo_3', 'displayName': 'PredictPro', 'school': 'Centaurus High School', 'state': 'Colorado', 'tokens': 385, 'rank': 2},
    {'uid': 'demo_user', 'displayName': 'You', 'school': 'Centaurus High School', 'state': 'Colorado', 'tokens': 320, 'rank': 3},
    {'uid': 'demo_7', 'displayName': 'ScoreHunter', 'school': 'Centaurus High School', 'state': 'Colorado', 'tokens': 250, 'rank': 4},
    {'uid': 'demo_10', 'displayName': 'Golazoo', 'school': 'Centaurus High School', 'state': 'Colorado', 'tokens': 195, 'rank': 5},
  ];

  // ---------------------------------------------------------------------------
  // Aggregation leaderboards
  // ---------------------------------------------------------------------------
  static List<Map<String, dynamic>> get schoolAggregates => [
    {'school': 'Highland Park High School', 'state': 'Texas', 'totalTokens': 2150, 'avgWinRate': 68.5, 'avgBoldness': 72.0, 'playerCount': 8, 'rank': 1},
    {'school': 'Centaurus High School', 'state': 'Colorado', 'totalTokens': 1837, 'avgWinRate': 58.2, 'avgBoldness': 66.0, 'playerCount': 5, 'rank': 2},
    {'school': 'Stuyvesant High School', 'state': 'New York', 'totalTokens': 1680, 'avgWinRate': 62.3, 'avgBoldness': 55.0, 'playerCount': 6, 'rank': 3},
    {'school': 'Pine Crest School', 'state': 'Florida', 'totalTokens': 1540, 'avgWinRate': 60.1, 'avgBoldness': 48.0, 'playerCount': 5, 'rank': 4},
    {'school': 'Palo Alto High School', 'state': 'California', 'totalTokens': 1420, 'avgWinRate': 57.8, 'avgBoldness': 62.0, 'playerCount': 4, 'rank': 5},
    {'school': 'Fairview High School', 'state': 'Colorado', 'totalTokens': 1350, 'avgWinRate': 55.0, 'avgBoldness': 50.0, 'playerCount': 4, 'rank': 6},
    {'school': 'Boulder High School', 'state': 'Colorado', 'totalTokens': 1200, 'avgWinRate': 52.0, 'avgBoldness': 45.0, 'playerCount': 5, 'rank': 7},
    {'school': 'New Trier High School', 'state': 'Illinois', 'totalTokens': 1180, 'avgWinRate': 54.0, 'avgBoldness': 40.0, 'playerCount': 3, 'rank': 8},
  ];

  static List<Map<String, dynamic>> get stateAggregates => [
    {'state': 'Texas', 'totalTokens': 5200, 'avgWinRate': 66.0, 'avgBoldness': 68.0, 'playerCount': 22, 'schoolCount': 5, 'rank': 1},
    {'state': 'Colorado', 'totalTokens': 4800, 'avgWinRate': 56.5, 'avgBoldness': 58.0, 'playerCount': 28, 'schoolCount': 7, 'rank': 2},
    {'state': 'New York', 'totalTokens': 4200, 'avgWinRate': 60.0, 'avgBoldness': 52.0, 'playerCount': 18, 'schoolCount': 4, 'rank': 3},
    {'state': 'California', 'totalTokens': 3900, 'avgWinRate': 58.5, 'avgBoldness': 60.0, 'playerCount': 15, 'schoolCount': 3, 'rank': 4},
    {'state': 'Florida', 'totalTokens': 3600, 'avgWinRate': 57.0, 'avgBoldness': 47.0, 'playerCount': 14, 'schoolCount': 3, 'rank': 5},
    {'state': 'Illinois', 'totalTokens': 2800, 'avgWinRate': 53.0, 'avgBoldness': 42.0, 'playerCount': 10, 'schoolCount': 2, 'rank': 6},
    {'state': 'Massachusetts', 'totalTokens': 2400, 'avgWinRate': 55.0, 'avgBoldness': 38.0, 'playerCount': 9, 'schoolCount': 2, 'rank': 7},
    {'state': 'Virginia', 'totalTokens': 2100, 'avgWinRate': 51.0, 'avgBoldness': 44.0, 'playerCount': 8, 'schoolCount': 2, 'rank': 8},
  ];

  // ---------------------------------------------------------------------------
  // User Profile
  // ---------------------------------------------------------------------------
  static Map<String, dynamic> get userProfile => {
    'uid': 'demo_user',
    'displayName': 'DemoPlayer',
    'school': 'Centaurus High School',
    'state': 'Colorado',
    'grade': 'Junior (11th)',
    'tokens': 320,
    'totalWagered': 245,
    'totalWon': 180,
    'predictionsCount': 12,
    'predictionsWon': 7,
  };

  // ---------------------------------------------------------------------------
  // Predictions
  // ---------------------------------------------------------------------------
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
      'type': 'overUnder',
      'selection': 'over',
      'wager': 5,
      'status': 'pending',
      'payout': 0,
      'homeTeamName': 'England',
      'awayTeamName': 'Germany',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
    },
  ];

  // ---------------------------------------------------------------------------
  // Prop Bets (friend-to-friend challenges)
  // ---------------------------------------------------------------------------
  static List<Map<String, dynamic>> get propBets => [
    {
      'id': 'prop_1',
      'fromUid': 'demo_user',
      'fromName': 'DemoPlayer',
      'toUid': 'demo_1',
      'toName': 'SoccerKing99',
      'matchId': '1003',
      'homeTeamName': 'England',
      'awayTeamName': 'Germany',
      'betType': 'nextGoal',
      'description': 'Next goal scored by England',
      'wager': 10,
      'status': 'pending', // pending, accepted, declined, won, lost
      'createdAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
    },
    {
      'id': 'prop_2',
      'fromUid': 'demo_3',
      'fromName': 'PredictPro',
      'toUid': 'demo_user',
      'toName': 'DemoPlayer',
      'matchId': '1004',
      'homeTeamName': 'France',
      'awayTeamName': 'Spain',
      'betType': 'winner',
      'description': 'France wins the match',
      'wager': 15,
      'status': 'accepted',
      'createdAt': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
    },
    {
      'id': 'prop_3',
      'fromUid': 'demo_7',
      'fromName': 'ScoreHunter',
      'toUid': 'demo_user',
      'toName': 'DemoPlayer',
      'matchId': '1005',
      'homeTeamName': 'Japan',
      'awayTeamName': 'South Korea',
      'betType': 'overUnder',
      'description': 'Over 2.5 goals total',
      'wager': 8,
      'status': 'pending',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 45)).toIso8601String(),
    },
  ];

  // ---------------------------------------------------------------------------
  // Player Stats (for the Teams & Players feature)
  // ---------------------------------------------------------------------------
  static List<Map<String, dynamic>> get teams => [
    {'id': 'us', 'name': 'United States', 'logo': 'https://media.api-sports.io/football/teams/2384.png', 'group': 'A', 'coach': 'Mauricio Pochettino', 'fifaRanking': 11},
    {'id': 'mex', 'name': 'Mexico', 'logo': 'https://media.api-sports.io/football/teams/2385.png', 'group': 'A', 'coach': 'Javier Aguirre', 'fifaRanking': 15},
    {'id': 'bra', 'name': 'Brazil', 'logo': 'https://media.api-sports.io/football/teams/6.png', 'group': 'B', 'coach': 'Dorival Junior', 'fifaRanking': 5},
    {'id': 'eng', 'name': 'England', 'logo': 'https://media.api-sports.io/football/teams/10.png', 'group': 'B', 'coach': 'Thomas Tuchel', 'fifaRanking': 4},
    {'id': 'fra', 'name': 'France', 'logo': 'https://media.api-sports.io/football/teams/2.png', 'group': 'C', 'coach': 'Didier Deschamps', 'fifaRanking': 2},
    {'id': 'arg', 'name': 'Argentina', 'logo': 'https://media.api-sports.io/football/teams/26.png', 'group': 'C', 'coach': 'Lionel Scaloni', 'fifaRanking': 1},
    {'id': 'ger', 'name': 'Germany', 'logo': 'https://media.api-sports.io/football/teams/25.png', 'group': 'C', 'coach': 'Julian Nagelsmann', 'fifaRanking': 12},
    {'id': 'esp', 'name': 'Spain', 'logo': 'https://media.api-sports.io/football/teams/9.png', 'group': 'D', 'coach': 'Luis de la Fuente', 'fifaRanking': 3},
    {'id': 'por', 'name': 'Portugal', 'logo': 'https://media.api-sports.io/football/teams/27.png', 'group': 'D', 'coach': 'Roberto Martinez', 'fifaRanking': 6},
    {'id': 'jpn', 'name': 'Japan', 'logo': 'https://media.api-sports.io/football/teams/12.png', 'group': 'B', 'coach': 'Hajime Moriyasu', 'fifaRanking': 18},
  ];

  static List<Map<String, dynamic>> get players => [
    {'name': 'Kylian Mbappe', 'team': 'France', 'position': 'Forward', 'age': 27, 'goals': 4, 'assists': 2, 'caps': 92, 'bio': 'One of the fastest players in the world. PSG and Real Madrid star with World Cup winner in 2018 and finalist in 2022.'},
    {'name': 'Lionel Messi', 'team': 'Argentina', 'position': 'Forward', 'age': 38, 'goals': 2, 'assists': 3, 'caps': 190, 'bio': 'Eight-time Ballon d\'Or winner. Led Argentina to 2022 World Cup glory. Playing in what may be his final World Cup.'},
    {'name': 'Jude Bellingham', 'team': 'England', 'position': 'Midfielder', 'age': 22, 'goals': 3, 'assists': 1, 'caps': 48, 'bio': 'Young midfield sensation at Real Madrid. Known for late goals and tireless energy.'},
    {'name': 'Vinicius Jr', 'team': 'Brazil', 'position': 'Forward', 'age': 25, 'goals': 3, 'assists': 2, 'caps': 45, 'bio': 'Explosive Real Madrid winger with incredible dribbling skills and pace.'},
    {'name': 'Christian Pulisic', 'team': 'United States', 'position': 'Forward', 'age': 27, 'goals': 2, 'assists': 1, 'caps': 72, 'bio': 'Captain America. AC Milan star and US national team leader since age 17.'},
    {'name': 'Lamine Yamal', 'team': 'Spain', 'position': 'Forward', 'age': 18, 'goals': 2, 'assists': 3, 'caps': 25, 'bio': 'Barcelona\'s teenage prodigy. Youngest ever Euro goalscorer at 16.'},
    {'name': 'Florian Wirtz', 'team': 'Germany', 'position': 'Midfielder', 'age': 23, 'goals': 2, 'assists': 2, 'caps': 35, 'bio': 'Bayer Leverkusen playmaker who helped lead an unbeaten Bundesliga season.'},
    {'name': 'Cristiano Ronaldo', 'team': 'Portugal', 'position': 'Forward', 'age': 41, 'goals': 1, 'assists': 0, 'caps': 215, 'bio': 'All-time international goalscorer. Five Ballon d\'Or wins. Legend of the game.'},
    {'name': 'Takefusa Kubo', 'team': 'Japan', 'position': 'Forward', 'age': 25, 'goals': 1, 'assists': 2, 'caps': 40, 'bio': 'Real Sociedad attacker nicknamed the Japanese Messi for his silky skills.'},
    {'name': 'Hirving Lozano', 'team': 'Mexico', 'position': 'Forward', 'age': 30, 'goals': 1, 'assists': 1, 'caps': 68, 'bio': 'PSV Eindhoven winger known for his blistering pace on the counter-attack.'},
  ];

  /// Golden Boot leaderboard (tournament top scorers).
  static List<Map<String, dynamic>> get goldenBootRace => [
    {'player': 'Kylian Mbappe', 'team': 'France', 'goals': 4, 'assists': 2, 'minutesPlayed': 270},
    {'player': 'Jude Bellingham', 'team': 'England', 'goals': 3, 'assists': 1, 'minutesPlayed': 270},
    {'player': 'Vinicius Jr', 'team': 'Brazil', 'goals': 3, 'assists': 2, 'minutesPlayed': 270},
    {'player': 'Lionel Messi', 'team': 'Argentina', 'goals': 2, 'assists': 3, 'minutesPlayed': 210},
    {'player': 'Christian Pulisic', 'team': 'United States', 'goals': 2, 'assists': 1, 'minutesPlayed': 270},
    {'player': 'Lamine Yamal', 'team': 'Spain', 'goals': 2, 'assists': 3, 'minutesPlayed': 270},
    {'player': 'Florian Wirtz', 'team': 'Germany', 'goals': 2, 'assists': 2, 'minutesPlayed': 270},
  ];

  // ---------------------------------------------------------------------------
  // News Feed
  // ---------------------------------------------------------------------------
  static List<Map<String, dynamic>> get newsFeed => [
    {
      'title': 'Mbappe scores stunning hat-trick as France cruises past group stage',
      'source': 'FIFA.com',
      'url': 'https://www.fifa.com/worldcup',
      'imageUrl': 'https://media.api-sports.io/football/teams/2.png',
      'publishedAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'category': 'match',
    },
    {
      'title': 'USA advances to knockout round after dramatic late winner',
      'source': 'ESPN',
      'url': 'https://www.espn.com/soccer',
      'imageUrl': 'https://media.api-sports.io/football/teams/2384.png',
      'publishedAt': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
      'category': 'match',
    },
    {
      'title': 'Golden Boot race heats up: Mbappe, Bellingham, Vinicius Jr lead',
      'source': 'BBC Sport',
      'url': 'https://www.bbc.com/sport/football',
      'imageUrl': null,
      'publishedAt': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
      'category': 'stats',
    },
    {
      'title': 'World Cup 2026: Full schedule, venues, and bracket explained',
      'source': 'The Athletic',
      'url': 'https://theathletic.com',
      'imageUrl': null,
      'publishedAt': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
      'category': 'info',
    },
    {
      'title': 'Yamal becomes youngest World Cup goalscorer in tournament history',
      'source': 'Goal.com',
      'url': 'https://www.goal.com',
      'imageUrl': 'https://media.api-sports.io/football/teams/9.png',
      'publishedAt': DateTime.now().subtract(const Duration(hours: 18)).toIso8601String(),
      'category': 'match',
    },
    {
      'title': 'Argentina vs Brazil: What you need to know about the biggest rivalry',
      'source': 'FourFourTwo',
      'url': 'https://www.fourfourtwo.com',
      'imageUrl': 'https://media.api-sports.io/football/teams/26.png',
      'publishedAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'category': 'preview',
    },
  ];

  // ---------------------------------------------------------------------------
  // Token Store pricing
  // ---------------------------------------------------------------------------
  static List<Map<String, dynamic>> get tokenPackages => [
    {'id': 'pack_100', 'tokens': 100, 'price': 0.99, 'label': 'Starter Pack', 'popular': false},
    {'id': 'pack_500', 'tokens': 500, 'price': 3.99, 'label': 'Fan Pack', 'popular': true},
    {'id': 'pack_1200', 'tokens': 1200, 'price': 7.99, 'label': 'Baller Pack', 'popular': false},
    {'id': 'pack_3000', 'tokens': 3000, 'price': 14.99, 'label': 'Legend Pack', 'popular': false},
  ];
}
