import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_endpoints.dart';
import '../domain/match_model.dart';

class MatchesRepository {
  final http.Client _client;

  MatchesRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<MatchModel>> fetchTodayMatches(String idToken) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.matchesToday}');

    final response = await _client.get(
      url,
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch matches: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final matchesList = data['matches'] as List;

    return matchesList
        .map((m) => MatchModel.fromJson(m as Map<String, dynamic>))
        .toList();
  }
}
