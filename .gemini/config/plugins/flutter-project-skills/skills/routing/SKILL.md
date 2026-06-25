---
name: "routing"
description: "GoRouter setup, nested routes, parameter passing, and AppRouter configuration."
---
Summary: GoRouter setup, nested routes, parameter passing, and AppRouter configuration.

# Routing

Routing is handled by `go_router` located in `lib/application/router/`.

## 1. Router Setup
The central router is `AppRouter` (`app_router.dart`). Routes are mapped to enum endpoints from `RouterEndpoint` (`router_endpoint.dart`).

```dart
final class AppRouter {
  AppRouter(this._globalViewModel);
  final GlobalViewModel _globalViewModel;

  late final GoRouter router = GoRouter(
    initialLocation: RouterEndpoint.home.path,
    navigatorKey: RouterKey.rootNavigatorKey,
    routes: <RouteBase>[
      _onboarding,
      _bottomBarShell, // Uses StatefulShellRoute for tabs
    ],
    redirect: _routeRedirect,
  );
}
```

## 2. Defining a Route
Routes use `GoRoute`. The `name` and `path` come from `RouterEndpoint`.

```dart
GoRoute get _scan => GoRoute(
  name: RouterEndpoint.scan.name,
  path: RouterEndpoint.scan.path,
  builder: (context, state) => const ScanPage(),
  routes: [
    GoRoute(
      name: RouterEndpoint.snapTips.name,
      path: RouterEndpoint.snapTips.path,
      builder: (context, state) => const SnapTipsPage(),
    ),
  ],
);
```

## 3. Passing Complex Parameters
Complex parameters are passed via the `extra` property in the `GoRouterState`, not query parameters (unless it's simple flags). Always validate the param type.

```dart
GoRoute _coinDetail(RouterEndpoint endpoint) => GoRoute(
  name: endpoint.name,
  path: endpoint.path,
  builder: (context, state) {
    final param = state.extra;
    if (param is! CoinDetailParams) {
      return const Scaffold(body: Center(child: Text('Invalid coin detail')));
    }
    return CoinDetailPage(param: param);
  },
);
```

## 4. Redirects and Guards
Guards are handled inside the `_routeRedirect` method inside `AppRouter`, using the injected `GlobalViewModel` state to check session/onboarding.
