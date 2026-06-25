final class NetworkConstant {
  const NetworkConstant._();

  static const pagination = 'pagination';
  static const retryCount = 'retryCount';
  static const refreshed = 'refreshed';

  // Annotation keys
  static const skipEnvelope = 'skipEnvelopeKey';
  static const skipAuthApi = 'skipAuthApiKey';
  static const injectHubQuery = 'injectHubQueryKey';
  static const injectHubBodyHostAppId = 'injectHubBodyHostAppIdKey';
  static const injectHubBodyAppId = 'injectHubBodyAppIdKey';
  static const injectDeviceUuidQuery = 'injectDeviceUuidQueryKey';
  static const injectDeviceUuidBody = 'injectDeviceUuidBodyKey';

  // Headers
  static const apiKeyHeader = 'X-Api-Key';
  static const authorizationHeader = 'Authorization';

  // Request & Params keys
  static const appIdKey = 'app_id';
  static const hostAppIdKey = 'host_app_id';
  static const platformKey = 'platform';
  static const queryDeviceUuid = 'uuid';
  static const bodyDeviceUuid = 'uuid';
  static const refreshKey = 'refresh';

  // Platform values
  static const platformIOS = 'IOS';
  static const platformAndroid = 'ANDROID';

  // SharedPreferences keys
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  static const userKey = 'user';
}
