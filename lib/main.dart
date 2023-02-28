import 'dart:io';

import 'package:e_stock/other/const.dart';
import 'package:e_stock/other/themes.dart';
import 'package:e_stock/screens/HomePage.dart';
import 'package:e_stock/screens/HomepageItem/HistoryScreen.dart';
import 'package:e_stock/screens/PasswordForgot/Congrats.dart';
import 'package:e_stock/screens/PasswordForgot/ProvideNewMdp.dart';
import 'package:e_stock/screens/PasswordForgot/ProvideOtp.dart';
import 'package:e_stock/screens/PasswordForgot/getEmail.dart';
import 'package:e_stock/screens/SignUpScreen.dart';
import 'package:e_stock/screens/LoginPage.dart';
import 'package:e_stock/screens/getStarted.dart';
import 'package:e_stock/screens/shopList.dart';
import 'package:e_stock/screens/splash.dart';
import 'package:e_stock/services/route.dart';
import 'package:e_stock/services/static.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isLinux) {
    await Firebase.initializeApp();
  }
  final prefs = await SharedPreferences.getInstance();
  final themeIsLight = prefs.getBool(PrefKeys.IS_LIGHT);
  bool isLight = themeIsLight ??
      WidgetsBinding.instance.window.platformBrightness == Brightness.light;
  StaticValues.setIsLightMode = isLight;
  print("isLight: $isLight");
  runApp(MyApp(isLight: isLight));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLight});
  final bool isLight;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final initTheme = isLight ? lightTheme : darkTheme;
    return ThemeProvider(
      initTheme: initTheme,
      builder: (_, myTheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: myTheme,
          home: const Splash(),
        );
      },
    );
  }
}
