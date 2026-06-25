import 'dart:developer' show log;
import 'package:url_launcher/url_launcher.dart' show LaunchMode, launchUrl;

/// Helper class for various utility functions
class Helper {
  /// Private constructor for singleton pattern
  Helper._internal();

  /// Factory constructor to provide singleton instance
  factory Helper.instance() => Helper._internal();

  /// Open url in external application
  static void openUrl(String url, {bool openInApp = false}) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(
        uri,
        mode: openInApp ? LaunchMode.inAppBrowserView : .externalApplication,
      );
    } catch (e) {
      log('Exception launching $url: $e');
    }
  }
}
