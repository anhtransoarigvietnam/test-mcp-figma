import 'package:test_mcp_figma/network/configuration/network_configuration.dart';

/// Providing base URL and all API endpoints.
final class ApiEndpoint {
  /// URL without version
  static String get rawUrl => NetworkConfiguration.apiUrl;

  /// Full base URL loaded from `.env` + version
  static String get baseUrl => '${NetworkConfiguration.apiUrl}/api/v1';

  // TODO: Update token
  static const String refreshToken = '/users/refresh-token/';
}

final class HubEndpoint {
  const HubEndpoint._();

  static String get baseUrl => '${NetworkConfiguration.hubApiUrl}/api/v1';

  static const String frequency = '/apps/frequency';
  static const String installs = '/installs';
  static const String ads = '/apps/ads';
  static const String adsEvent = '/apps/ads-event';
}
