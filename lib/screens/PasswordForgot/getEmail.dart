import 'dart:io';

import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/PasswordForgot/ProvideOtp.dart';
import 'package:e_stock/services/validator.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetEmail extends StatefulWidget {
  const GetEmail({super.key});

  @override
  State<GetEmail> createState() => _GetEmailState();
}

class _GetEmailState extends State<GetEmail> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool keyBordOpen =
        !Platform.isLinux && MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(title: const Text("Votre email")),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            height:
                MediaQuery.of(context).size.height - (!keyBordOpen ? 100 : 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Image.asset(
                        "assets/images/getEmail.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: CustomTextFormField(
                          controller: emailController,
                          hintText: "Adresse Email",
                          prefixIcon: Icons.email,
                          validatorFun: emailValidator,
                          textInputType: TextInputType.emailAddress),
                    ),
                  ],
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
                          style: defaultStyle,
                          onPressed: () => {
                            if (_formKey.currentState!.validate())
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (b) => const ProvideOtp()))
                              }
                          },
                          child: const Text("Continuer"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
