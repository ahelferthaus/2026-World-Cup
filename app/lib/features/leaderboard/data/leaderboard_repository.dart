import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_endpoints.dart';
import '../domain/leaderboard_entry.dart';

class LeaderboardRepository {
  final http.Client _client;

  LeaderboardRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<LeaderboardEntry>> fetchGlobalLeaderboard(String idToken) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.leaderboardGlobal}');

    final response = await _client.get(
      url,
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch leaderboard: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['leaderboard'] as List;

    return list
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<LeaderboardEntry>> fetchSchoolLeaderboard(
    String idToken,
    String school,
  ) async {
    final url = Uri.parse(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.leaderboardSchool}?school=${Uri.encodeComponent(school)}',
    );

    final response = await _client.get(
      url,
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch school leaderboard: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['leaderboard'] as List;

    return list
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
