import 'package:e_stock/other/styles.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Votre email")),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.fill,
                ),
              ),
              CustomTextFormField(
                  controller: emailController,
                  hintText: "Adresse Email",
                  prefixIcon: Icons.email,
                  textInputType: TextInputType.emailAddress),
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
                        child: const Text("Continuer"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  void showMissing() {
    String msg = "";
    if (emailController.text == "" || !emailController.text.contains('@')) {
      msg = "Entrez un email valide";
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
