import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_mcp_figma/network/configuration/api_endpoint.dart';
import 'package:test_mcp_figma/network/configuration/error_interceptor.dart';
import 'package:test_mcp_figma/network/configuration/request_interceptor.dart';
import 'package:test_mcp_figma/network/configuration/response_interceptor.dart';

@singleton
final class DioConfiguration {
  DioConfiguration(this._preferences, this._packageInfo, this._deviceInfo);

  final SharedPreferences _preferences;
  final PackageInfo _packageInfo;
  final DeviceInfoPlugin _deviceInfo;

  /// Dio for the main App services
  Dio getAppDio() {
    return _createDio(baseUrl: ApiEndpoint.baseUrl, isHub: false);
  }

  /// Dio for the central Hub services (Ads, Installs)
  Dio getHubDio() {
    return _createDio(baseUrl: HubEndpoint.baseUrl, isHub: true);
  }

  Dio _createDio({required String baseUrl, required bool isHub}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.addAll([
      RequestInterceptor(
        preferences: _preferences,
        type: isHub ? .hub : .app,
        packageInfo: _packageInfo,
        deviceInfo: _deviceInfo,
      ),
      ErrorInterceptor(dio: dio, preferences: _preferences),
      const ResponseInterceptor(),
      LogInterceptor(
        error: true,
        requestHeader: false,
        requestBody: true,
        responseBody: false,
      ),
    ]);

    return dio;
  }
}
