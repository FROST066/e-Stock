import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/LoginPage.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/getStarted.png",
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: const Text(
              "Gérer \nvotre stock\nde manière efficace et efficiente",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, height: 1.6),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: TextButton(
                style: defaultStyle(context),
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => const LoginPage())),
                child: const Text("Get started")),
          )
        ],
      ),
    );
  }
}
