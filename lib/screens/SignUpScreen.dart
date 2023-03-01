import 'dart:convert';
import 'dart:io';
import 'package:e_stock/screens/PasswordForgot/ProvideOtp.dart';
import 'package:e_stock/services/validator.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../other/const.dart';
import '../other/styles.dart';
import '../widgets/CustomLoader.dart';
import '../widgets/customFlutterToast.dart';
import 'LoginPage.dart';
import 'package:http/http.dart' as http;

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
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 15),
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                          controller: nameController,
                          hintText: "Nom d'utilisateur",
                          prefixIcon: Icons.person),
                      CustomTextFormField(
                          controller: emailController,
                          hintText: "Adresse Email",
                          prefixIcon: Icons.email,
                          validatorFun: emailValidator,
                          textInputType: TextInputType.emailAddress),
                      CustomPasswordFormField(
                        controller: mdpController,
                        labelText: "Mot de passe",
                      ),
                      CustomPasswordFormField(
                        controller: confimedMdpController,
                        labelText: "Confirmez le mot de passe",
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
                      onPressed: () async {
                        if (mdpController.text != confimedMdpController.text) {
                          customFlutterToast(
                              msg: "Les 2 mots de passe ne correspondent pas");
                        } else {
                          if (!_isLoading && formKey.currentState!.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => ProvideOtp(
                                          email: emailController.text,
                                          afterOTPValidation: () {
                                            Navigator.pop(context);
                                            _signUp();
                                          },
                                        )));
                            await _signUp();
                          }
                        }
                      },
                      child:
                          !_isLoading ? const Text("Valider") : customLoader(),
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
          MaterialPageRoute(builder: (ctx) => const LoginPage()),
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

  _signUp() async {
    setState(() {
      _isLoading = true;
    });
    var formData = {
      "nom": nameController.text,
      "prenom": "",
      "mail": emailController.text,
      "mdp": mdpController.text
    };
    print("-----------$formData");
    print("---------------requesting $BASE_URL for sign up");
    try {
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: formData);
      // print(response.body);
      var jsonresponse = json.decode(response.body);
      print("---------------response $jsonresponse");
      if (response.statusCode.toString().startsWith("2")) {
        try {
          if (jsonresponse['status']) {
            //traitement des données recues
            customFlutterToast(msg: "Inscription réussie");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (ctx) => const LoginPage()),
                (route) => false);
          } else {
            customFlutterToast(
                msg: "Une erreur est survenue!!! Veuillez réessayer");
          }
        } catch (e) {
          print("------1------${e.toString()}");
        }
      } else {
        print("pb httt code statuts ${response.statusCode}");
        // return false;
      }
    } catch (e) {
      // print("------2------${e.toString()}");
      customFlutterToast(msg: "Erreur: ----2----${e.toString()}");
      // return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
