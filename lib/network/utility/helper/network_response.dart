import 'package:json_annotation/json_annotation.dart';

part 'network_response.g.dart';

/// Represents a network response envelope from the backend.
@JsonSerializable(createToJson: false)
final class NetworkResponse {
  const NetworkResponse({this.data, this.error, this.pagination, this.meta});

  /// Optional data payload.
  final dynamic data;

  /// Optional error response.
  final NetworkErrorResponse? error;

  /// Optional pagination information.
  final NetworkPaginationResponse? pagination;

  /// Additional processed data from backend.
  final Map<String, dynamic>? meta;

  /// Parses JSON into [NetworkResponse], returns null when invalid.
  static NetworkResponse? fromJson(Map<String, dynamic> json) {
    try {
      return _$NetworkResponseFromJson(json);
    } catch (_) {
      return null;
    }
  }
}

/// Represents pagination metadata from backend envelopes.
@JsonSerializable(createToJson: false)
final class NetworkPaginationResponse {
  /// Total item count.
  final int? total;

  /// Total page count.
  @JsonKey(name: 'total_pages')
  final int? totalPages;

  /// Current page.
  final int? page;

  /// Item count in current page.
  @JsonKey(name: 'page_size')
  final int? pageSize;

  /// Next cursor.
  final String? next;

  /// Previous cursor.
  final String? previous;

  const NetworkPaginationResponse({
    required this.total,
    required this.totalPages,
    required this.page,
    required this.pageSize,
    required this.next,
    required this.previous,
  });

  factory NetworkPaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$NetworkPaginationResponseFromJson(json);
}

/// Represents an error response from the network layer.
@JsonSerializable(createToJson: false)
final class NetworkErrorResponse {
  /// Error type or classification.
  final String? type;

  /// Human readable message.
  final String? message;

  /// Optional per-field details for validation errors.
  final Map<String, dynamic>? fields;

  const NetworkErrorResponse({
    required this.type,
    required this.message,
    required this.fields,
  });

  factory NetworkErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$NetworkErrorResponseFromJson(json);
}
