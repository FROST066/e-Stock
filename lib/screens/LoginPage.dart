import 'dart:convert';
import 'dart:io';

import 'package:e_stock/other/const.dart';
import 'package:e_stock/screens/HomePage.dart';
import 'package:e_stock/screens/PasswordForgot/getEmail.dart';
import 'package:e_stock/screens/SignUpScreen.dart';
import 'package:e_stock/screens/shopList.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:e_stock/widgets/CustomLoader.dart';
import 'package:e_stock/widgets/customFlutterToast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../other/styles.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final mdpController = TextEditingController();
  bool _isLoading = false;
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
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const Text("e-Stock",
                    style: TextStyle(fontFamily: 'Chancery', fontSize: 30))
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
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
                        // autofocus: true,
                        controller: emailController,
                        hintText: "Adresse Email",
                        prefixIcon: Icons.email,
                        textInputType: TextInputType.emailAddress,
                        // validatorFun: emailValidator,
                      ),
                      CustomPasswordFormField(
                        controller: mdpController,
                        labelText: "Mot de passe",
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
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      style: defaultStyle(context),
                      // onPressed: () => showMissing(),
                      onPressed: () async {
                        if (!_isLoading && formKey.currentState!.validate()) {
                          await _login(
                              emailController.text, mdpController.text);
                        }
                      },
                      child: !_isLoading
                          ? const Text("Connexion")
                          : customLoader(),
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
                        onTap: () => Navigator.push(
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

  _login(email, mdp) async {
    setState(() {
      _isLoading = true;
    });
    var formData = {"email": email, "mdp": mdp, "connexion": "1"};

    try {
      print("---------------requesting $BASE_URL");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: formData);
      var jsonresponse = json.decode(response.body);
      // print(response.body);
      //  print (response.statusCode);
      print(jsonresponse);
      try {
        if (jsonresponse['status']) {
          print(jsonresponse);
          final prefs = await SharedPreferences.getInstance();
          prefs.setInt(PrefKeys.USER_ID, int.parse(jsonresponse['id']));
          prefs.setString(PrefKeys.USER_NAME, jsonresponse['nom']);
          customFlutterToast(msg: "Bienvenue ${jsonresponse['nom']}");
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => ShopList()));
        } else {
          customFlutterToast(
              msg: "Nom d'utilisateur ou mot de passe incorrect");
        }
      } catch (e) {
        //print("-----1-------${e.toString()}");
        customFlutterToast(msg: "Erreur: ----1----${e.toString()}");
      }
    } catch (e) {
      // print("------2------${e.toString()}");
      customFlutterToast(msg: "Erreur: ----2----${e.toString()}");
      // return false;
    } finally {
      //set loading to false
      setState(() {
        _isLoading = false;
      });
    }
  }
}
