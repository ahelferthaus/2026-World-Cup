import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_endpoints.dart';
import '../domain/standing_model.dart';

class StandingsRepository {
  final http.Client _client;

  StandingsRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<GroupStanding>> fetchStandings(String idToken) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.standings}');

    final response = await _client.get(
      url,
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch standings: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final groupsList = data['groups'] as List;

    return groupsList
        .map((g) => GroupStanding.fromJson(g as Map<String, dynamic>))
        .toList();
  }
}
