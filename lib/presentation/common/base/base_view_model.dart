

// ignore_for_file: unintended_html_in_doc_comment

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_mcp_figma/utility/enumeration/view_status.dart';
import 'package:test_mcp_figma/utility/helper/nullable.dart';
import 'package:test_mcp_figma/utility/helper/result.dart';

/// Base class for all states in view models. Tracks status and error messages.
///
/// All concrete state classes should derive from this and implement [copyWith].
@immutable
abstract class BaseState {
  final ViewStatus status;
  final String? errorMessage;

  const BaseState({this.status = .initial, this.errorMessage});

  /// Concrete subclasses must override to allow easy state modifications.
  BaseState copyWith({ViewStatus? status, Nullable<String>? errorMessage});

  /// True if state is the initial state.
  bool get isInitial => status == .initial;

  /// True if a loading process is ongoing.
  bool get isLoading => status == .loading;

  /// True if last operation was successful.
  bool get isSuccess => status == .success;

  /// True if last operation failed.
  bool get isFailure => status == .failure;

  /// True if there is an error message.
  bool get hasError => errorMessage != null;
}

/// Mixin containing common call-data-handling logic for Bloc & Cubit base classes.
/// Should be mixed into any BlocBase<> that needs to handle API call patterns.
mixin BaseCallDataHandler<S extends BaseState> on BlocBase<S> {
  /// Handles an API call that returns a [Result], manages state, and calls the appropriate callbacks.
  ///
  /// [apiCall] should return a [Result<R>].
  /// [onSuccess] receives the actual success value.
  /// [onError] is optional for custom error handling.
  /// [showLoading] determines if a loading state is emitted before the call.
  Future<void> handleCallData<R>({
    required Future<Result<R>> apiCall,
    required FutureOr<void> Function(R result) onSuccess,
    FutureOr<void> Function(
      Object error,
      String? errorMessage,
      Map<String, List<String>>? errorDetail,
    )?
    onError,
    bool showLoading = true,
  }) async {
    if (showLoading) {
      emitLoading();
    }

    final result = await apiCall;

    // Use sealed classes / pattern matching for Result
    switch (result) {
      case Success(data: final data):
        await onSuccess(data);
      case Error(error: final error):
        if (onError != null) {
          await onError(error, result.message, result.errorDetails);
        } else {
          emitError(result.message ?? '');
        }
    }
  }

  /// Handles a Stream<R>, managing state for each incoming data point and potential errors.
  ///
  /// [stream]: The stream to listen to (e.g., from _repository.watchData()).
  /// [onData]: A function that takes incoming data and returns the new state to emit.
  /// [onError]: Optional error handler that returns a new state.
  /// [showLoading]: If true, emits a loading state before starting.
  Future<void> handleStreamData<R>({
    required Emitter<S> emit,
    required Stream<Result<R>> streamData,
    required FutureOr<void> Function(R data) onSuccess,
    FutureOr<void> Function(
      Object error,
      String? errorMessage,
      Map<String, List<String>>? errorDetail,
    )?
    onError,
    bool showLoading = true,
  }) async {
    if (showLoading) {
      emitLoading();
    }

    // For each data from stream, handle it and return new state
    await emit.forEach<Result<R>>(
      streamData,
      // Handle each data from stream
      onData: (result) {
        // Switch result
        switch (result) {
          case Success(data: final data):
            // Handle success data
            onSuccess(data);
            return state;

          case Error(error: final error):
            // Handle error
            if (onError != null) {
              onError(error, result.message, result.errorDetails);
            } else {
              emitError(result.message ?? '');
            }
            return state;
        }
      },
      onError: (error, _) {
        emitError(error.toString());
        return state;
      },
    );

    // Sau khi stream kết thúc, nếu vẫn đang loading (không có data), chuyển sang success để tắt loading
    if (state.status == .loading) {
      emit(state.copyWith(status: .success) as S);
    }
  }

  /// Emits a loading state using the state's copyWith.
  void emitLoading() => emit(state.copyWith(status: .loading) as S);

  /// Emits an error state with the given error message.
  void emitError(String errorMessage) => emit(
    state.copyWith(errorMessage: Nullable(errorMessage), status: .failure) as S,
  );

  /// Clears the error part of the state.
  void emitClearedError() =>
      emit(state.copyWith(errorMessage: const Nullable(null)) as S);
}

/// Base class for Cubit-style state management, provides access to [BaseCallDataHandler].
abstract class BaseCubit<S extends BaseState> extends Cubit<S>
    with BaseCallDataHandler<S> {
  BaseCubit(super.initialState);
}

/// Base class for Bloc-style state management, provides access to [BaseCallDataHandler].
abstract class BaseBloc<E, S extends BaseState> extends Bloc<E, S>
    with BaseCallDataHandler<S> {
  BaseBloc(super.initialState);
}
