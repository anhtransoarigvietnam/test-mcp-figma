/// Contains all navigation endpoints used throughout the app.
/// Use these constants when referencing route paths in navigation logic.
enum RouterEndpoint {
  home(host: null, path: '/'),
  setting(path: '/setting');

  final String path;
  final String? host;

  const RouterEndpoint({this.host, required this.path});
}
