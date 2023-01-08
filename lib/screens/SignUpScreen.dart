import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../other/styles.dart';

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
            Form(
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
                        textInputType: TextInputType.emailAddress),
                    CustomTextFormField(
                      controller: mdpController,
                      hintText: "Mot de passe",
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
                      onPressed: () {
                        if (formKey.currentState!.validate()) {}
                      },
                      child: const Text("Valider"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Vous avez déjà un compte ?"),
                      Text("Se connecter", style: TextStyle(color: appBlue)),
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
    if (emailController.text == "" || !emailController.text.contains('@')) {
      msg = "Entrez un email valide";
    } else if (mdpController.text == "") {
      msg = "Entrez un mot de passe valide";
    }
    //Don't work on Linux
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 18,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
