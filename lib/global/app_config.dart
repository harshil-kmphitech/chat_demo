import 'package:chat_demo/helpers/all.dart';

Utils utils = Utils();

class AppConfig {
  AppConfig._();

  static const String baseUrl = 'https://7hglmg7p-3030.inc1.devtunnels.ms/api/';
  // static const String socketBaseUrl = 'https://hexanetwork.in:3035';
  static const String socketBaseUrl = 'https://7hglmg7p-3030.inc1.devtunnels.ms/';
  static const int timeoutDuration = 10000;
  static const bool enableLogging = true;
}

class EndPoints {
  EndPoints._();

  // API's endpoints
  static const authLogin = "auth/login";

  static const String refreshToken = "refreshToken";

  // In-App Purchase
  static const inapppurchaseAndroidPlanPurchase = "inapppurchase/androidPlanPurchase";
  static const inapppurchaseAndroidPlanRestore = "inapppurchase/androidPlanRestore";
  static const inapppurchaseApplePlanPurchase = "inapppurchase/applePlanPurchase";
  static const inapppurchaseApplePlanRestore = "inapppurchase/applePlanRestore";
  static const inapppurchaseCheckUserPlan = "inapppurchase/checkUserPlan";
}

class KeyName {
  KeyName._();

  static const token = "token";
  static const userId = "userId";
  static const loginData = "loginData";
  static const isUserLogin = "isUserLogin";
}

class SocketKey {
  SocketKey._();

  // Socket keys
  static const roomJoin = "roomJoin";
  static const roomLeave = "roomLeave";
  static const socketJoin = "socketJoin";
  static const socketLeave = "socketLeave";
  static const sendMessage = "sendMessage";
  static const setNewMessage = "setNewMessage";
  static const setSocketJoin = "setSocketJoin";
  static const setSocketLeave = "setSocketLeave";
  static const setMessageList = "setMessageList";
  static const getMessageList = "getMessageList";
  static const updateChatList = "updateChatList";
  static const setChatUserList = "setChatUserlist";
  static const getChatUserList = "getChatUserlist";
}
