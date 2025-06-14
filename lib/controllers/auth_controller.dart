import 'dart:async';

import 'package:chat_demo/helpers/all.dart';
import 'package:chat_demo/models/authModel/auth_model.dart';
import 'package:chat_demo/notification/notification.dart';
import 'package:chat_demo/services/auth/auth_service.dart';
import 'package:chat_demo/ui/chat/chat_users_screen.dart';

class AuthController extends GetxController {
  AuthModel user = AuthModel.fromJson({});

  Future<void> onLoginPress(String email) async {
    await getIt<AuthService>()
        .login(
      pass: 'f925916e2754e5e03f75dd58a5733251',
      email: '$email@gmail.com',
      deviceToken: getIt<SharedPreferences>().getFcmToken ?? '-',
    )
        .handler(
      null,
      onSuccess: (value) async {
        user = value;
        getIt<SharedPreferences>().setIsUserLogin = true;
        getIt<SharedPreferences>().setToken = value.data?.token;
        if (value.data != null) getIt<SharedPreferences>().setLoginData = value.data!;

        Get.to(() => ChatUsersScreen());

        utils.showToast(message: value.message ?? 'Login Successfully');
      },
      onFailed: (value) {
        utils.showToast(isError: true, message: value.error.description);
      },
    );
  }

  @override
  void onReady() {
    // if (getIt<SharedPreferences>().getIsUserLogin ?? false) Get.offAll(ChatUsersScreen());
    NotificationService().initialize();

    super.onReady();
  }
}
