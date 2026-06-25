import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:test_mcp_figma/network/configuration/network_configuration.dart';
import 'package:test_mcp_figma/network/configuration/request_type.dart';
import 'package:test_mcp_figma/network/utility/constant/network_constant.dart';

/// Injects authentication headers and metadata into outgoing requests.
class RequestInterceptor extends Interceptor {
  RequestInterceptor({
    required this.preferences,
    required this.packageInfo,
    required this.deviceInfo,
    this.type = .app,
  });

  final SharedPreferences preferences;
  final PackageInfo packageInfo;
  final RequestType type;
  final DeviceInfoPlugin deviceInfo;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip authentication and metadata injection if explicitly disabled.
    if (_shouldSkipAuth(options)) {
      return handler.next(options);
    }

    _injectApiKey(options);
    _injectAccessToken(options);

    await _injectMetadata(options);

    return handler.next(options);
  }

  bool _shouldSkipAuth(RequestOptions options) {
    return options.extra[NetworkConstant.skipAuthApi] == true;
  }

  /// Injects API key based on the request type.
  void _injectApiKey(RequestOptions options) {
    final apiKey = switch (type) {
      RequestType.app => NetworkConfiguration.appApiKey,
      RequestType.hub => NetworkConfiguration.hubApiKey,
    };

    if (apiKey.isEmpty) return;

    options.headers[NetworkConstant.apiKeyHeader] = apiKey;
  }

  /// Injects bearer token if available.
  void _injectAccessToken(RequestOptions options) {
    final accessToken = preferences.getString(NetworkConstant.accessTokenKey);

    if (accessToken == null || accessToken.isEmpty) return;

    options.headers[NetworkConstant.authorizationHeader] =
        'Bearer $accessToken';
  }

  /// Injects app metadata into query parameters or request body.
  Future<void> _injectMetadata(RequestOptions options) async {
    final shouldInjectQuery =
        options.extra[NetworkConstant.injectHubQuery] == true;

    final bodyKey = _resolveBodyKey(options);

    final shouldInjectDeviceUuidQuery =
        options.extra[NetworkConstant.injectDeviceUuidQuery] == true;
    final shouldInjectDeviceUuidBody =
        options.extra[NetworkConstant.injectDeviceUuidBody] == true;

    if (!shouldInjectQuery &&
        bodyKey == null &&
        !shouldInjectDeviceUuidQuery &&
        !shouldInjectDeviceUuidBody) {
      return;
    }

    if (shouldInjectDeviceUuidQuery || shouldInjectDeviceUuidBody) {
      String deviceUuid = '';
      try {
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          deviceUuid = androidInfo.id;
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          deviceUuid = iosInfo.identifierForVendor ?? '';
        }
      } catch (_) {}

      if (deviceUuid.isNotEmpty) {
        if (shouldInjectDeviceUuidQuery) {
          options.queryParameters[NetworkConstant.queryDeviceUuid] = deviceUuid;
        }
        if (shouldInjectDeviceUuidBody) {
          final requestData = options.data;
          final bodyData = {NetworkConstant.bodyDeviceUuid: deviceUuid};
          if (requestData is Map<String, dynamic>) {
            requestData.addAll(bodyData);
          } else if (requestData is FormData) {
            final hasDeviceUuid = requestData.fields.any(
              (field) => field.key == NetworkConstant.bodyDeviceUuid,
            );

            if (!hasDeviceUuid) {
              requestData.fields.add(
                MapEntry(NetworkConstant.bodyDeviceUuid, deviceUuid),
              );
            }
          } else if (requestData == null) {
            options.data = bodyData;
          }
        }
      }
    }

    if (shouldInjectQuery || bodyKey != null) {
      final appId = packageInfo.packageName;
      final platform = Platform.isIOS
          ? NetworkConstant.platformIOS
          : NetworkConstant.platformAndroid;

      final metadata = <String, dynamic>{NetworkConstant.platformKey: platform};

      // Inject query parameters.
      if (shouldInjectQuery) {
        options.queryParameters.addAll({
          NetworkConstant.appIdKey: appId,
          ...metadata,
        });
      }

      // Inject request body.
      if (bodyKey != null) {
        final bodyData = {bodyKey: appId, ...metadata};

        final requestData = options.data;

        if (requestData is Map<String, dynamic>) {
          requestData.addAll(bodyData);
        } else if (requestData == null) {
          options.data = bodyData;
        }
      }
    }
  }

  /// Resolves which body key should receive the app id.
  String? _resolveBodyKey(RequestOptions options) {
    if (options.extra[NetworkConstant.injectHubBodyHostAppId] == true) {
      return NetworkConstant.hostAppIdKey;
    }

    if (options.extra[NetworkConstant.injectHubBodyAppId] == true) {
      return NetworkConstant.appIdKey;
    }

    return null;
  }
}
