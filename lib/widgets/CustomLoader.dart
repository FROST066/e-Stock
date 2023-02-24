import 'package:flutter/material.dart';

Widget customLoader({Color? color}) {
  return Center(child: CircularProgressIndicator(color: color ?? Colors.white));
}
