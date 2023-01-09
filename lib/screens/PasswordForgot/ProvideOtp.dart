import 'dart:io';

import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/PasswordForgot/ProvideNewMdp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class ProvideOtp extends StatefulWidget {
  const ProvideOtp({super.key});

  @override
  State<ProvideOtp> createState() => _ProvideOtpState();
}

class _ProvideOtpState extends State<ProvideOtp> {
  @override
  Widget build(BuildContext context) {
    bool keyBordOpen =
        !Platform.isLinux && MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(title: const Text("Verification email")),
      body: Center(
        heightFactor: 1,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              const Text("Verifiez votre boite mail. Le code a été envoyé"),
              OTPTextField(
                  length: 5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fieldWidth: (MediaQuery.of(context).size.width * 0.7 / 5) - 8,
                  style: const TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onChanged: (value) => print(value),
                  onCompleted: onOTPFieldComplete),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Renvoyer le code dans 0:30"),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Renvoyer",
                      style: GoogleFonts.lora(color: appBlue, fontSize: 17),
                    ),
                  )
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
                        onPressed: () {},
                        child: const Text("Valider",
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onOTPFieldComplete(String pin) {
    print("Completed: " + pin);
    //check if correct code by Firebase authentification
    // if ok
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const ProvideNewMdp()));
  }
}
