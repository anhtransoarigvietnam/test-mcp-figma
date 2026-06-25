---
name: "bloc cubit"
description: "State management patterns using BaseState, BaseCubit, BaseCallDataHandler, ViewStatus, and Result."
---
Summary: State management patterns using BaseState, BaseCubit, BaseCallDataHandler, ViewStatus, and Result.

# State Management

The application uses `flutter_bloc` combined with custom base classes to handle state and API calls elegantly. 

## 1. ViewStatus & Result

`ViewStatus` is an enum for the state machine:
```dart
enum ViewStatus { initial, loading, success, failure }
```

`Result` is a sealed class from `lib/utility/helper/result.dart` returned by repositories:
```dart
sealed class Result<T> { ... }
final class Success<T> extends Result<T> { final T data; }
final class Error<T> extends Result<T> { final Exception error; String? get message; ... }
```

## 2. BaseState

All state classes must extend `BaseState` and implement `copyWith`.
```dart
abstract class BaseState {
  final ViewStatus status;
  final String? errorMessage;
  const BaseState({this.status = .initial, this.errorMessage});
  BaseState copyWith({ViewStatus? status, Nullable<String>? errorMessage});
  // Provides isInitial, isLoading, isSuccess, isFailure, hasError
}
```

## 3. BaseCubit & BaseCallDataHandler

Cubits extend `BaseCubit<T>` which mixes in `BaseCallDataHandler`. This mixin provides `handleCallData` for async operations without boilerplate try/catch blocks.

```dart
@lazySingleton
class HomeViewModel extends BaseCubit<HomeState> {
  HomeViewModel(this._repository) : super(const HomeState());

  final CollectionRepository _repository;

  Future<void> fetchSummary() async {
    // Automatically emits loading state, handles the Result, and manages errors.
    await handleCallData(
      apiCall: _repository.getCollectionSummary(),
      showLoading: true, // true by default
      onSuccess: (summary) async {
        emit(state.copyWith(
          summary: summary,
          isLoadingSummary: false,
          errorMessage: const Nullable(null), // using Nullable wrapper to clear
        ));
      },
    );
  }
}
```

## 4. Nullable Wrapper
To set a field to null in `copyWith`, the project uses a `Nullable<T>` wrapper (e.g., `errorMessage: const Nullable(null)`).
