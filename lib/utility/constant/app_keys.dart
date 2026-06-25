import 'dart:io' show Platform;

/// This class contains all the application keys
class AppKeys {
  const AppKeys._();

  static const iap = _IAP();
  static const admob = _AdMob();
}

/// In App Purchase keys
final class _IAP {
  const _IAP();
  final String pro = 'com.duydt.guitarlearning.iap.pro';
}

/// AdMob keys
final class _AdMob {
  const _AdMob();
  // TODO: Replace with real ad ids.
  String get banner => Platform.isIOS
      ? 'ca-app-pub-3940256099942544/2435281174'
      : 'ca-app-pub-3940256099942544/9214589741';
  String get interstitial => Platform.isIOS
      ? 'ca-app-pub-3940256099942544/4411468910'
      : 'ca-app-pub-3940256099942544/1033173712';
  String get appOpen => Platform.isIOS
      ? 'ca-app-pub-3940256099942544/5575463023'
      : 'ca-app-pub-3940256099942544/9257395921';
}
