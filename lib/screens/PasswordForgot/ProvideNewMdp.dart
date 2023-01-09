import 'dart:io';

import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/PasswordForgot/Congrats.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProvideNewMdp extends StatefulWidget {
  const ProvideNewMdp({super.key});

  @override
  State<ProvideNewMdp> createState() => _ProvideNewMdpState();
}

class _ProvideNewMdpState extends State<ProvideNewMdp> {
  final formKey = GlobalKey<FormState>();
  final mdpController = TextEditingController();
  final confirmedMdpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperation du mot de passe")),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset(
                "assets/images/ProvideNewMdp.png",
                fit: BoxFit.fill,
              ),
            ),
            Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: mdpController,
                      hintText: "Mot de passe",
                      prefixIcon: Icons.lock_rounded,
                      textInputType: TextInputType.emailAddress,
                      obscureText: true,
                    ),
                    CustomTextFormField(
                      controller: confirmedMdpController,
                      hintText: "Confirmer le mot de passe",
                      prefixIcon: Icons.lock_rounded,
                      obscureText: true,
                    )
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      style: defaultStyle,
                      onPressed: () => showMissing(),
                      child: const Text("Valider"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  void showMissing() {
    String msg = "";
    if (mdpController.text == "") {
      msg = "Entrez un mot de passe valide";
    } else if (confirmedMdpController.text == "") {
      msg = "Confirmez le mot de passe ";
    } else if (mdpController.text != confirmedMdpController.text) {
      msg = "Les 2 mots de passe entrés ne correspondent pas";
    } else {
      //save new password
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => const Congrats()));
    }
    //Don't work on Linux
    if (msg != "") {
      if (!Platform.isLinux) {
        Fluttertoast.showToast(
          msg: msg,
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }
}
