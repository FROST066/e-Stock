import 'dart:convert';
import 'dart:io';

import 'package:e_stock/other/const.dart';
import 'package:e_stock/screens/HomePage.dart';
import 'package:e_stock/screens/PasswordForgot/getEmail.dart';
import 'package:e_stock/screens/SignUpScreen.dart';
import 'package:e_stock/services/validator.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../other/styles.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final mdpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text("Connexion",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)),
                      ),
                      CustomTextFormField(
                        autofocus: true,
                        controller: emailController,
                        hintText: "Adresse Email",
                        prefixIcon: Icons.email,
                        textInputType: TextInputType.emailAddress,
                        // validatorFun: emailValidator,
                      ),
                      CustomPasswordFormField(
                        controller: mdpController,
                        hintText: "Mot de passe",
                      )
                    ],
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20, top: 30),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      style: defaultStyle(context),
                      // onPressed: () => showMissing(),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await _login(
                              emailController.text, mdpController.text);
                        }
                      },
                      child: const Text("Connexion"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Text("S'inscrire",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            )),
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const SignUpScreen())),
                      ),
                      InkWell(
                        child: Text("Mot de passe oublié ?",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            )),
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const GetEmail())),
                      ),
                    ],
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
    if (emailController.text == "" || !emailController.text.contains('@')) {
      msg = "Entrez un email valide";
    } else if (mdpController.text == "") {
      msg = "Entrez un mot de passe valide";
    } else {
      //get UserName and save it in prefs
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const HomePage()),
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
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  Future<void>? _login(email, mdp) async {
    //set loading to true
    var formData = {"email": email, "mdp": mdp, "connexion": "1"};
    print("---------------requesting $BASE_URL");
    try {
      http.Response response = await http.post(
        Uri.parse(BASE_URL),
        body: formData,
      );
      // print(response.body);
      var jsonresponse = json.decode(response.body);
      if (response.statusCode.toString().startsWith("2")) {
        try {
          if (jsonresponse['status']) {
            //traitement des données recues
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (ctx) => HomePage()),
                (route) => false);
          } else {
            print("Nom d'utilisateur ou mot de passe incorrect");
          }
        } catch (e) {
          print("------------${e.toString()}");
        }
      } else {
        print("pb httt code statuts ${response.statusCode}");
        // return false;
      }
    } catch (e) {
      print("------------${e.toString()}");
      // return false;
    } finally {
      //set loading to false
    }
  }
}
