import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../other/const.dart';
import '../other/styles.dart';
import 'CustomLoader.dart';
import 'customFlutterToast.dart';

class ChangePasswordDialogWidget extends StatefulWidget {
  const ChangePasswordDialogWidget({super.key, required this.ctx});
  final BuildContext ctx;
  @override
  State<ChangePasswordDialogWidget> createState() =>
      _ChangePasswordDialogWidgetState();
}

class _ChangePasswordDialogWidgetState
    extends State<ChangePasswordDialogWidget> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  changeMDP() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt(PrefKeys.USER_ID);
    var forData = {
      "changePassword": "1",
      "idUser": "$userID",
      "oldPassword": oldPasswordController.text,
      "newPassword": newPasswordController.text
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
          Navigator.pop(context);
          customFlutterToast(
              msg: "Mot de passe modifié avec succès", show: true);
        } else if (mounted) {
          customFlutterToast(
              msg: "L'ancien mot de passe est incorrect", show: true);
        }
      } catch (e) {
        customFlutterToast(msg: "Erreur:------1------ ${e.toString()}");
      }
    } catch (e) {
      customFlutterToast(msg: "Erreur: ------2------${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(widget.ctx).scaffoldBackgroundColor,
          ),
          height: 270,
          width: MediaQuery.of(widget.ctx).size.width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Modifier le mot de passe",
                      style: GoogleFonts.oswald(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          decoration: TextDecoration.none,
                          color:
                              Theme.of(widget.ctx).textTheme.bodyText2!.color)),
                  GestureDetector(
                    onTap: () => Navigator.pop(widget.ctx),
                    child: const Icon(
                      Icons.cancel,
                      size: 35,
                      color: appGrey,
                    ),
                  )
                ],
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomPasswordFormField(
                        autofocus: true,
                        controller: oldPasswordController,
                        labelText: "Ancien mot de passe",
                      ),
                      CustomPasswordFormField(
                        controller: newPasswordController,
                        labelText: "Nouveau mot de passe",
                      ),
                    ],
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: defaultStyle(context),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await changeMDP();
                    }
                  },
                  child: _isLoading ? customLoader() : const Text("Modifier  "),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
