import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void customFlutterToast({String? msg, bool show = false}) {
// void customFlutterToast({String? msg, bool show = true}) {
  if (!Platform.isLinux && show) {
    Fluttertoast.showToast(
        msg: msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        // backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  print("Flutter Toast: $msg");
}
