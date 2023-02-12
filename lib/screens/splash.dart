import 'package:e_stock/other/const.dart';
import 'package:e_stock/screens/FirstPage.dart';
import 'package:e_stock/screens/HomePage.dart';
import 'package:e_stock/screens/getStarted.dart';
import 'package:e_stock/screens/shopList.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  //Just initialisation
  bool? isFirstTime;
  int? userID, shopID;

  initialize() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool('isFirstTime');
    userID = prefs.getInt(PrefKeys.USER_ID);
    shopID = prefs.getInt(PrefKeys.SHOP_ID);
    if (isFirstTime == null) prefs.setBool('isFirstTime', false);
  }

  @override
  void initState() {
    super.initState();
    initialize();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (builder) => userID == null
                  ? isFirstTime == null
                      ? const GetStarted()
                      : const FirstPage()
                  : shopID == null
                      ? const ShopList()
                      : const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                height: MediaQuery.of(context).size.height * 0.4,
                // width: MediaQuery.of(context).size.width * 0.7,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const Text("e-Stock",
                  style: TextStyle(fontFamily: 'Chancery', fontSize: 30))
            ],
          ),
          CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          )
        ],
      )),
    );
  }
}
