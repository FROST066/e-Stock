import 'package:e_stock/other/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light().copyWith(
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
      centerTitle: true,
      titleTextStyle: GoogleFonts.lora(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
  primaryColor: appBlue,
  textTheme: TextTheme(
    button: const TextStyle(fontSize: 20),
    // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: GoogleFonts.lora(color: Colors.black),
    bodyText1: GoogleFonts.amiri(fontSize: 30),
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.lora(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
  primaryColor: appDarkBlue,
  textTheme: TextTheme(
    button: const TextStyle(fontSize: 20, color: Colors.white),
    // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: GoogleFonts.lora(color: Colors.white),
    bodyText1: GoogleFonts.amiri(fontSize: 30),
  ),
);
