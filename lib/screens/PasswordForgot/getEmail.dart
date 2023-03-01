import 'dart:io';

import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/PasswordForgot/ProvideNewMdp.dart';
import 'package:e_stock/screens/PasswordForgot/ProvideOtp.dart';
import 'package:e_stock/services/validator.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:e_stock/widgets/mainLogo.dart';
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: keyBordOpen
              ? MediaQuery.of(context).size.height * 0.5
              : MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const MainLogo(),
              Form(
                key: _formKey,
                child: CustomTextFormField(
                    controller: emailController,
                    hintText: "Adresse Email",
                    prefixIcon: Icons.email,
                    validatorFun: emailValidator,
                    textInputType: TextInputType.emailAddress),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: ElevatedButton(
                  style: defaultStyle(context),
                  onPressed: () => {
                    if (_formKey.currentState!.validate())
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (b) => ProvideOtp(
                                      email: emailController.text,
                                      afterOTPValidation: () =>
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      const ProvideNewMdp())),
                                    )))
                      }
                  },
                  child: const Text("Continuer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
