import 'package:flutter/material.dart';

const Color appBlue = Color(0xFF2e3190);
// const Color appGrey = Color(0xFFceced6);
const Color appGrey = Color.fromARGB(255, 235, 235, 238);

const Color appDarkGrey = Color(0xFF9E9E9E);
const Color appDarkBlue = Color(0xFF05aced);

ButtonStyle defaultStyle(BuildContext ctx) {
  return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      )),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 12)),
      foregroundColor: MaterialStateProperty.all<Color?>(Colors.white),
      backgroundColor:
          MaterialStateProperty.all<Color?>(Theme.of(ctx).primaryColor));
}

ButtonStyle customStyle(BuildContext ctx) {
  return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      )),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 12)),
      foregroundColor:
          MaterialStateProperty.all<Color?>(Theme.of(ctx).primaryColor),
      backgroundColor: MaterialStateProperty.all<Color?>(appGrey));
}

ButtonStyle homePageBtStyle(BuildContext ctx) {
  return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Theme.of(ctx).primaryColor, width: 2))),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
          const EdgeInsets.symmetric(vertical: 25, horizontal: 20)),
      foregroundColor: MaterialStateProperty.all<Color?>(
          Theme.of(ctx).appBarTheme.foregroundColor),
      backgroundColor: MaterialStateProperty.all<Color?>(
          Theme.of(ctx).scaffoldBackgroundColor));
}

ButtonStyle productDialogBtStyle(Color backgroundColor) {
  return ButtonStyle(
      textStyle:
          MaterialStateProperty.all<TextStyle?>(const TextStyle(fontSize: 15)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
      foregroundColor: MaterialStateProperty.all<Color?>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color?>(backgroundColor));
}
