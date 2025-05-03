// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chat_demo/helpers/all.dart' as _i717;
import 'package:chat_demo/helpers/injectable/injectable%20properties/injectable_properties.dart'
    as _i856;
import 'package:chat_demo/services/auth/auth_service.dart' as _i935;
import 'package:chat_demo/services/refreshToken/refresh_token_service.dart'
    as _i458;
import 'package:chat_demo/services/subscription/subscription_service.dart'
    as _i821;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final authModule = _$AuthModule();
    await gh.factoryAsync<_i717.SharedPreferences>(
      () => authModule.sharedPref(),
      preResolve: true,
    );
    gh.singleton<_i717.Dio>(() => authModule.dio());
    gh.lazySingleton<_i935.AuthService>(
        () => _i935.AuthService(gh<_i717.Dio>()));
    gh.lazySingleton<_i458.RefreshTokenService>(
        () => _i458.RefreshTokenService(gh<_i717.Dio>()));
    gh.lazySingleton<_i821.SubscriptionService>(
        () => _i821.SubscriptionService(gh<_i717.Dio>()));
    return this;
  }
}

class _$AuthModule extends _i856.AuthModule {}
