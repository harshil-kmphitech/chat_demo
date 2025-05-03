import 'dart:convert';

import 'package:chat_demo/helpers/all.dart';
import 'package:chat_demo/models/authModel/auth_model.dart';

extension SharedPreferencesX on SharedPreferences {
  String? get getToken => getString(KeyName.token);

  set setToken(String? value) {
    if (value == null) {
      remove(KeyName.token);
    } else {
      setString(KeyName.token, value);
    }
  }

  bool? get getIsUserLogin => getBool(KeyName.isUserLogin);

  set setIsUserLogin(bool? value) {
    if (value == null) {
      remove(KeyName.isUserLogin);
    } else {
      setBool(KeyName.isUserLogin, value);
    }
  }

  String? get getUserId => getString(KeyName.userId);

  /// <<< --------- To Get Login Data --------- >>>
  AuthData? get getLoginData {
    var allData = getString(KeyName.loginData);

    if (allData == null) return null;

    final jsonData = jsonDecode(allData);

    final loginResponse = AuthData.fromJson(jsonData);
    return loginResponse;
  }

  /// <<< --------- To Save Login Data --------- >>>
  set setLoginData(AuthData loginResponse) {
    final allData = jsonEncode(loginResponse);
    setString(KeyName.loginData, allData);

    setString(KeyName.userId, loginResponse.id ?? '');
    setString(KeyName.token, loginResponse.token ?? '');
  }

  set removeLoginData(AuthData? loginResponse) {
    remove(KeyName.loginData);
  }
}
