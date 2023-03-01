// generate route
import 'package:flutter/material.dart';
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

Map<String, WidgetBuilder> routes = {
  '/': (context) => const Splash(),
  '/getStarted': (context) => const GetStarted(),
  '/login': (context) => const LoginPage(),
  '/signUp': (context) => const SignUpScreen(),
  '/getEmail': (context) => const GetEmail(),
  '/provideNewMdp': (context) => const ProvideNewMdp(),
  '/congrats': (context) => const Congrats(),
  '/home': (context) => const HomePage(),
  '/history': (context) => const HistoryScreen(),
  '/shopList': (context) => const ShopList(),
};
