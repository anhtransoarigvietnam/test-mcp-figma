import 'package:dio/dio.dart';
import 'package:test_mcp_figma/network/utility/constant/network_constant.dart';
import 'package:test_mcp_figma/network/utility/extension/http_response_extension.dart';
import 'package:test_mcp_figma/network/utility/helper/network_response.dart';

/// Normalizes API response envelopes.
class ResponseInterceptor extends Interceptor {
  const ResponseInterceptor();

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    // If the request explicitly asks to skip envelope parsing,
    // just forward the original response through the chain unchanged.
    if (response.shouldSkipEnvelope) {
      handler.next(response);
      return;
    }

    // The response body must be a Map (i.e. decoded JSON expected as an envelope).
    final body = response.data;
    if (body is! Map<String, dynamic>) {
      // If it's not a Map (e.g., plain string, bytes, or already-extracted data), forward as-is.
      handler.next(response);
      return;
    }

    // Parse the response envelope using the strongly-typed NetworkResponse class.
    final parsedBody = NetworkResponse.fromJson(body);

    if (parsedBody != null) {
      // Replace the response's data with the 'data' field from the envelope,
      // so downstream consumers get directly the inner payload.
      response.data = parsedBody.data;
      // Attach pagination info (if any) into response.extra for later extension access.
      response.extra[NetworkConstant.pagination] = parsedBody.pagination;
      handler.next(response);
      return;
    }

    // If parsing somehow produced null, just forward the response.
    handler.next(response);
  }
}
