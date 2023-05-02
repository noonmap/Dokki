import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:dokki/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
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

  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: brandColor400,
      ),
    );
  }

  static EdgeInsets getIosCommonPadding() =>
      const EdgeInsets.fromLTRB(20, 30, 20, 0);

  static EdgeInsets getAndroidCommonPadding() =>
      const EdgeInsets.fromLTRB(20, 30, 20, 0);
}
