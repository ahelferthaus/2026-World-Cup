import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_endpoints.dart';
import '../domain/prediction_model.dart';

class PredictionsRepository {
  final http.Client _client;
  final FirebaseFirestore _firestore;

  PredictionsRepository({
    http.Client? client,
    FirebaseFirestore? firestore,
  })  : _client = client ?? http.Client(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createPrediction({
    required String idToken,
    required String matchId,
    required String type,
    required String selection,
    required int wager,
    int? scoreHome,
    int? scoreAway,
  }) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.createPrediction}');

    final body = <String, dynamic>{
      'matchId': matchId,
      'type': type,
      'selection': selection,
      'wager': wager,
    };

    if (type == 'exactScore') {
      body['scoreHome'] = scoreHome;
      body['scoreAway'] = scoreAway;
    }

    final response = await _client.post(
      url,
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['predictionId'] as String;
    }

    final error = jsonDecode(response.body)['error'] as String? ?? 'Unknown error';
    throw Exception(error);
  }

  Future<List<PredictionModel>> fetchUserPredictions(String uid) async {
    final snapshot = await _firestore
        .collection('predictions')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PredictionModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
