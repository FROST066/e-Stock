import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/FirstPage.dart';
import 'package:e_stock/screens/HomePage.dart';
import 'package:e_stock/screens/PasswordForgot/Congrats.dart';
import 'package:e_stock/screens/PasswordForgot/ProvideNewMdp.dart';
import 'package:e_stock/screens/PasswordForgot/ProvideOtp.dart';
import 'package:e_stock/screens/PasswordForgot/getEmail.dart';
import 'package:e_stock/screens/SignUpScreen.dart';
import 'package:e_stock/screens/LoginPage.dart';
import 'package:e_stock/screens/getStarted.dart';
import 'package:e_stock/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
            centerTitle: true,
            titleTextStyle: GoogleFonts.lora(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        primaryColor: appBlue,
        textTheme: TextTheme(
          button: const TextStyle(fontSize: 20),
          // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: GoogleFonts.lora(),
        ),
      ),

      // home: const HomePage(),
      // home: const Congrats(),
      // home: const ProvideNewMdp(),
      // home: const ProvideOtp(),
      // home: const GetEmail(),
      // home: const SignUpScreen(),
      // home: const LoginPage(),
      // home: const FirstPage(),
      home: const Splash(),
      // home: const GetStarted(),
    );
  }
}
