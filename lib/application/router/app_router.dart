
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_mcp_figma/application/router/router_endpoint.dart';
import 'package:test_mcp_figma/application/router/router_key.dart';
import 'package:test_mcp_figma/presentation/screen/home/home_page.dart';

/// The application's central router for navigation.
/// Provides [GoRouter] configured with all main application routes.
final class AppRouter {
  /// Configured [GoRouter] instance.
  late final GoRouter router = GoRouter(
    initialLocation: RouterEndpoint.home.path,
    navigatorKey: RouterKey.rootNavigatorKey,
    // List of available routes in the application.
    routes: <RouteBase>[
      _walkthrough,
      _home,
      _chordLookup,
      _metronome,
      _textCourse,
      _videoCourse,
      _setting,
    ],
  );

  GoRoute get _walkthrough => GoRoute(
    name: RouterEndpoint.walkthrough.name,
    path: RouterEndpoint.walkthrough.path,
    builder: (context, state) =>
        const Scaffold(body: Center(child: Text('Walkthrough'))),
  );

  /// Route for the Home screen.
  GoRoute get _home => GoRoute(
    name: RouterEndpoint.home.name,
    path: RouterEndpoint.home.path,
    builder: (context, state) => const HomePage(),
  );

  GoRoute get _chordLookup => GoRoute(
    name: RouterEndpoint.chordLookup.name,
    path: RouterEndpoint.chordLookup.path,
    builder: (context, state) =>
        const Scaffold(body: Center(child: Text('Chord Lookup'))),
  );

  GoRoute get _metronome => GoRoute(
    name: RouterEndpoint.metronome.name,
    path: RouterEndpoint.metronome.path,
    builder: (context, state) =>
        const Scaffold(body: Center(child: Text('Metronome'))),
  );

  GoRoute get _textCourse => GoRoute(
    name: RouterEndpoint.textCourse.name,
    path: RouterEndpoint.textCourse.path,
    builder: (context, state) =>
        const Scaffold(body: Center(child: Text('Text Course'))),
  );

  GoRoute get _videoCourse => GoRoute(
    name: RouterEndpoint.videoCourse.name,
    path: RouterEndpoint.videoCourse.path,
    builder: (context, state) =>
        const Scaffold(body: Center(child: Text('Video Course'))),
  );

  GoRoute get _setting => GoRoute(
    name: RouterEndpoint.setting.name,
    path: RouterEndpoint.setting.path,
    builder: (context, state) =>
        // TODO: Replace with setting page
        const Scaffold(body: Center(child: Text('Setting'))),
  );
}
