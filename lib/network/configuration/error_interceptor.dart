import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_mcp_figma/network/configuration/api_endpoint.dart';
import 'package:test_mcp_figma/network/dto/response/auth_response_dto.dart';
import 'package:test_mcp_figma/network/utility/constant/network_constant.dart';
import 'package:test_mcp_figma/network/utility/extension/http_response_extension.dart';
import 'package:test_mcp_figma/network/utility/helper/network_response.dart';

/// A Dio interceptor to handle network errors and retries.
///
/// If error is 401, it does not retry.
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({required Dio dio, required SharedPreferences preferences})
    : _dio = dio,
      _preferences = preferences;

  final SharedPreferences _preferences;
  final Dio _dio;
  late final Dio _refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
  static const int _maxRetryCount = 3;
  static const Duration _retryDelay = Duration(milliseconds: 500);
  bool _isRefreshing = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Normalize no internet / socket failures.
    if (_isConnectionError(err)) {
      return handler.next(
        DioException(
          requestOptions: err.requestOptions,
          type: DioExceptionType.connectionError,
          error: err.error,
          stackTrace: err.stackTrace,
        ),
      );
    }

    // TODO: Remove handle refresh token if app not include login feature
    /// Handle unauthorized -> refresh token
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      final response = await _handleRefreshToken(err);

      if (response != null) {
        return handler.resolve(response);
      }

      return handler.next(err);
    }

    /// Handle internal server error
    if (err.response?.statusCode == HttpStatus.forbidden ||
        err.response?.statusCode == HttpStatus.internalServerError) {
      return handler.next(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: err.error,
          stackTrace: err.stackTrace,
        ),
      );
    }

    // Retry transient failures.
    if (_shouldRetry(err)) {
      final response = await _retry(err);

      if (response != null) {
        return handler.resolve(response);
      }
    }

    // Normalize timeout errors after retries are exhausted.
    if (_isTimeoutError(err)) {
      return handler.next(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: err.error,
          stackTrace: err.stackTrace,
        ),
      );
    }

    // Parse backend error envelope if available.
    if (!err.shouldSkipEnvelope) {
      final parsedError = _parseErrorEnvelope(err);

      if (parsedError != null) {
        return handler.next(parsedError);
      }
    }

    // Fallback to original error.
    return handler.next(err);
  }

  /// Whether the error is retryable.
  bool _shouldRetry(DioException err) {
    return _isTimeoutError(err);
  }

  /// Whether the error is caused by connectivity issues.
  bool _isConnectionError(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.error is SocketException;
  }

  /// Whether the error is timeout related.
  bool _isTimeoutError(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;
  }

  /// Attempts to retry the failed request.
  Future<Response<dynamic>?> _retry(DioException err) async {
    final options = err.requestOptions;

    final retryCount = (options.extra[NetworkConstant.retryCount] ?? 0) as int;

    if (retryCount >= _maxRetryCount) {
      return null;
    }

    try {
      options.extra[NetworkConstant.retryCount] = retryCount + 1;

      await Future<void>.delayed(_retryDelay);

      return await _dio.fetch(options);
    } on DioException {
      return null;
    }
  }

  /// Attempts to parse backend error envelope.
  DioException? _parseErrorEnvelope(DioException err) {
    final body = err.response?.data;

    if (body is! Map<String, dynamic>) {
      return null;
    }

    final parsedBody = NetworkResponse.fromJson(body);

    if (parsedBody?.error == null) {
      return null;
    }

    return DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: parsedBody!.error!.fields ?? err.error,
      stackTrace: err.stackTrace,
      message: parsedBody.error!.message ?? err.message,
    );
  }

  /// Handle unauthorized -> refresh token
  Future<Response<dynamic>?> _handleRefreshToken(DioException err) async {
    // Prevent infinite loop
    final isRefreshRequest =
        err.requestOptions.path == ApiEndpoint.refreshToken;

    // Skip if refresh token is being requested
    if (isRefreshRequest ||
        _isRefreshing ||
        err.requestOptions.extra[NetworkConstant.refreshed] == true) {
      return null;
    }

    _isRefreshing = true;

    try {
      // Call refresh token API
      final newAccessToken = await _refreshToken();

      // If refresh token is null, return null
      if (newAccessToken == null) {
        return null;
      }

      // Update request options
      final requestOptions = err.requestOptions;

      requestOptions.extra[NetworkConstant.refreshed] = true;
      requestOptions.headers[NetworkConstant.authorizationHeader] =
          'Bearer $newAccessToken';

      // Retry the request
      return await _dio.fetch(requestOptions);
    } catch (_) {
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Refresh token
  Future<String?> _refreshToken() async {
    // Get refresh token from SharedPreferences
    final refreshToken = _preferences.getString(
      NetworkConstant.refreshTokenKey,
    );

    if (refreshToken == null) {
      return null;
    }

    // Call refresh token API
    final response = await _refreshDio.post(
      ApiEndpoint.refreshToken,
      data: {NetworkConstant.refreshKey: refreshToken},
    );

    // Parse response
    final authResponse = AuthResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );

    // Save new access token and refresh token
    await Future.wait([
      _preferences.setString(
        NetworkConstant.accessTokenKey,
        authResponse.accessToken,
      ),
      _preferences.setString(
        NetworkConstant.refreshTokenKey,
        authResponse.refreshToken,
      ),
    ]);

    return authResponse.accessToken;
  }
}
