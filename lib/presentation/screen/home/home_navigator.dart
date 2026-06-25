import 'package:injectable/injectable.dart';
import 'package:test_mcp_figma/application/router/router_endpoint.dart';
import 'package:test_mcp_figma/presentation/common/base/base_navigator.dart';

@injectable
class HomeNavigator extends BaseNavigator {
  const HomeNavigator({required super.router});

  // TODO: Update function
  void goToSetting() {
    router.pushNamed(RouterEndpoint.setting.name);
  }
}
