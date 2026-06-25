
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
    routes: <RouteBase>[_home, _setting],
  );

  /// Route for the Home screen.
  GoRoute get _home => GoRoute(
    name: RouterEndpoint.home.name,
    path: RouterEndpoint.home.path,
    builder: (context, state) => const HomePage(),
  );

  GoRoute get _setting => GoRoute(
    name: RouterEndpoint.setting.name,
    path: RouterEndpoint.setting.path,
    builder: (context, state) =>
        // TODO: Replace with setting page
        const Scaffold(body: Center(child: Text('Setting'))),
  );
}
