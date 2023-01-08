import 'package:e_stock/other/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.fill,
            ),
          ),
          const CircularProgressIndicator(
            color: appBlue,
          )
        ],
      )),
    );
  }
}
