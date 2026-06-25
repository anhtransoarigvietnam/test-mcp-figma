import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:test_mcp_figma/application/lifecycle/app_lifecycle_observer.dart';
import 'package:test_mcp_figma/utility/enumeration/access_level.dart';
import 'package:test_mcp_figma/utility/enumeration/app_language.dart';
import 'package:test_mcp_figma/utility/helper/nullable.dart';
part 'global_state.dart';

@lazySingleton
class GlobalViewModel extends Cubit<GlobalViewModelState> {
  GlobalViewModel(
    this._lifecycleObserver,
  ) : super(const GlobalViewModelState());

  final AppLifecycleObserver _lifecycleObserver;

  bool get isPro => state.isPro;

  StreamSubscription? _lifecycleSubscription;

  /// Initialize global data
  Future<void> initialize() async {

    if (!isPro) {
      _startAppOpenAdLifecycle();
    }
  }

  /// Set account type
  void setAccountType(AccessLevel accessLevel) {
    emit(state.copyWith(accountType: accessLevel));
  }

  /// Mark the session as old (no longer a new session)
  void consumeNewSession() {
    emit(state.copyWith(isNewSession: false));
  }

  /// Pause trigger to show App Open Ad
  void pauseAdOpenTrigger() {
    _lifecycleObserver.lockAdTrigger();
  }

  /// Resume trigger to show App Open Ad
  void resumeAdOpenTrigger() {
    _lifecycleObserver.unlockAdTrigger();
  }

  @override
  Future<void> close() {
    _lifecycleSubscription?.cancel();
    _lifecycleObserver.dispose();
    return super.close();
  }

  /// Start app open ad lifecycle
  void _startAppOpenAdLifecycle() async {
    _lifecycleObserver.startObserving();

    // Listen for resume events
    _lifecycleSubscription?.cancel();
    _lifecycleSubscription = _lifecycleObserver.onAppResume.listen((_) {
      // Only show Ad if still a normal user (double check)
      if (!state.isPro) {
        // TODO: Uncomment when Admob Service is ready
        // _admobService.showAppOpenAd();
      }
    });
    // TODO: Uncomment when Admob Service is ready
    // _admobService.preloadAppOpenAd(showAfterLoad: true);
    // _admobService.preloadInterstitialAd();
  }
}
