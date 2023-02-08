import 'dart:io';
import 'package:e_stock/screens/FirstPage.dart';
import 'package:e_stock/services/validator.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../other/styles.dart';
import 'LoginPage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mdpController = TextEditingController();
  final confimedMdpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset(
                "assets/images/incription.png",
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                          controller: nameController,
                          hintText: "Nom et Prenoms",
                          prefixIcon: Icons.person),
                      CustomTextFormField(
                          controller: emailController,
                          hintText: "Adresse Email",
                          prefixIcon: Icons.email,
                          validatorFun: emailValidator,
                          textInputType: TextInputType.emailAddress),
                      CustomPasswordFormField(
                        controller: mdpController,
                        hintText: "Mot de passe",
                      ),
                      CustomPasswordFormField(
                        controller: confimedMdpController,
                        hintText: "Confirmez le mot de passe",
                      )
                    ],
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      style: defaultStyle(context),
                      onPressed: () => showMissing(),
                      child: const Text("Valider"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Vous avez déjà un compte ?"),
                      InkWell(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const LoginPage())),
                        child: Text("Se connecter",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  void showMissing() {
    String msg = "";
    if (nameController.text == "") {
      msg = "Entrez votre nom et prénom(s) ";
    } else if (emailController.text == "" ||
        !emailController.text.contains('@')) {
      msg = "Entrez un email valide";
    } else if (mdpController.text == "") {
      msg = "Entrez un mot de passe valide";
    } else if (confimedMdpController.text == "") {
      msg = "Confirmez le mot de passe ";
    } else if (confimedMdpController.text != mdpController.text) {
      msg = "Les 2 mots de passe ne correspondent pas";
    } else {
      //traitement
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const FirstPage()),
          (route) => false);
    }
    //Don't work on Linux
    if (msg != "") {
      print(msg);
      if (!Platform.isLinux) {
        Fluttertoast.showToast(
          msg: msg,
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }
}
