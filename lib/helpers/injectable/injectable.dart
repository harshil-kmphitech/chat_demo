import 'package:chat_demo/ui/auth/login_screen.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:chat_demo/helpers/all.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:chat_demo/helpers/injectable/injectable.config.dart';

import 'Interceptor/token_interceptor.dart';

final getIt = GetIt.instance;

@i.injectableInit
Future<void> configuration() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarBrightness: Brightness.light,
  //     statusBarIconBrightness: Brightness.dark,
  //     systemNavigationBarColor: Colors.white,
  //     systemNavigationBarDividerColor: Colors.white,
  //     systemNavigationBarIconBrightness: Brightness.dark,
  //   ),
  // );
  Loading();
  if (kDebugMode) {
    getIt<dio.Dio>().interceptors.add(PrettyDioLogger(requestBody: true));
  }

  getIt<dio.Dio>().interceptors
    ..add(RefreshTokenInterceptor())
    ..add(RetryInterceptor(dio: getIt<dio.Dio>()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        locale: Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: EasyLoading.init(),
        home: const LoginScreen(),
      ),
    );
  }
}
