import 'package:go_router/go_router.dart';

// BaseNavigator provides a contract for classes that need to expose a GoRouter instance.
// It should be extended by features/screens that require navigation through GoRouter.
abstract class BaseNavigator {
  final GoRouter router;

  const BaseNavigator({required this.router});
}
