import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import '../utils/colors.dart';
import 'images.dart';

appbar_with_logo(var height) {
  return AppBar(
    elevation: 2,
    title: Image.asset(
      amazon_logo,
      height: height * 0.06,
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
  );
}

class commonFunctions {
  static blankSpace({double? height, double? width}) {
    return SizedBox(
      height: height ?? 0,
      width: width ?? 0,
    );
  }

  static divider() {
    return Divider(
      color: greyShade3,
      height: 0,
      thickness: 3,
    );
  }

  static showSuccessToast(
      {required BuildContext context, required String message}) {
    return MotionToast.success(
      title: const Text('Success'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }

  static showErrorToast(
      {required BuildContext context, required String message}) {
    return MotionToast.error(
      title: const Text('Error'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }

  static showWarningToast(
      {required BuildContext context, required String message}) {
    return MotionToast.warning(
      title: const Text('Opps!'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }
}
