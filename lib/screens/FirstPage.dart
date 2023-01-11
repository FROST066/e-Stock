import 'package:e_stock/screens/LoginPage.dart';
import 'package:e_stock/screens/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../other/styles.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

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
                // width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const Text("e-Stock",
                  style: TextStyle(fontFamily: 'Chancery', fontSize: 30))
            ],
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: ElevatedButton(
                  style: defaultStyle,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => const LoginPage())),
                  child: const Text("Connexion"),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: ElevatedButton(
                  style: customStyle,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const SignUpScreen())),
                  child: const Text("Inscription"),
                ),
              )
            ],
          ),
        ],
      )),
    );
  }
}
