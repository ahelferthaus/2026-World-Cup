/// NBA Playoffs 2026 demo data.
/// Real teams, realistic player stats for the prediction engine.
class NbaDemoData {
  NbaDemoData._();

  // -------------------------------------------------------------------------
  // Playoff bracket (2026 projections)
  // -------------------------------------------------------------------------
  static const playoffTeams = <Map<String, dynamic>>[
    // Western Conference
    {'seed': 1, 'name': 'Thunder', 'city': 'Oklahoma City', 'abbr': 'OKC', 'conference': 'West', 'record': '62-20', 'logo': 'https://cdn.nba.com/logos/nba/1610612760/primary/L/logo.svg', 'color': 0xFF007AC1},
    {'seed': 2, 'name': 'Nuggets', 'city': 'Denver', 'abbr': 'DEN', 'conference': 'West', 'record': '57-25', 'logo': 'https://cdn.nba.com/logos/nba/1610612743/primary/L/logo.svg', 'color': 0xFF0E2240},
    {'seed': 3, 'name': 'Timberwolves', 'city': 'Minnesota', 'abbr': 'MIN', 'conference': 'West', 'record': '55-27', 'logo': 'https://cdn.nba.com/logos/nba/1610612750/primary/L/logo.svg', 'color': 0xFF0C2340},
    {'seed': 4, 'name': 'Mavericks', 'city': 'Dallas', 'abbr': 'DAL', 'conference': 'West', 'record': '53-29', 'logo': 'https://cdn.nba.com/logos/nba/1610612742/primary/L/logo.svg', 'color': 0xFF00538C},
    {'seed': 5, 'name': 'Lakers', 'city': 'Los Angeles', 'abbr': 'LAL', 'conference': 'West', 'record': '52-30', 'logo': 'https://cdn.nba.com/logos/nba/1610612747/primary/L/logo.svg', 'color': 0xFF552583},
    {'seed': 6, 'name': 'Grizzlies', 'city': 'Memphis', 'abbr': 'MEM', 'conference': 'West', 'record': '50-32', 'logo': 'https://cdn.nba.com/logos/nba/1610612763/primary/L/logo.svg', 'color': 0xFF5D76A9},
    {'seed': 7, 'name': 'Warriors', 'city': 'Golden State', 'abbr': 'GSW', 'conference': 'West', 'record': '48-34', 'logo': 'https://cdn.nba.com/logos/nba/1610612744/primary/L/logo.svg', 'color': 0xFF1D428A},
    {'seed': 8, 'name': 'Suns', 'city': 'Phoenix', 'abbr': 'PHX', 'conference': 'West', 'record': '47-35', 'logo': 'https://cdn.nba.com/logos/nba/1610612756/primary/L/logo.svg', 'color': 0xFF1D1160},
    // Eastern Conference
    {'seed': 1, 'name': 'Celtics', 'city': 'Boston', 'abbr': 'BOS', 'conference': 'East', 'record': '64-18', 'logo': 'https://cdn.nba.com/logos/nba/1610612738/primary/L/logo.svg', 'color': 0xFF007A33},
    {'seed': 2, 'name': 'Cavaliers', 'city': 'Cleveland', 'abbr': 'CLE', 'conference': 'East', 'record': '58-24', 'logo': 'https://cdn.nba.com/logos/nba/1610612739/primary/L/logo.svg', 'color': 0xFF860038},
    {'seed': 3, 'name': 'Knicks', 'city': 'New York', 'abbr': 'NYK', 'conference': 'East', 'record': '54-28', 'logo': 'https://cdn.nba.com/logos/nba/1610612752/primary/L/logo.svg', 'color': 0xFF006BB6},
    {'seed': 4, 'name': 'Bucks', 'city': 'Milwaukee', 'abbr': 'MIL', 'conference': 'East', 'record': '53-29', 'logo': 'https://cdn.nba.com/logos/nba/1610612749/primary/L/logo.svg', 'color': 0xFF00471B},
    {'seed': 5, 'name': 'Pacers', 'city': 'Indiana', 'abbr': 'IND', 'conference': 'East', 'record': '50-32', 'logo': 'https://cdn.nba.com/logos/nba/1610612754/primary/L/logo.svg', 'color': 0xFF002D62},
    {'seed': 6, 'name': '76ers', 'city': 'Philadelphia', 'abbr': 'PHI', 'conference': 'East', 'record': '49-33', 'logo': 'https://cdn.nba.com/logos/nba/1610612755/primary/L/logo.svg', 'color': 0xFF006BB6},
    {'seed': 7, 'name': 'Heat', 'city': 'Miami', 'abbr': 'MIA', 'conference': 'East', 'record': '47-35', 'logo': 'https://cdn.nba.com/logos/nba/1610612748/primary/L/logo.svg', 'color': 0xFF98002E},
    {'seed': 8, 'name': 'Magic', 'city': 'Orlando', 'abbr': 'ORL', 'conference': 'East', 'record': '46-36', 'logo': 'https://cdn.nba.com/logos/nba/1610612753/primary/L/logo.svg', 'color': 0xFF0077C0},
  ];

  // -------------------------------------------------------------------------
  // Star players with stats (for glossy player cards)
  // -------------------------------------------------------------------------
  static const starPlayers = <Map<String, dynamic>>[
    {'name': 'Shai Gilgeous-Alexander', 'team': 'OKC', 'number': 2, 'position': 'PG', 'ppg': 31.4, 'rpg': 5.5, 'apg': 6.2, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/1628983.png'},
    {'name': 'Nikola Jokic', 'team': 'DEN', 'number': 15, 'position': 'C', 'ppg': 26.4, 'rpg': 12.4, 'apg': 9.0, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/203999.png'},
    {'name': 'Anthony Edwards', 'team': 'MIN', 'number': 5, 'position': 'SG', 'ppg': 27.8, 'rpg': 5.8, 'apg': 5.1, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/1630162.png'},
    {'name': 'Luka Doncic', 'team': 'DAL', 'number': 77, 'position': 'PG', 'ppg': 28.7, 'rpg': 8.3, 'apg': 8.8, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/1629029.png'},
    {'name': 'LeBron James', 'team': 'LAL', 'number': 23, 'position': 'SF', 'ppg': 25.2, 'rpg': 7.3, 'apg': 8.4, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/2544.png'},
    {'name': 'Jayson Tatum', 'team': 'BOS', 'number': 0, 'position': 'SF', 'ppg': 27.1, 'rpg': 8.1, 'apg': 4.9, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/1628369.png'},
    {'name': 'Donovan Mitchell', 'team': 'CLE', 'number': 45, 'position': 'SG', 'ppg': 25.7, 'rpg': 4.1, 'apg': 5.5, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/1628378.png'},
    {'name': 'Jalen Brunson', 'team': 'NYK', 'number': 11, 'position': 'PG', 'ppg': 28.7, 'rpg': 3.5, 'apg': 6.7, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/1628973.png'},
    {'name': 'Giannis Antetokounmpo', 'team': 'MIL', 'number': 34, 'position': 'PF', 'ppg': 30.4, 'rpg': 11.5, 'apg': 6.5, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/203507.png'},
    {'name': 'Stephen Curry', 'team': 'GSW', 'number': 30, 'position': 'PG', 'ppg': 26.4, 'rpg': 4.5, 'apg': 6.1, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/201939.png'},
    {'name': 'Joel Embiid', 'team': 'PHI', 'number': 21, 'position': 'C', 'ppg': 27.9, 'rpg': 11.0, 'apg': 5.6, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/203954.png'},
    {'name': 'Kevin Durant', 'team': 'PHX', 'number': 35, 'position': 'SF', 'ppg': 27.1, 'rpg': 6.6, 'apg': 5.0, 'image': 'https://cdn.nba.com/headshots/nba/latest/1040x760/201142.png'},
  ];

  // -------------------------------------------------------------------------
  // Playoff matchups (Round 1)
  // -------------------------------------------------------------------------
  static const round1Matchups = <Map<String, dynamic>>[
    // West
    {'id': 'w1', 'round': 1, 'conference': 'West', 'homeSeed': 1, 'homeTeam': 'OKC', 'homeCity': 'Oklahoma City', 'homeName': 'Thunder', 'awaySeed': 8, 'awayTeam': 'PHX', 'awayCity': 'Phoenix', 'awayName': 'Suns', 'status': 'Game 3', 'homeWins': 2, 'awayWins': 0, 'nextGame': '2026-04-24T20:30:00Z', 'odds': {'home': 1.35, 'away': 3.10}},
    {'id': 'w2', 'round': 1, 'conference': 'West', 'homeSeed': 2, 'homeTeam': 'DEN', 'homeCity': 'Denver', 'homeName': 'Nuggets', 'awaySeed': 7, 'awayTeam': 'GSW', 'awayCity': 'Golden State', 'awayName': 'Warriors', 'status': 'Game 3', 'homeWins': 1, 'awayWins': 1, 'nextGame': '2026-04-24T22:00:00Z', 'odds': {'home': 1.55, 'away': 2.45}},
    {'id': 'w3', 'round': 1, 'conference': 'West', 'homeSeed': 3, 'homeTeam': 'MIN', 'homeCity': 'Minnesota', 'homeName': 'Timberwolves', 'awaySeed': 6, 'awayTeam': 'MEM', 'awayCity': 'Memphis', 'awayName': 'Grizzlies', 'status': 'Game 2', 'homeWins': 1, 'awayWins': 0, 'nextGame': '2026-04-25T19:00:00Z', 'odds': {'home': 1.45, 'away': 2.75}},
    {'id': 'w4', 'round': 1, 'conference': 'West', 'homeSeed': 4, 'homeTeam': 'DAL', 'homeCity': 'Dallas', 'homeName': 'Mavericks', 'awaySeed': 5, 'awayTeam': 'LAL', 'awayCity': 'Los Angeles', 'awayName': 'Lakers', 'status': 'Game 2', 'homeWins': 0, 'awayWins': 1, 'nextGame': '2026-04-25T21:30:00Z', 'odds': {'home': 1.80, 'away': 2.00}},
    // East
    {'id': 'e1', 'round': 1, 'conference': 'East', 'homeSeed': 1, 'homeTeam': 'BOS', 'homeCity': 'Boston', 'homeName': 'Celtics', 'awaySeed': 8, 'awayTeam': 'ORL', 'awayCity': 'Orlando', 'awayName': 'Magic', 'status': 'Game 3', 'homeWins': 2, 'awayWins': 0, 'nextGame': '2026-04-24T19:00:00Z', 'odds': {'home': 1.22, 'away': 4.20}},
    {'id': 'e2', 'round': 1, 'conference': 'East', 'homeSeed': 2, 'homeTeam': 'CLE', 'homeCity': 'Cleveland', 'homeName': 'Cavaliers', 'awaySeed': 7, 'awayTeam': 'MIA', 'awayCity': 'Miami', 'awayName': 'Heat', 'status': 'Game 3', 'homeWins': 1, 'awayWins': 1, 'nextGame': '2026-04-25T19:30:00Z', 'odds': {'home': 1.50, 'away': 2.55}},
    {'id': 'e3', 'round': 1, 'conference': 'East', 'homeSeed': 3, 'homeTeam': 'NYK', 'homeCity': 'New York', 'homeName': 'Knicks', 'awaySeed': 6, 'awayTeam': 'PHI', 'awayCity': 'Philadelphia', 'awayName': '76ers', 'status': 'Game 2', 'homeWins': 1, 'awayWins': 0, 'nextGame': '2026-04-24T20:00:00Z', 'odds': {'home': 1.60, 'away': 2.35}},
    {'id': 'e4', 'round': 1, 'conference': 'East', 'homeSeed': 4, 'homeTeam': 'MIL', 'homeCity': 'Milwaukee', 'homeName': 'Bucks', 'awaySeed': 5, 'awayTeam': 'IND', 'awayCity': 'Indiana', 'awayName': 'Pacers', 'status': 'Game 2', 'homeWins': 1, 'awayWins': 0, 'nextGame': '2026-04-25T20:00:00Z', 'odds': {'home': 1.40, 'away': 2.90}},
  ];

  // -------------------------------------------------------------------------
  // Trending predictions (social feed style)
  // -------------------------------------------------------------------------
  static const trendingPredictions = <Map<String, dynamic>>[
    {'user': 'BallDontLie23', 'prediction': 'SGA drops 40+ in Game 3', 'tokens': 50, 'likes': 342, 'emoji': '\u{1F525}'},
    {'user': 'HoopDreams', 'prediction': 'Warriors upset Nuggets in 7', 'tokens': 25, 'likes': 891, 'emoji': '\u{1F631}'},
    {'user': 'MambaForever', 'prediction': 'LeBron triple-double tonight', 'tokens': 30, 'likes': 1247, 'emoji': '\u{1F451}'},
    {'user': 'CelticsPride', 'prediction': 'Tatum 50-piece in Game 3', 'tokens': 100, 'likes': 567, 'emoji': '\u{2604}'},
    {'user': 'GreekFreak34', 'prediction': 'Giannis poster dunk tonight', 'tokens': 15, 'likes': 2103, 'emoji': '\u{1F4A5}'},
    {'user': 'StephGOAT30', 'prediction': 'Curry hits 8 threes vs Denver', 'tokens': 40, 'likes': 1890, 'emoji': '\u{1F3AF}'},
  ];
}
