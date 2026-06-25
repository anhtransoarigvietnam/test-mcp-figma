import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_mcp_figma/application/dependency_injection/dependency_injection.config.dart';
import 'package:test_mcp_figma/application/router/app_router.dart';
import 'package:test_mcp_figma/network/configuration/dio_configuration.dart';

@InjectableInit()
Future<void> configureDependencies() => GetIt.instance.init();

@module
abstract class GlobalDependencyInjectionModule {
  @singleton
  @Named('appDio')
  Dio appDio(DioConfiguration configuration) => configuration.getAppDio();

  @singleton
  @Named('hubDio')
  Dio hubDio(DioConfiguration configuration) => configuration.getHubDio();

  @singleton
  GoRouter router() => AppRouter().router;

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @singleton
  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();
}
