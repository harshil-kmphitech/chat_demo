import 'dart:developer';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

import 'all.dart';

class Utils {
  bool isValueEmpty(String? val) {
    if (val == null || val.isEmpty || val == "null" || val == "" || val == "NULL") {
      return true;
    } else {
      return false;
    }
  }

  void showToast({
    bool? isError,
    Color? textColor,
    Color? backgroundColor,
    required String message,
  }) {
    Fluttertoast.cancel();

    if (isError ?? false) {
      textColor = Colors.white;
      backgroundColor = Colors.grey;
    }

    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      textColor: textColor ?? Colors.white,
      backgroundColor: backgroundColor ?? Colors.blue,
      timeInSecForIosWeb: 3,
    );
  }

  String getDeviceType() => Platform.isAndroid ? "android" : "iOS";

  String getFormatedDate({String? date, required String dateFormate}) {
    if (utils.isValueEmpty(date)) date = '${DateTime.now()}';

    var newDate = DateFormat(dateFormate).format(DateTime.parse(date ?? '${DateTime.now()}').toLocal());

    if (newDate.contains("AM")) newDate = newDate.replaceAll("AM", "am");
    if (newDate.contains("PM")) newDate = newDate.replaceAll("PM", "pm");

    return newDate;
  }

  bool isTodayDate({required String? dateA, String? dateB}) {
    var isTodayDate = DateTime.parse(
          utils.getFormatedDate(dateFormate: 'yyyy-MM-dd', date: dateA),
        ).compareTo(DateTime.parse(
          utils.getFormatedDate(dateFormate: 'yyyy-MM-dd', date: dateB ?? "${DateTime.now()}"),
        )) ==
        0;

    return isTodayDate;
  }

  bool isYesterdayDate({required String? dateA, String? dateB}) {
    var isYesterdayDate = DateTime.parse(
          utils.getFormatedDate(dateFormate: 'yyyy-MM-dd', date: dateA),
        ).compareTo(DateTime.parse(
          utils.getFormatedDate(dateFormate: 'yyyy-MM-dd', date: dateB ?? "${DateTime.now().subtract(const Duration(days: 1))}"),
        )) ==
        0;

    return isYesterdayDate;
  }
}

void printSuccess(String text) {
  if (kDebugMode) {
    if (Platform.isAndroid) {
      log('\x1B[32m$text\x1B[0m');
    } else {
      log(text);
    }
  }
}

void printWarning(String text) {
  if (kDebugMode) {
    if (Platform.isAndroid) {
      log('\x1B[33m$text\x1B[0m');
    } else {
      log(text);
    }
  }
}

void printAction(String text) {
  if (kDebugMode) {
    if (Platform.isAndroid) {
      log('\x1B[94m$text\x1B[0m');
    } else {
      log(text);
    }
  }
}

void printError(String text) {
  if (kDebugMode) {
    if (Platform.isAndroid) {
      log('\x1B[91m$text\x1B[0m');
    } else {
      log(text);
    }
  }
}
