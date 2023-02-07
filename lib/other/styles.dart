import 'package:flutter/material.dart';

const Color appBlue = Color(0xFF2e3190);
const Color appGrey = Color(0xFFceced6);

ButtonStyle defaultStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
    )),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
        const EdgeInsets.symmetric(vertical: 16, horizontal: 12)),
    foregroundColor: MaterialStateProperty.all<Color?>(Colors.white),
    backgroundColor: MaterialStateProperty.all<Color?>(appBlue));

ButtonStyle customStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
    )),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
        const EdgeInsets.symmetric(vertical: 16, horizontal: 12)),
    foregroundColor: MaterialStateProperty.all<Color?>(appBlue),
    backgroundColor: MaterialStateProperty.all<Color?>(appGrey));

ButtonStyle homePageBtStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: appBlue, width: 2))),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
        const EdgeInsets.symmetric(vertical: 25, horizontal: 20)),
    foregroundColor: MaterialStateProperty.all<Color?>(Colors.black),
    backgroundColor: MaterialStateProperty.all<Color?>(Colors.white));

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
