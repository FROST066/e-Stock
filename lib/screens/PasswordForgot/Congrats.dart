import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Congrats extends StatefulWidget {
  const Congrats({super.key});

  @override
  State<Congrats> createState() => _CongratsState();
}

class _CongratsState extends State<Congrats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset(
                "assets/images/Congrats.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(
            "Felicitations",
            style: GoogleFonts.lora(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const Text("Votre mot de passe a été mis à jour avec succes"),
          // const Flexible(flex: 3, child: SizedBox()),
          Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .5,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      style: defaultStyle(context),
                      onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const LoginPage()),
                          (route) => false),
                      child: const Text("Se connecter"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
