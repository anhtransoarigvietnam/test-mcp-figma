import 'package:dio/dio.dart';

/// Helper class represent either a success data [ok], or error while doing so [error].
///
/// Contains the specified [T] type of success data, or an exception.
sealed class Result<T> {
  const Result();

  // Creates a successful result containing a value
  const factory Result.success(T data) = Success<T>._;

  // Creates an error result containing an Exception
  factory Result.error(Object error) {
    return error is Exception
        ? Error<T>._(error)
        : Error<T>._(Exception(error));
  }
}

/// Success case of [Result], having type [T]
final class Success<T> extends Result<T> {
  const Success._(this.data);
  final T data;

  @override
  String toString() => '$data';
}

/// Error case of [Result], carrying an exeption [T].
///
/// Providing access to [message], [errorDetails] as additional data carried along the error payload
///
/// When using [SkipEnvelope]:
/// [message] is equivalent as that of [NetworkErrorResponse]'s error message, storing error message from server
/// [messageDetails] is equivalent as that of [NetworkErrorResponse]'s [error] object, which is a [Map<String, List<String>>]
final class Error<T> extends Result<T> {
  const Error._(this.error);
  final Exception error;

  @override
  String toString() => '$error';

  /// If is a [DioException] -> try to get the [message] object
  String? get message =>
      error is DioException ? (error as DioException).message : null;

  /// If is a [DioException] -> try to get the [error] object as [Map<String, List<String>>]
  Map<String, List<String>>? get errorDetails {
    final dioError = error is DioException ? error as DioException : null;
    return dioError?.error is Map<String, List<String>>
        ? dioError!.error as Map<String, List<String>>
        : null;
  }
}
