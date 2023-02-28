import 'package:e_stock/other/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light().copyWith(
  useMaterial3: true,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: appBlue, foregroundColor: Colors.white),
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
      centerTitle: true,
      titleTextStyle: GoogleFonts.lora(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
  primaryColor: appBlue,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(color: appBlue, fontSize: 18),
    floatingLabelStyle: const TextStyle(fontSize: 18, color: appBlue),
    prefixIconColor: appBlue,
    suffixIconColor: appBlue,
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: appBlue, width: 2)),
    labelStyle: const TextStyle(color: appBlue, fontSize: 18),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: appBlue, width: 2)),
  ),
  textTheme: TextTheme(
    button: const TextStyle(fontSize: 20, color: Colors.black),
    // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: GoogleFonts.lora(color: Colors.black),
    bodyText1: GoogleFonts.amiri(fontSize: 30),
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  useMaterial3: true,
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: appDarkBlue),
  appBarTheme: AppBarTheme(
      elevation: 0,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: GoogleFonts.lora(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
  primaryColor: appDarkBlue,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(color: appDarkBlue, fontSize: 18),
    floatingLabelStyle: const TextStyle(fontSize: 18, color: appDarkBlue),
    prefixIconColor: appDarkBlue,
    suffixIconColor: appDarkBlue,
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: appDarkBlue, width: 2)),
    labelStyle: const TextStyle(color: appDarkBlue, fontSize: 18),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: appDarkBlue, width: 2)),
  ),
  textTheme: TextTheme(
    button: const TextStyle(fontSize: 20, color: Colors.white),
    // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: GoogleFonts.lora(color: Colors.white),
    bodyText1: GoogleFonts.amiri(fontSize: 30),
  ),
);
