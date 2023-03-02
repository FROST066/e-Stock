import 'dart:async';
import 'dart:io';
import 'package:e_stock/widgets/customFlutterToast.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class ProvideOtp extends StatefulWidget {
  const ProvideOtp(
      {super.key, required this.email, required this.afterOTPValidation});
  final String email;
  final void Function() afterOTPValidation;
  @override
  State<ProvideOtp> createState() => _ProvideOtpState();
}

class _ProvideOtpState extends State<ProvideOtp> {
  int _start = 30;
  bool isEnabled = false;
  Timer timer = Timer(const Duration(seconds: 1), () {});
  EmailOTP myauth = EmailOTP();
  @override
  void initState() {
    startTimer();
    super.initState();
  }

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
              Container(
                margin: const EdgeInsets.only(top: 25),
                height: 150,
                width: 150,
                child: CircleAvatar(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(CupertinoIcons.lock_shield_fill, size: 100),
                ),
              ),
              const Text("Entrez le code",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("Nous avons envoyé le code OTP à votre adresse mail"),
              OTPTextField(
                  length: 5,
                  otpFieldStyle: OtpFieldStyle(
                      enabledBorderColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.2)),
                  keyboardType: TextInputType.number,
                  width: MediaQuery.of(context).size.width * 0.8,
                  fieldWidth: (MediaQuery.of(context).size.width * 0.7 / 5) - 8,
                  style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).appBarTheme.foregroundColor),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onChanged: (value) => print(value),
                  onCompleted: onOTPFieldComplete),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Renvoyer le code dans 0:$_start"),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: isEnabled
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    onPressed: isEnabled ? () => startTimer() : null,
                    child: Text(
                      "Renvoyer",
                      style: GoogleFonts.lora(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startTimer() async {
    myauth.setConfig(
        appEmail: "e-stockteam@gmail.com",
        appName: "e-Stock",
        userEmail: widget.email,
        otpLength: 5,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == false) {
      customFlutterToast(msg: "Oops, le code n'a pas été envoyé");
    } else {
      // customFlutterToast(msg: "le code n'a pas été envoyé");
      const oneSec = Duration(seconds: 1);
      setState(() {
        isEnabled = false;
      });
      timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              timer.cancel();
              setState(() {
                isEnabled = true;
              });
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }

  Future<void> onOTPFieldComplete(String pin) async {
    // print("Completed: " + pin);
    if (await myauth.verifyOTP(otp: pin) == true) {
      customFlutterToast(msg: "Verification réussie");
      widget.afterOTPValidation();
    } else {
      customFlutterToast(msg: "Le code est incorrect");
    }
  }
}
