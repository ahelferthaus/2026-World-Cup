import 'package:flutter/material.dart';

/// Configuration for each sport in the hub.
class SportConfig {
  final String id;
  final String name;
  final String subtitle;
  final String emoji;
  final String route;
  final List<Color> gradientColors;
  final bool isLive;
  final String badge;
  final List<PlayerThumb> featuredPlayers;

  const SportConfig({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.emoji,
    required this.route,
    required this.gradientColors,
    required this.isLive,
    required this.badge,
    this.featuredPlayers = const [],
  });
}

/// A featured player thumbnail for sport cards.
class PlayerThumb {
  final String name;
  final String imageUrl;
  final String team;

  const PlayerThumb({
    required this.name,
    required this.imageUrl,
    required this.team,
  });
}

/// All sports available in the hub with real player imagery.
class SportHubData {
  SportHubData._();

  static const sports = <SportConfig>[
    // ── World Cup ──
    SportConfig(
      id: 'worldcup',
      name: 'World Cup',
      subtitle: 'FIFA 2026 \u2022 USA/MEX/CAN',
      emoji: '\u26BD',
      route: '/home',
      gradientColors: [Color(0xFF00C853), Color(0xFF1B5E20)],
      isLive: true,
      badge: 'LIVE NOW',
      featuredPlayers: [
        PlayerThumb(
          name: 'Mbapp\u00e9',
          imageUrl: 'https://media.api-sports.io/football/players/278.png',
          team: 'FRA',
        ),
        PlayerThumb(
          name: 'Messi',
          imageUrl: 'https://media.api-sports.io/football/players/154.png',
          team: 'ARG',
        ),
        PlayerThumb(
          name: 'Pulisic',
          imageUrl: 'https://media.api-sports.io/football/players/1100.png',
          team: 'USA',
        ),
      ],
    ),

    // ── NBA Playoffs ──
    SportConfig(
      id: 'nba',
      name: 'NBA Playoffs',
      subtitle: 'Playoffs \u2022 Round 1',
      emoji: '\u{1F3C0}',
      route: '/nba',
      gradientColors: [Color(0xFFF37321), Color(0xFF1D428A)],
      isLive: true,
      badge: 'GAME TONIGHT',
      featuredPlayers: [
        PlayerThumb(
          name: 'SGA',
          imageUrl: 'https://cdn.nba.com/headshots/nba/latest/1040x760/1628983.png',
          team: 'OKC',
        ),
        PlayerThumb(
          name: 'Tatum',
          imageUrl: 'https://cdn.nba.com/headshots/nba/latest/1040x760/1628369.png',
          team: 'BOS',
        ),
        PlayerThumb(
          name: 'Giannis',
          imageUrl: 'https://cdn.nba.com/headshots/nba/latest/1040x760/203507.png',
          team: 'MIL',
        ),
      ],
    ),

    // ── NFL ──
    SportConfig(
      id: 'nfl',
      name: 'NFL',
      subtitle: 'Coming Fall',
      emoji: '\u{1F3C8}',
      route: '',
      gradientColors: [Color(0xFF013369), Color(0xFFD50A0A)],
      isLive: false,
      badge: 'COMING SOON',
      featuredPlayers: [
        PlayerThumb(name: 'Mahomes', imageUrl: '', team: 'KC'),
        PlayerThumb(name: 'Allen', imageUrl: '', team: 'BUF'),
        PlayerThumb(name: 'Hurts', imageUrl: '', team: 'PHI'),
      ],
    ),

    // ── MLB ──
    SportConfig(
      id: 'mlb',
      name: 'MLB',
      subtitle: 'Coming Summer',
      emoji: '\u26BE',
      route: '',
      gradientColors: [Color(0xFF002D72), Color(0xFFCE1141)],
      isLive: false,
      badge: 'COMING SOON',
      featuredPlayers: [
        PlayerThumb(name: 'Ohtani', imageUrl: '', team: 'LAD'),
        PlayerThumb(name: 'Judge', imageUrl: '', team: 'NYY'),
        PlayerThumb(name: 'Soto', imageUrl: '', team: 'NYM'),
      ],
    ),

    // ── UFC/MMA ──
    SportConfig(
      id: 'ufc',
      name: 'UFC/MMA',
      subtitle: 'Coming Soon',
      emoji: '\u{1F94A}',
      route: '',
      gradientColors: [Color(0xFFD20A0A), Color(0xFF1A1A1A)],
      isLive: false,
      badge: 'COMING SOON',
    ),

    // ── Esports ──
    SportConfig(
      id: 'esports',
      name: 'Esports',
      subtitle: 'Coming Soon',
      emoji: '\u{1F3AE}',
      route: '',
      gradientColors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
      isLive: false,
      badge: 'COMING SOON',
    ),
  ];
}
