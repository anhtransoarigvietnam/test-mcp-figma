// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:test_mcp_figma/application/dependency_injection/dependency_injection.dart'
    as _i586;
import 'package:test_mcp_figma/application/lifecycle/app_lifecycle_observer.dart'
    as _i170;
import 'package:test_mcp_figma/application/view_model/global_view_model.dart'
    as _i128;
import 'package:test_mcp_figma/network/configuration/dio_configuration.dart'
    as _i293;
import 'package:test_mcp_figma/presentation/screen/home/home_navigator.dart'
    as _i961;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final globalDependencyInjectionModule = _$GlobalDependencyInjectionModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => globalDependencyInjectionModule.sharedPreferences,
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => globalDependencyInjectionModule.packageInfo,
      preResolve: true,
    );
    gh.singleton<_i833.DeviceInfoPlugin>(
      () => globalDependencyInjectionModule.deviceInfo,
    );
    gh.singleton<_i583.GoRouter>(
      () => globalDependencyInjectionModule.router(),
    );
    gh.lazySingleton<_i170.AppLifecycleObserver>(
      () => _i170.AppLifecycleObserver(),
    );
    gh.singleton<_i293.DioConfiguration>(
      () => _i293.DioConfiguration(
        gh<_i460.SharedPreferences>(),
        gh<_i655.PackageInfo>(),
        gh<_i833.DeviceInfoPlugin>(),
      ),
    );
    gh.factory<_i961.HomeNavigator>(
      () => _i961.HomeNavigator(router: gh<_i583.GoRouter>()),
    );
    gh.singleton<_i361.Dio>(
      () =>
          globalDependencyInjectionModule.hubDio(gh<_i293.DioConfiguration>()),
      instanceName: 'hubDio',
    );
    gh.singleton<_i361.Dio>(
      () =>
          globalDependencyInjectionModule.appDio(gh<_i293.DioConfiguration>()),
      instanceName: 'appDio',
    );
    gh.lazySingleton<_i128.GlobalViewModel>(
      () => _i128.GlobalViewModel(gh<_i170.AppLifecycleObserver>()),
    );
    return this;
  }
}

class _$GlobalDependencyInjectionModule
    extends _i586.GlobalDependencyInjectionModule {}
