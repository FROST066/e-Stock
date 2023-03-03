import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/PasswordForgot/Congrats.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:e_stock/widgets/customFlutterToast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../other/const.dart';
import '../../widgets/CustomLoader.dart';

class ProvideNewMdp extends StatefulWidget {
  const ProvideNewMdp({super.key, required this.email});
  final String email;
  @override
  State<ProvideNewMdp> createState() => _ProvideNewMdpState();
}

class _ProvideNewMdpState extends State<ProvideNewMdp> {
  final formKey = GlobalKey<FormState>();
  final mdpController = TextEditingController();
  final confirmedMdpController = TextEditingController();
  bool _isLoading = false;

  changeMDP() async {
    setState(() {
      _isLoading = true;
    });

    var forData = {
      "forgotPassword": "1",
      "email": widget.email,
      "newMdp": mdpController.text
    };
    print("----------formData: $forData");
    try {
      print("---------------requesting $BASE_URL for change password");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: forData);
      try {
        var jsonresponse = json.decode(response.body);
        // print(response.body);
        // print("${response.statusCode}");
        // print(jsonresponse);
        if (jsonresponse["status"] && mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (b) => const Congrats()));
        }
      } catch (e) {
        customFlutterToast(msg: "------1------${e.toString()}");
      }
    } catch (e) {
      customFlutterToast(msg: "------2------${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperation du mot de passe")),
      body: Center(
          child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
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
                      CustomPasswordFormField(
                        controller: mdpController,
                        labelText: "Mot de passe",
                      ),
                      CustomPasswordFormField(
                        controller: confirmedMdpController,
                        labelText: "Confirmer le mot de passe",
                      )
                    ],
                  )),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: ElevatedButton(
                        style: defaultStyle(context),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (mdpController.text ==
                                confirmedMdpController.text) {
                              await changeMDP();
                            } else {
                              customFlutterToast(
                                  msg:
                                      "Les 2 mots de passe entrés ne correspondent pas",
                                  show: true);
                            }
                          }
                        },
                        child:
                            _isLoading ? customLoader() : const Text("Valider"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
}
