import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
}
