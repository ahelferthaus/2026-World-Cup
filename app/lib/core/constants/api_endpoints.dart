class ApiEndpoints {
  ApiEndpoints._();

  // TODO: Replace with your deployed Cloud Functions URL after firebase deploy
  // Format: https://<region>-<project-id>.cloudfunctions.net
  static const String baseUrl = 'https://us-central1-pokin-tokens.cloudfunctions.net';

  // For local development with Firebase emulators
  static const String emulatorBaseUrl = 'http://localhost:5001/pokin-tokens/us-central1';

  static const String matchesToday = '/matchesToday';
  static const String standings = '/standings';
  static const String createPrediction = '/createPrediction';
  static const String leaderboardGlobal = '/leaderboardGlobal';
  static const String leaderboardSchool = '/leaderboardSchool';
}
