import 'package:flutter_test/flutter_test.dart';

import 'package:pokin_tokens/features/home/domain/team_model.dart';
import 'package:pokin_tokens/features/home/domain/match_model.dart';
import 'package:pokin_tokens/features/home/domain/standing_model.dart';
import 'package:pokin_tokens/features/predict/domain/prediction_model.dart';
import 'package:pokin_tokens/features/auth/domain/app_user.dart';
import 'package:pokin_tokens/features/leaderboard/domain/leaderboard_entry.dart';
import 'package:pokin_tokens/features/challenges/domain/challenge_model.dart';

void main() {
  // =========================================================================
  // TeamModel
  // =========================================================================
  group('TeamModel', () {
    test('constructor sets all fields', () {
      const team = TeamModel(id: 1, name: 'Brazil', logo: 'br.png');
      expect(team.id, 1);
      expect(team.name, 'Brazil');
      expect(team.logo, 'br.png');
    });

    test('fromJson parses correctly', () {
      final team = TeamModel.fromJson({
        'id': 10,
        'name': 'Argentina',
        'logo': 'ar.png',
      });
      expect(team.id, 10);
      expect(team.name, 'Argentina');
      expect(team.logo, 'ar.png');
    });

    test('fromJson defaults id to 0 when null', () {
      final team = TeamModel.fromJson({
        'id': null,
        'name': 'Unknown',
        'logo': 'x.png',
      });
      expect(team.id, 0);
    });

    test('fromJson defaults id to 0 when missing', () {
      final team = TeamModel.fromJson({
        'name': 'Unknown',
        'logo': 'x.png',
      });
      expect(team.id, 0);
    });
  });

  // =========================================================================
  // MatchModel
  // =========================================================================
  group('MatchModel', () {
    Map<String, dynamic> baseTeam(String name) => {
          'id': 1,
          'name': name,
          'logo': '${name.toLowerCase()}.png',
        };

    Map<String, dynamic> apiJson({
      String status = 'NS',
      int? homeScore,
      int? awayScore,
      int? elapsed,
    }) =>
        {
          'fixtureId': 100,
          'kickoff': '2026-06-15T18:00:00Z',
          'status': status,
          'statusLong': 'Not Started',
          'elapsed': elapsed,
          'homeTeam': baseTeam('Brazil'),
          'awayTeam': baseTeam('Argentina'),
          'score': {'home': homeScore, 'away': awayScore},
        };

    Map<String, dynamic> demoJson({
      String status = 'NS',
      int? homeScore,
      int? awayScore,
    }) =>
        {
          'id': 200,
          'kickoff': '2026-06-15T18:00:00Z',
          'status': status,
          'homeTeam': baseTeam('Brazil'),
          'awayTeam': baseTeam('Argentina'),
          'homeScore': homeScore,
          'awayScore': awayScore,
        };

    test('fromJson parses API format with score.home/away', () {
      final match = MatchModel.fromJson(apiJson(homeScore: 2, awayScore: 1));
      expect(match.fixtureId, 100);
      expect(match.kickoff, '2026-06-15T18:00:00Z');
      expect(match.status, 'NS');
      expect(match.statusLong, 'Not Started');
      expect(match.homeTeam.name, 'Brazil');
      expect(match.awayTeam.name, 'Argentina');
      expect(match.scoreHome, 2);
      expect(match.scoreAway, 1);
    });

    test('fromJson parses demo format with homeScore/awayScore', () {
      final match =
          MatchModel.fromJson(demoJson(homeScore: 3, awayScore: 0));
      expect(match.fixtureId, 200);
      expect(match.scoreHome, 3);
      expect(match.scoreAway, 0);
    });

    test('fromJson uses id when fixtureId is absent', () {
      final match = MatchModel.fromJson(demoJson());
      expect(match.fixtureId, 200);
    });

    test('fromJson falls back statusLong to status when absent', () {
      final match = MatchModel.fromJson(demoJson(status: 'FT'));
      expect(match.statusLong, 'FT');
    });

    test('fromJson sets elapsed', () {
      final match = MatchModel.fromJson(apiJson(elapsed: 45));
      expect(match.elapsed, 45);
    });

    test('fromJson stores rawData', () {
      final json = apiJson();
      final match = MatchModel.fromJson(json);
      expect(match.rawData, json);
    });

    test('scores are null when not provided', () {
      final match = MatchModel.fromJson(demoJson());
      expect(match.scoreHome, isNull);
      expect(match.scoreAway, isNull);
    });

    group('status getters', () {
      test('isUpcoming is true for NS', () {
        final match = MatchModel.fromJson(apiJson(status: 'NS'));
        expect(match.isUpcoming, isTrue);
        expect(match.isLive, isFalse);
        expect(match.isFinished, isFalse);
      });

      test('isLive is true for 1H', () {
        final m = MatchModel.fromJson(apiJson(status: '1H'));
        expect(m.isLive, isTrue);
        expect(m.isUpcoming, isFalse);
        expect(m.isFinished, isFalse);
      });

      test('isLive is true for 2H', () {
        expect(
          MatchModel.fromJson(apiJson(status: '2H')).isLive,
          isTrue,
        );
      });

      test('isLive is true for HT', () {
        expect(
          MatchModel.fromJson(apiJson(status: 'HT')).isLive,
          isTrue,
        );
      });

      test('isLive is true for ET', () {
        expect(
          MatchModel.fromJson(apiJson(status: 'ET')).isLive,
          isTrue,
        );
      });

      test('isFinished is true for FT', () {
        final m = MatchModel.fromJson(apiJson(status: 'FT'));
        expect(m.isFinished, isTrue);
        expect(m.isLive, isFalse);
        expect(m.isUpcoming, isFalse);
      });

      test('isFinished is true for AET', () {
        expect(
          MatchModel.fromJson(apiJson(status: 'AET')).isFinished,
          isTrue,
        );
      });

      test('isFinished is true for PEN', () {
        expect(
          MatchModel.fromJson(apiJson(status: 'PEN')).isFinished,
          isTrue,
        );
      });

      test('unknown status returns false for all getters', () {
        final m = MatchModel.fromJson(apiJson(status: 'PST'));
        expect(m.isUpcoming, isFalse);
        expect(m.isLive, isFalse);
        expect(m.isFinished, isFalse);
      });
    });
  });

  // =========================================================================
  // PredictionModel
  // =========================================================================
  group('PredictionModel', () {
    Map<String, dynamic> demoData({
      String type = 'matchResult',
      String selection = 'home',
      String status = 'pending',
      int payout = 0,
      int? scoreHome,
      int? scoreAway,
    }) =>
        {
          'id': 'p1',
          'uid': 'user1',
          'matchId': 'm1',
          'type': type,
          'selection': selection,
          'wager': 50,
          'status': status,
          'payout': payout,
          'createdAt': '2026-06-15T12:00:00.000',
        };

    test('fromDemo parses all fields', () {
      final p = PredictionModel.fromDemo(demoData());
      expect(p.id, 'p1');
      expect(p.uid, 'user1');
      expect(p.matchId, 'm1');
      expect(p.type, 'matchResult');
      expect(p.selection, 'home');
      expect(p.wager, 50);
      expect(p.status, 'pending');
      expect(p.payout, 0);
      expect(p.createdAt, DateTime.parse('2026-06-15T12:00:00.000'));
    });

    test('fromDemo defaults payout to 0 when null', () {
      final data = demoData();
      data['payout'] = null;
      final p = PredictionModel.fromDemo(data);
      expect(p.payout, 0);
    });

    group('status getters', () {
      test('isPending', () {
        final p = PredictionModel.fromDemo(demoData(status: 'pending'));
        expect(p.isPending, isTrue);
        expect(p.isWon, isFalse);
        expect(p.isLost, isFalse);
      });

      test('isWon', () {
        final p = PredictionModel.fromDemo(demoData(status: 'won'));
        expect(p.isWon, isTrue);
        expect(p.isPending, isFalse);
        expect(p.isLost, isFalse);
      });

      test('isLost', () {
        final p = PredictionModel.fromDemo(demoData(status: 'lost'));
        expect(p.isLost, isTrue);
        expect(p.isPending, isFalse);
        expect(p.isWon, isFalse);
      });
    });

    group('selectionLabel', () {
      test('returns Home Win for home', () {
        final p = PredictionModel.fromDemo(demoData(selection: 'home'));
        expect(p.selectionLabel, 'Home Win');
      });

      test('returns Away Win for away', () {
        final p = PredictionModel.fromDemo(demoData(selection: 'away'));
        expect(p.selectionLabel, 'Away Win');
      });

      test('returns Draw for draw', () {
        final p = PredictionModel.fromDemo(demoData(selection: 'draw'));
        expect(p.selectionLabel, 'Draw');
      });

      test('returns raw selection for unknown value', () {
        final p =
            PredictionModel.fromDemo(demoData(selection: 'over2.5'));
        expect(p.selectionLabel, 'over2.5');
      });

      test('returns score string for exactScore type', () {
        final p = PredictionModel(
          id: 'p2',
          uid: 'user1',
          matchId: 'm1',
          type: 'exactScore',
          selection: 'exactScore',
          scoreHome: 2,
          scoreAway: 1,
          wager: 100,
          status: 'pending',
          payout: 0,
          createdAt: DateTime(2026, 6, 15),
        );
        expect(p.selectionLabel, '2 - 1');
      });

      test('returns null - null for exactScore with null scores', () {
        final p = PredictionModel(
          id: 'p3',
          uid: 'user1',
          matchId: 'm1',
          type: 'exactScore',
          selection: 'exactScore',
          wager: 100,
          status: 'pending',
          payout: 0,
          createdAt: DateTime(2026, 6, 15),
        );
        expect(p.selectionLabel, 'null - null');
      });
    });
  });

  // =========================================================================
  // AppUser
  // =========================================================================
  group('AppUser', () {
    test('constructor with defaults', () {
      const user = AppUser(
        uid: 'u1',
        displayName: 'Test',
        school: 'High School',
        tokens: 500,
      );
      expect(user.uid, 'u1');
      expect(user.state, '');
      expect(user.grade, '');
      expect(user.totalWagered, 0);
      expect(user.totalWon, 0);
      expect(user.predictionsCount, 0);
      expect(user.predictionsWon, 0);
      expect(user.photoUrl, isNull);
      expect(user.lastAiPhotoGenerated, isNull);
      expect(user.createdAt, isNull);
    });

    test('fromDemo parses all fields', () {
      final user = AppUser.fromDemo({
        'uid': 'u1',
        'displayName': 'Alice',
        'school': 'Central HS',
        'state': 'Texas',
        'grade': 'Senior (12th)',
        'tokens': 1000,
        'totalWagered': 500,
        'totalWon': 300,
        'predictionsCount': 20,
        'predictionsWon': 12,
        'photoUrl': 'photo.png',
      });
      expect(user.uid, 'u1');
      expect(user.displayName, 'Alice');
      expect(user.school, 'Central HS');
      expect(user.state, 'Texas');
      expect(user.grade, 'Senior (12th)');
      expect(user.tokens, 1000);
      expect(user.totalWagered, 500);
      expect(user.totalWon, 300);
      expect(user.predictionsCount, 20);
      expect(user.predictionsWon, 12);
      expect(user.photoUrl, 'photo.png');
    });

    test('fromDemo uses defaults for optional fields', () {
      final user = AppUser.fromDemo({
        'uid': 'u2',
        'displayName': 'Bob',
      });
      expect(user.school, '');
      expect(user.state, 'Colorado');
      expect(user.grade, 'Junior (11th)');
      expect(user.tokens, 0);
      expect(user.totalWagered, 245);
      expect(user.totalWon, 180);
      expect(user.predictionsCount, 12);
      expect(user.predictionsWon, 7);
      expect(user.photoUrl, isNull);
    });

    group('canGenerateAiPhoto', () {
      test('returns true when lastAiPhotoGenerated is null', () {
        const user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          lastAiPhotoGenerated: null,
        );
        expect(user.canGenerateAiPhoto, isTrue);
      });

      test('returns true when last generated 7+ days ago', () {
        final user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          lastAiPhotoGenerated: DateTime.now().subtract(
            const Duration(days: 8),
          ),
        );
        expect(user.canGenerateAiPhoto, isTrue);
      });

      test('returns true when last generated exactly 7 days ago', () {
        final user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          lastAiPhotoGenerated: DateTime.now().subtract(
            const Duration(days: 7),
          ),
        );
        expect(user.canGenerateAiPhoto, isTrue);
      });

      test('returns false when last generated recently', () {
        final user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          lastAiPhotoGenerated: DateTime.now().subtract(
            const Duration(days: 3),
          ),
        );
        expect(user.canGenerateAiPhoto, isFalse);
      });

      test('returns false when last generated today', () {
        final user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          lastAiPhotoGenerated: DateTime.now(),
        );
        expect(user.canGenerateAiPhoto, isFalse);
      });
    });

    group('winRate', () {
      test('returns 0 when no predictions', () {
        const user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          predictionsCount: 0,
          predictionsWon: 0,
        );
        expect(user.winRate, 0);
      });

      test('calculates correctly', () {
        const user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          predictionsCount: 10,
          predictionsWon: 7,
        );
        expect(user.winRate, 70.0);
      });

      test('100% win rate', () {
        const user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          predictionsCount: 5,
          predictionsWon: 5,
        );
        expect(user.winRate, 100.0);
      });

      test('0% win rate with predictions', () {
        const user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          predictionsCount: 5,
          predictionsWon: 0,
        );
        expect(user.winRate, 0.0);
      });
    });

    group('boldnessScore', () {
      test('returns 0 when no predictions', () {
        const user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          predictionsCount: 0,
        );
        expect(user.boldnessScore, 0);
      });

      test('returns 0 when tokens is 0', () {
        const user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 0,
          predictionsCount: 5,
          totalWagered: 100,
        );
        expect(user.boldnessScore, 0);
      });

      test('calculates correctly', () {
        // avgWager = 500 / 10 = 50, ratio = 50 / 1000 = 0.05, * 100 = 5.0
        const user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 1000,
          predictionsCount: 10,
          totalWagered: 500,
        );
        expect(user.boldnessScore, 5.0);
      });

      test('high boldness for aggressive bettor', () {
        // avgWager = 900 / 3 = 300, ratio = 300 / 100 = 3, * 100 = 300
        const user = AppUser(
          uid: 'u1',
          displayName: 'Test',
          school: 'HS',
          tokens: 100,
          predictionsCount: 3,
          totalWagered: 900,
        );
        expect(user.boldnessScore, 300.0);
      });
    });
  });

  // =========================================================================
  // LeaderboardEntry
  // =========================================================================
  group('LeaderboardEntry', () {
    test('fromJson parses all fields', () {
      final entry = LeaderboardEntry.fromJson({
        'rank': 1,
        'uid': 'u1',
        'displayName': 'Alice',
        'school': 'Central HS',
        'state': 'Texas',
        'tokens': 5000,
        'winRate': 72.5,
        'boldness': 15.3,
      });
      expect(entry.rank, 1);
      expect(entry.uid, 'u1');
      expect(entry.displayName, 'Alice');
      expect(entry.school, 'Central HS');
      expect(entry.state, 'Texas');
      expect(entry.tokens, 5000);
      expect(entry.winRate, 72.5);
      expect(entry.boldness, 15.3);
    });

    test('fromJson defaults state to empty string', () {
      final entry = LeaderboardEntry.fromJson({
        'rank': 2,
        'uid': 'u2',
        'displayName': 'Bob',
        'school': 'HS',
        'tokens': 1000,
      });
      expect(entry.state, '');
    });

    test('fromJson defaults winRate and boldness to 0', () {
      final entry = LeaderboardEntry.fromJson({
        'rank': 3,
        'uid': 'u3',
        'displayName': 'Charlie',
        'school': 'HS',
        'tokens': 2000,
      });
      expect(entry.winRate, 0);
      expect(entry.boldness, 0);
    });

    test('fromJson handles int winRate and boldness', () {
      final entry = LeaderboardEntry.fromJson({
        'rank': 1,
        'uid': 'u1',
        'displayName': 'Alice',
        'school': 'HS',
        'tokens': 1000,
        'winRate': 50,
        'boldness': 10,
      });
      expect(entry.winRate, 50.0);
      expect(entry.boldness, 10.0);
    });
  });

  // =========================================================================
  // AggregateEntry
  // =========================================================================
  group('AggregateEntry', () {
    test('fromJson parses all fields', () {
      final entry = AggregateEntry.fromJson({
        'rank': 1,
        'name': 'Central HS',
        'totalTokens': 15000,
        'avgWinRate': 65.0,
        'avgBoldness': 12.5,
        'playerCount': 10,
        'schoolCount': 3,
      });
      expect(entry.rank, 1);
      expect(entry.name, 'Central HS');
      expect(entry.totalTokens, 15000);
      expect(entry.avgWinRate, 65.0);
      expect(entry.avgBoldness, 12.5);
      expect(entry.playerCount, 10);
      expect(entry.schoolCount, 3);
    });

    test('fromJson falls back name to school key', () {
      final entry = AggregateEntry.fromJson({
        'rank': 2,
        'school': 'East HS',
        'totalTokens': 8000,
        'avgWinRate': 55.0,
        'avgBoldness': 8.0,
        'playerCount': 5,
      });
      expect(entry.name, 'East HS');
    });

    test('fromJson falls back name to state key', () {
      final entry = AggregateEntry.fromJson({
        'rank': 3,
        'state': 'Colorado',
        'totalTokens': 20000,
        'avgWinRate': 60.0,
        'avgBoldness': 10.0,
        'playerCount': 25,
      });
      expect(entry.name, 'Colorado');
    });

    test('fromJson schoolCount is optional', () {
      final entry = AggregateEntry.fromJson({
        'rank': 1,
        'name': 'Team A',
        'totalTokens': 5000,
        'avgWinRate': 50.0,
        'avgBoldness': 5.0,
        'playerCount': 3,
      });
      expect(entry.schoolCount, isNull);
    });

    test('fromJson handles int avgWinRate and avgBoldness', () {
      final entry = AggregateEntry.fromJson({
        'rank': 1,
        'name': 'Team B',
        'totalTokens': 5000,
        'avgWinRate': 50,
        'avgBoldness': 10,
        'playerCount': 3,
      });
      expect(entry.avgWinRate, 50.0);
      expect(entry.avgBoldness, 10.0);
    });
  });

  // =========================================================================
  // ChallengeStatus
  // =========================================================================
  group('ChallengeStatus', () {
    test('fromString parses all camelCase values', () {
      expect(ChallengeStatus.fromString('pending'), ChallengeStatus.pending);
      expect(
          ChallengeStatus.fromString('accepted'), ChallengeStatus.accepted);
      expect(
          ChallengeStatus.fromString('declined'), ChallengeStatus.declined);
      expect(ChallengeStatus.fromString('awaitingOutcome'),
          ChallengeStatus.awaitingOutcome);
      expect(
          ChallengeStatus.fromString('disputed'), ChallengeStatus.disputed);
      expect(ChallengeStatus.fromString('settled'), ChallengeStatus.settled);
      expect(ChallengeStatus.fromString('expired'), ChallengeStatus.expired);
    });

    test('fromString parses snake_case awaiting_outcome', () {
      expect(ChallengeStatus.fromString('awaiting_outcome'),
          ChallengeStatus.awaitingOutcome);
    });

    test('fromString defaults to pending for unknown value', () {
      expect(
          ChallengeStatus.fromString('unknown'), ChallengeStatus.pending);
      expect(ChallengeStatus.fromString(''), ChallengeStatus.pending);
    });
  });

  // =========================================================================
  // ChallengeOutcome
  // =========================================================================
  group('ChallengeOutcome', () {
    test('fromString parses camelCase values', () {
      expect(ChallengeOutcome.fromString('fromWins'),
          ChallengeOutcome.fromWins);
      expect(
          ChallengeOutcome.fromString('toWins'), ChallengeOutcome.toWins);
      expect(ChallengeOutcome.fromString('push'), ChallengeOutcome.push);
    });

    test('fromString parses snake_case values', () {
      expect(ChallengeOutcome.fromString('from_wins'),
          ChallengeOutcome.fromWins);
      expect(
          ChallengeOutcome.fromString('to_wins'), ChallengeOutcome.toWins);
    });

    test('fromString returns null for unknown value', () {
      expect(ChallengeOutcome.fromString('unknown'), isNull);
      expect(ChallengeOutcome.fromString(''), isNull);
    });

    test('fromString returns null for null input', () {
      expect(ChallengeOutcome.fromString(null), isNull);
    });
  });

  // =========================================================================
  // ChallengeModel
  // =========================================================================
  group('ChallengeModel', () {
    // Helper: build a ChallengeModel directly (avoids ChallengeCategory
    // Flutter import issues).
    ChallengeModel makeChallenge({
      String id = 'c1',
      String fromUid = 'alice',
      String fromName = 'Alice',
      String toUid = 'bob',
      String toName = 'Bob',
      ChallengeStatus status = ChallengeStatus.pending,
      ChallengeOutcome? outcome,
      bool fromConfirmed = false,
      bool toConfirmed = false,
      bool isSettledOffline = false,
      String? matchId,
      int wager = 100,
      DateTime? createdAt,
      DateTime? resolvedAt,
    }) {
      // We use ChallengeCategory.custom via fromDemo as a workaround,
      // but since we cannot import challenge_category.dart, we construct
      // a full ChallengeModel via fromDemo which internally calls
      // ChallengeCategory.fromString.
      // However, the user said NOT to import challenge_category.dart.
      // ChallengeModel's constructor requires ChallengeCategory, which
      // is exported from challenge_model.dart's import. Since the test
      // imports challenge_model.dart which imports challenge_category.dart,
      // we need to use fromDemo to build the model.
      return ChallengeModel.fromDemo({
        'id': id,
        'fromUid': fromUid,
        'fromName': fromName,
        'toUid': toUid,
        'toName': toName,
        'category': 'custom',
        'title': 'Test challenge',
        'matchId': matchId,
        'wager': wager,
        'status': status.name == 'awaitingOutcome'
            ? 'awaitingOutcome'
            : status.name,
        'outcome': outcome?.name == 'fromWins'
            ? 'fromWins'
            : outcome?.name == 'toWins'
                ? 'toWins'
                : outcome?.name == 'push'
                    ? 'push'
                    : null,
        'fromConfirmed': fromConfirmed,
        'toConfirmed': toConfirmed,
        'isSettledOffline': isSettledOffline,
        'createdAt': createdAt ?? DateTime(2026, 6, 15),
        'resolvedAt': resolvedAt,
      });
    }

    ChallengeModel makeSportsChallenge() {
      return ChallengeModel.fromDemo({
        'id': 'c_sports',
        'fromUid': 'alice',
        'fromName': 'Alice',
        'toUid': 'bob',
        'toName': 'Bob',
        'category': 'sports',
        'title': 'Sports challenge',
        'wager': 50,
        'status': 'pending',
        'outcome': null,
        'createdAt': DateTime(2026, 6, 15),
      });
    }

    ChallengeModel makePartyGameChallenge() {
      return ChallengeModel.fromDemo({
        'id': 'c_party',
        'fromUid': 'alice',
        'fromName': 'Alice',
        'toUid': 'bob',
        'toName': 'Bob',
        'category': 'partyGame',
        'title': 'Party challenge',
        'wager': 25,
        'status': 'accepted',
        'outcome': null,
        'createdAt': DateTime(2026, 6, 15),
      });
    }

    test('fromDemo parses all fields', () {
      final c = makeChallenge();
      expect(c.id, 'c1');
      expect(c.fromUid, 'alice');
      expect(c.fromName, 'Alice');
      expect(c.toUid, 'bob');
      expect(c.toName, 'Bob');
      expect(c.title, 'Test challenge');
      expect(c.wager, 100);
      expect(c.status, ChallengeStatus.pending);
      expect(c.outcome, isNull);
      expect(c.fromConfirmed, isFalse);
      expect(c.toConfirmed, isFalse);
      expect(c.isSettledOffline, isFalse);
      expect(c.resolvedAt, isNull);
    });

    test('fromDemo parses DateTime createdAt', () {
      final c = makeChallenge(createdAt: DateTime(2026, 1, 1));
      expect(c.createdAt, DateTime(2026, 1, 1));
    });

    test('fromDemo parses String createdAt', () {
      final c = ChallengeModel.fromDemo({
        'id': 'c_str',
        'fromUid': 'alice',
        'fromName': 'Alice',
        'toUid': 'bob',
        'toName': 'Bob',
        'category': 'custom',
        'title': 'Test',
        'wager': 10,
        'status': 'pending',
        'outcome': null,
        'createdAt': '2026-03-01T10:00:00.000',
      });
      expect(c.createdAt, DateTime.parse('2026-03-01T10:00:00.000'));
    });

    test('fromDemo parses resolvedAt', () {
      final c = ChallengeModel.fromDemo({
        'id': 'c_res',
        'fromUid': 'alice',
        'fromName': 'Alice',
        'toUid': 'bob',
        'toName': 'Bob',
        'category': 'custom',
        'title': 'Test',
        'wager': 10,
        'status': 'settled',
        'outcome': 'fromWins',
        'createdAt': DateTime(2026, 6, 1),
        'resolvedAt': '2026-06-02T00:00:00.000',
      });
      expect(c.resolvedAt, DateTime.parse('2026-06-02T00:00:00.000'));
    });

    group('category getters', () {
      test('isCustom is true for custom category', () {
        final c = makeChallenge();
        expect(c.isCustom, isTrue);
        expect(c.isSports, isFalse);
        expect(c.isPartyGame, isFalse);
      });

      test('isSports is true for sports category', () {
        final c = makeSportsChallenge();
        expect(c.isSports, isTrue);
        expect(c.isCustom, isFalse);
        expect(c.isPartyGame, isFalse);
      });

      test('isPartyGame is true for partyGame category', () {
        final c = makePartyGameChallenge();
        expect(c.isPartyGame, isTrue);
        expect(c.isCustom, isFalse);
        expect(c.isSports, isFalse);
      });
    });

    group('status getters', () {
      test('isPending', () {
        final c = makeChallenge(status: ChallengeStatus.pending);
        expect(c.isPending, isTrue);
        expect(c.isActive, isFalse);
        expect(c.isResolved, isFalse);
      });

      test('isActive for accepted', () {
        final c = makeChallenge(status: ChallengeStatus.accepted);
        expect(c.isActive, isTrue);
        expect(c.isPending, isFalse);
      });

      test('isActive for awaitingOutcome', () {
        final c = makeChallenge(status: ChallengeStatus.awaitingOutcome);
        expect(c.isActive, isTrue);
      });

      test('isResolved for settled', () {
        final c = makeChallenge(status: ChallengeStatus.settled);
        expect(c.isResolved, isTrue);
        expect(c.isActive, isFalse);
        expect(c.isPending, isFalse);
      });

      test('isDisputed', () {
        final c = makeChallenge(status: ChallengeStatus.disputed);
        expect(c.isDisputed, isTrue);
      });
    });

    group('needsMyConfirmation', () {
      test('returns false when status is not awaitingOutcome', () {
        final c = makeChallenge(status: ChallengeStatus.pending);
        expect(c.needsMyConfirmation('alice'), isFalse);
        expect(c.needsMyConfirmation('bob'), isFalse);
      });

      test('returns true for fromUid when not confirmed', () {
        final c = makeChallenge(
          status: ChallengeStatus.awaitingOutcome,
          fromConfirmed: false,
          toConfirmed: true,
        );
        expect(c.needsMyConfirmation('alice'), isTrue);
      });

      test('returns false for fromUid when already confirmed', () {
        final c = makeChallenge(
          status: ChallengeStatus.awaitingOutcome,
          fromConfirmed: true,
        );
        expect(c.needsMyConfirmation('alice'), isFalse);
      });

      test('returns true for toUid when not confirmed', () {
        final c = makeChallenge(
          status: ChallengeStatus.awaitingOutcome,
          fromConfirmed: true,
          toConfirmed: false,
        );
        expect(c.needsMyConfirmation('bob'), isTrue);
      });

      test('returns false for toUid when already confirmed', () {
        final c = makeChallenge(
          status: ChallengeStatus.awaitingOutcome,
          toConfirmed: true,
        );
        expect(c.needsMyConfirmation('bob'), isFalse);
      });

      test('returns false for unrelated uid', () {
        final c = makeChallenge(
          status: ChallengeStatus.awaitingOutcome,
        );
        expect(c.needsMyConfirmation('charlie'), isFalse);
      });
    });

    group('winnerUid', () {
      test('returns fromUid when fromWins', () {
        final c = makeChallenge(outcome: ChallengeOutcome.fromWins);
        expect(c.winnerUid, 'alice');
      });

      test('returns toUid when toWins', () {
        final c = makeChallenge(outcome: ChallengeOutcome.toWins);
        expect(c.winnerUid, 'bob');
      });

      test('returns null when push', () {
        final c = makeChallenge(outcome: ChallengeOutcome.push);
        expect(c.winnerUid, isNull);
      });

      test('returns null when no outcome', () {
        final c = makeChallenge(outcome: null);
        expect(c.winnerUid, isNull);
      });
    });

    group('didWin', () {
      test('returns true for winner', () {
        final c = makeChallenge(outcome: ChallengeOutcome.fromWins);
        expect(c.didWin('alice'), isTrue);
        expect(c.didWin('bob'), isFalse);
      });

      test('returns false for push', () {
        final c = makeChallenge(outcome: ChallengeOutcome.push);
        expect(c.didWin('alice'), isFalse);
        expect(c.didWin('bob'), isFalse);
      });
    });

    group('didLose', () {
      test('returns true for loser', () {
        final c = makeChallenge(outcome: ChallengeOutcome.fromWins);
        expect(c.didLose('bob'), isTrue);
        expect(c.didLose('alice'), isFalse);
      });

      test('returns false for push', () {
        final c = makeChallenge(outcome: ChallengeOutcome.push);
        expect(c.didLose('alice'), isFalse);
        expect(c.didLose('bob'), isFalse);
      });

      test('returns false for null outcome', () {
        final c = makeChallenge(outcome: null);
        expect(c.didLose('alice'), isFalse);
      });

      test('returns false for unrelated uid', () {
        final c = makeChallenge(outcome: ChallengeOutcome.fromWins);
        expect(c.didLose('charlie'), isFalse);
      });
    });

    group('opponentName / opponentUid', () {
      test('returns toName for fromUid', () {
        final c = makeChallenge();
        expect(c.opponentName('alice'), 'Bob');
        expect(c.opponentUid('alice'), 'bob');
      });

      test('returns fromName for toUid', () {
        final c = makeChallenge();
        expect(c.opponentName('bob'), 'Alice');
        expect(c.opponentUid('bob'), 'alice');
      });
    });

    group('isMine', () {
      test('returns true for fromUid', () {
        final c = makeChallenge();
        expect(c.isMine('alice'), isTrue);
      });

      test('returns false for toUid', () {
        final c = makeChallenge();
        expect(c.isMine('bob'), isFalse);
      });
    });

    group('copyWith', () {
      test('copies with updated status', () {
        final c = makeChallenge(status: ChallengeStatus.pending);
        final updated = c.copyWith(status: ChallengeStatus.accepted);
        expect(updated.status, ChallengeStatus.accepted);
        expect(updated.id, c.id);
        expect(updated.fromUid, c.fromUid);
        expect(updated.wager, c.wager);
      });

      test('copies with updated outcome', () {
        final c = makeChallenge();
        final updated = c.copyWith(outcome: ChallengeOutcome.fromWins);
        expect(updated.outcome, ChallengeOutcome.fromWins);
        expect(updated.status, c.status);
      });

      test('copies with updated confirmation flags', () {
        final c = makeChallenge();
        final updated = c.copyWith(
          fromConfirmed: true,
          toConfirmed: true,
        );
        expect(updated.fromConfirmed, isTrue);
        expect(updated.toConfirmed, isTrue);
      });

      test('copies with updated isSettledOffline', () {
        final c = makeChallenge();
        final updated = c.copyWith(isSettledOffline: true);
        expect(updated.isSettledOffline, isTrue);
      });

      test('copies with updated resolvedAt', () {
        final c = makeChallenge();
        final now = DateTime.now();
        final updated = c.copyWith(resolvedAt: now);
        expect(updated.resolvedAt, now);
      });

      test('preserves all fields when no arguments', () {
        final c = makeChallenge(
          status: ChallengeStatus.settled,
          outcome: ChallengeOutcome.fromWins,
          fromConfirmed: true,
          toConfirmed: true,
          isSettledOffline: true,
          resolvedAt: DateTime(2026, 7, 1),
        );
        final copy = c.copyWith();
        expect(copy.id, c.id);
        expect(copy.fromUid, c.fromUid);
        expect(copy.fromName, c.fromName);
        expect(copy.toUid, c.toUid);
        expect(copy.toName, c.toName);
        expect(copy.title, c.title);
        expect(copy.wager, c.wager);
        expect(copy.status, c.status);
        expect(copy.outcome, c.outcome);
        expect(copy.fromConfirmed, c.fromConfirmed);
        expect(copy.toConfirmed, c.toConfirmed);
        expect(copy.isSettledOffline, c.isSettledOffline);
        expect(copy.createdAt, c.createdAt);
        expect(copy.resolvedAt, c.resolvedAt);
      });
    });
  });

  // =========================================================================
  // GroupStanding / GroupTeamEntry
  // =========================================================================
  group('GroupStanding', () {
    test('fromJson parses name and teams', () {
      final standing = GroupStanding.fromJson({
        'name': 'Group A',
        'teams': [
          {
            'rank': 1,
            'team': {'id': 1, 'name': 'Brazil', 'logo': 'br.png'},
            'points': 9,
            'played': 3,
            'won': 3,
            'drawn': 0,
            'lost': 0,
            'goalsFor': 7,
            'goalsAgainst': 1,
            'goalDiff': 6,
          },
          {
            'rank': 2,
            'team': {'id': 2, 'name': 'Mexico', 'logo': 'mx.png'},
            'points': 6,
            'played': 3,
            'won': 2,
            'drawn': 0,
            'lost': 1,
            'goalsFor': 4,
            'goalsAgainst': 3,
            'goalDiff': 1,
          },
        ],
      });
      expect(standing.name, 'Group A');
      expect(standing.teams.length, 2);
      expect(standing.teams[0].team.name, 'Brazil');
      expect(standing.teams[1].team.name, 'Mexico');
    });

    test('fromJson with empty teams list', () {
      final standing = GroupStanding.fromJson({
        'name': 'Group B',
        'teams': [],
      });
      expect(standing.name, 'Group B');
      expect(standing.teams, isEmpty);
    });
  });

  group('GroupTeamEntry', () {
    test('fromJson parses all fields', () {
      final entry = GroupTeamEntry.fromJson({
        'rank': 1,
        'team': {'id': 10, 'name': 'Germany', 'logo': 'de.png'},
        'points': 7,
        'played': 3,
        'won': 2,
        'drawn': 1,
        'lost': 0,
        'goalsFor': 5,
        'goalsAgainst': 2,
        'goalDiff': 3,
      });
      expect(entry.rank, 1);
      expect(entry.team.id, 10);
      expect(entry.team.name, 'Germany');
      expect(entry.team.logo, 'de.png');
      expect(entry.points, 7);
      expect(entry.played, 3);
      expect(entry.won, 2);
      expect(entry.drawn, 1);
      expect(entry.lost, 0);
      expect(entry.goalsFor, 5);
      expect(entry.goalsAgainst, 2);
      expect(entry.goalDiff, 3);
    });
  });
}
