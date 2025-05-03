import 'dart:async';

import 'package:chat_demo/helpers/all.dart';
import 'package:chat_demo/models/authModel/auth_model.dart';
import 'package:chat_demo/services/auth/auth_service.dart';
import 'package:chat_demo/ui/chat/chat_users_screen.dart';

class AuthController extends GetxController {
  AuthModel user = AuthModel.fromJson({});

  Future<void> onLoginPress() async {
    await getIt<AuthService>()
        .login(
      pass: '123456',
      email: 'mayur.kmphasis@gmail.com',
    )
        .handler(
      null,
      onSuccess: (value) async {
        user = value;
        getIt<SharedPreferences>().setIsUserLogin = true;
        getIt<SharedPreferences>().setToken = value.data?.token;
        if (value.data != null) getIt<SharedPreferences>().setLoginData = value.data!;

        Get.offAll(ChatUsersScreen());

        utils.showToast(message: value.message ?? 'Login Successfully');
      },
      onFailed: (value) {
        utils.showToast(isError: true, message: value.error.description);
      },
    );
  }

  @override
  void onReady() {
    if (getIt<SharedPreferences>().getIsUserLogin ?? false) Get.offAll(ChatUsersScreen());

    super.onReady();
  }
}
