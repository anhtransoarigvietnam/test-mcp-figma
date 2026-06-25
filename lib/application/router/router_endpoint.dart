/// Contains all navigation endpoints used throughout the app.
/// Use these constants when referencing route paths in navigation logic.
enum RouterEndpoint {
  walkthrough(path: '/walkthrough'),
  home(host: null, path: '/'),
  chordLookup(path: '/chord-lookup'),
  metronome(path: '/metronome'),
  textCourse(path: '/text-course'),
  videoCourse(path: '/video-course'),
  setting(path: '/setting');
  final String path;
  final String? host;

  const RouterEndpoint({this.host, required this.path});
}
