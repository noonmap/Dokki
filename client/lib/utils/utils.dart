import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/constant/common.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static String getToday() {
    DateTime now = DateTime.now();
    int month = now.month;
    int day = now.day;
    int weekDay = now.weekday;
    return '$month월 $day일 (${WEEK_DAY[weekDay]})';
  }

  static String secondTimeToFormatString(int second) {
    // 초로된 시간을 00:00:00 String 형식으로 변환 하여 return
    int min = (second / 60).floor();
    int hour = (min / 60).floor();
    int sec = second % 60;
    late String sMin;
    late String sHour;
    late String sSec;
    if (min < 10) {
      sMin = '0$min';
    } else {
      sMin = '$min';
    }
    if (hour < 10) {
      sHour = '0$hour';
    } else {
      sHour = '$hour';
    }
    if (sec < 10) {
      sSec = '0$sec';
    } else {
      sSec = '$sec';
    }

    return "$sHour : $sMin : $sSec";
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: grayColor500,
      textColor: grayColor000,
    );
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: const EdgeInsets.all(15),
          borderRadius: BorderRadius.circular(8),
          message: message,
          backgroundColor: brandColor300,
          messageColor: grayColor000,
          duration: const Duration(seconds: 2),
          flushbarPosition: FlushbarPosition.BOTTOM,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          icon: const Icon(Icons.info_sharp, size: 28, color: grayColor000),
        )..show(context));
  }

  static void flushBarSuccessMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: const EdgeInsets.all(15),
          borderRadius: BorderRadius.circular(8),
          message: message,
          backgroundColor: Colors.green,
          messageColor: grayColor000,
          duration: const Duration(seconds: 2),
          flushbarPosition: FlushbarPosition.BOTTOM,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          icon: const Icon(Icons.info_sharp, size: 28, color: grayColor000),
        )..show(context));
  }

  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: brandColor400,
      ),
    );
  }

  static EdgeInsets getIosCommonPadding() =>
      const EdgeInsets.fromLTRB(20, 40, 20, 0);

  static EdgeInsets getAndroidCommonPadding() =>
      const EdgeInsets.fromLTRB(20, 40, 20, 0);
}
