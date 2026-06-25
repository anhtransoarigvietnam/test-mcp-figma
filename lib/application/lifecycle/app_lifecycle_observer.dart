import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:test_mcp_figma/application/router/router_key.dart';

/// Monitors app lifecycle events and shows an App Open Ad whenever the app
/// resumes from background (Warm Start).
///
/// Register via [GlobalViewModel.initialize] and dispose via
/// [GlobalViewModel.close] to avoid memory leaks.
@lazySingleton
class AppLifecycleObserver with WidgetsBindingObserver {
  /// Controller to broadcast app resume events.
  final _resumeController = StreamController<void>.broadcast();
  Stream<void> get onAppResume => _resumeController.stream;

  bool _isObserving = false;
  bool _isDisposed = false;

  /// Flag use for unload admob in specific cases like(payment, ...etc)
  bool _isFlowLocked = false;

  void lockAdTrigger() => _isFlowLocked = true;
  void unlockAdTrigger() => _isFlowLocked = false;

  /// Start listening to lifecycle changes. Safe to call multiple times.
  void startObserving() {
    if (_isObserving) return;
    WidgetsBinding.instance.addObserver(this);
    _isObserving = true;
  }

  /// Stop listening to lifecycle changes. Called automatically when
  /// [GlobalViewModel] is disposed.
  void stopObserving() {
    if (!_isObserving) return;
    WidgetsBinding.instance.removeObserver(this);
    _isObserving = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      bool isDialogOpen = false;
      // Check if previous state is dialog
      RouterKey.rootNavigatorKey.currentState?.popUntil((route) {
        if (route is ModalRoute) {
          isDialogOpen = true;
        }
        return true;
      });
      if (!_isFlowLocked && !isDialogOpen) {
        _resumeController.add(null);
      }
    }
  }

  /// Releases the lifecycle observer and closes the event stream.
  /// Safe to call multiple times.
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    stopObserving();
    _resumeController.close();
  }
}
