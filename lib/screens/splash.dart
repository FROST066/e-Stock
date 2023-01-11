import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/FirstPage.dart';
import 'package:e_stock/screens/HomePage.dart';
import 'package:e_stock/screens/getStarted.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  //Just initialisation
  bool isFirstTime = true, userIsConnected = false;

  Future<void> checkIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) prefs.setBool('isFirstTime', false);
  }

  Future<void> checkUserConnected() async {
    final prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('userName') ?? "";
    if (userName == "") {
      userIsConnected = false;
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfFirstTime().whenComplete(() => print("isFirstTime: $isFirstTime"));
    checkUserConnected()
        .whenComplete(() => print("user connected: $userIsConnected"));
    Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) => userIsConnected
                    ? const HomePage()
                    : isFirstTime
                        ? const GetStarted()
                        : const FirstPage())));
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
          const CircularProgressIndicator(
            color: appBlue,
          )
        ],
      )),
    );
  }
}
