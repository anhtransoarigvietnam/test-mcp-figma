import 'package:flutter/material.dart' show BuildContext, MediaQuery;
import 'package:test_mcp_figma/presentation/l10n/app_localizations.dart';
import 'package:test_mcp_figma/utility/enumeration/device_type.dart'
    show DeviceType;

extension ResponsiveHelper on BuildContext {
  static const double _tabletBreakpoint = 600;
  static const double _smallMobileBreakpoint = 380;

  double get _shortestSide => MediaQuery.sizeOf(this).shortestSide;

  DeviceType get deviceType {
    if (_shortestSide >= _tabletBreakpoint) return DeviceType.tablet;
    if (_shortestSide < _smallMobileBreakpoint) return DeviceType.smallMobile;
    return DeviceType.mobile;
  }

  bool get isTablet => deviceType == DeviceType.tablet;

  bool get isSmallMobile => deviceType == DeviceType.smallMobile;

  bool get isMobile => deviceType == DeviceType.mobile;

  /// Returns a value [T] based on the device's screen size (shortestSide).
  ///
  /// Logic:
  /// - [tablet]: shortestSide >= 600 (Standard for 7-8" tablets)
  /// - [smallMobile]: shortestSide < 380 (Legacy or small Android/iOS devices)
  /// - [mobile]: Default fallback
  T lp<T>(T mobile, {T? tablet, T? smallMobile}) {
    // Using sizeOf(this) is efficient as it only rebuilds when size changes
    final double shortestSide = MediaQuery.sizeOf(this).shortestSide;

    // 1. Tablet Priority (Standard Android/iOS tablet breakpoint)
    if (shortestSide >= 600) {
      return tablet ?? mobile;
    }

    if (isSmallMobile && smallMobile != null) {
      return smallMobile;
    }

    return mobile;
  }
}

extension AppLocalizationsHelper on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
