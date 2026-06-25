import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Providing access to network secret properties
final class NetworkConfiguration {
  const NetworkConfiguration._();

  // App specific keys
  static String get apiUrl => dotenv.env['APP_BASE_URL'] ?? '';
  static String get appApiKey => dotenv.env['APP_API_KEY'] ?? '';

  static String get hubApiUrl => dotenv.env['HUB_BASE_URL'] ?? '';
  static String get hubApiKey => dotenv.env['HUB_API_KEY'] ?? '';

  // Google Sign In key
  static String get googleWebClientId =>
      dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';
}
