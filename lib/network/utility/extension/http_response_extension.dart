import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:test_mcp_figma/network/utility/constant/network_constant.dart';
import 'package:test_mcp_figma/network/utility/helper/network_response.dart';

extension HttpResponseExtension<T> on HttpResponse<T> {
  /// Returns parsed pagination metadata from response extra map.
  NetworkPaginationResponse? get pagination =>
      response.extra[NetworkConstant.pagination] as NetworkPaginationResponse?;
}

extension DioResponseExtension on Response<dynamic> {
  /// Whether this response skips envelope parsing.
  bool get shouldSkipEnvelope =>
      requestOptions.extra[NetworkConstant.skipEnvelope] == true;
}

extension DioExceptionExtension on DioException {
  /// Whether this request skips envelope parsing.
  bool get shouldSkipEnvelope =>
      requestOptions.extra[NetworkConstant.skipEnvelope] == true;
}
