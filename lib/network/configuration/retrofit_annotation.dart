import 'package:retrofit/retrofit.dart';
import 'package:test_mcp_figma/network/utility/constant/network_constant.dart';

/// Annotation to indicate that a Retrofit request should skip envelope parsing.
///
/// Use this above a Retrofit method to signal that the response is not wrapped
/// in a standard envelope:
///
/// ```dart
/// @SkipEnvelope
/// @GET(ApiEndpoint.product)
/// Future<ProductResponseDto> getProducts();
/// ```
// ignore: constant_identifier_names
const SkipEnvelope = Extra(<String, Object>{
  NetworkConstant.skipEnvelope: true,
});

/// Annotation to indicate that a Retrofit request should skip API key authentication.
///
/// Apply this annotation above a Retrofit method to signal that the request bypasses
/// API key authentication logic:
///
/// ```dart
/// @SkipApiKeyAuth
/// @GET(ApiEndpoint.someEndpoint)
/// Future<ResponseDto> someRequest();
/// ```
// ignore: constant_identifier_names
const SkipAuthApiKey = Extra(<String, Object>{
  NetworkConstant.skipAuthApi: true,
});

/// Annotation to inject 'app_id' and 'platform' into query parameters.
/// Apply this annotation above a Retrofit method to signal that the request injects 'app_id' and 'platform' into query parameters:
/// ```dart
/// @InjectHubQuery
/// @GET(ApiEndpoint.someEndpoint)
/// Future<ResponseDto> someRequest();
/// ```
// ignore: constant_identifier_names
const InjectHubQuery = Extra(<String, Object>{
  NetworkConstant.injectHubQuery: true,
});

/// Annotation to inject 'host_app_id' and 'platform' into body.
/// Apply this annotation above a Retrofit method to signal that the request injects 'app_id' and 'platform' into body:
/// ```dart
/// @InjectHubBody
/// @POST(ApiEndpoint.someEndpoint)
/// Future<ResponseDto> someRequest();
/// ```
// ignore: constant_identifier_names
const InjectHubBodyHostAppId = Extra(<String, Object>{
  NetworkConstant.injectHubBodyHostAppId: true,
});

/// Annotation to inject 'app_id' and 'platform' into body.
/// Apply this annotation above a Retrofit method to signal that the request injects 'app_id' and 'platform' into body:
/// ```dart
/// @InjectHubBody
/// @POST(ApiEndpoint.someEndpoint)
/// Future<ResponseDto> someRequest();
/// ```
// ignore: constant_identifier_names
const InjectHubBodyAppId = Extra(<String, Object>{
  NetworkConstant.injectHubBodyAppId: true,
});

/// Annotation to inject 'device_uuid' into query parameters.
/// Apply this annotation above a Retrofit method to signal that the request injects 'device_uuid' into query parameters:
/// ```dart
/// @InjectDeviceUuidQuery
/// @GET(ApiEndpoint.someEndpoint)
/// Future<ResponseDto> someRequest();
/// ```
// ignore: constant_identifier_names
const InjectDeviceUuidQuery = Extra(<String, Object>{
  NetworkConstant.injectDeviceUuidQuery: true,
});

/// Annotation to inject 'deviceUuid' into body.
/// Apply this annotation above a Retrofit method to signal that the request injects 'deviceUuid' into body:
/// ```dart
/// @InjectDeviceUuidBody
/// @POST(ApiEndpoint.someEndpoint)
/// Future<ResponseDto> someRequest();
/// ```
// ignore: constant_identifier_names
const InjectDeviceUuidBody = Extra(<String, Object>{
  NetworkConstant.injectDeviceUuidBody: true,
});
