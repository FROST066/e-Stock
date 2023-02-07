import 'package:e_stock/widgets/CustomTable.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../other/styles.dart';

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
  final repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
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
                  // const SizedBox(),
                  Text("Modifier le mot de passe",
                      style: GoogleFonts.oswald(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          decoration: TextDecoration.none,
                          color: Colors.black)),
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
                  child: Column(
                children: [
                  CustomPasswordFormField(
                    autofocus: true,
                    controller: oldPasswordController,
                    hintText: "Ancien mot de passe",
                  ),
                  CustomPasswordFormField(
                    controller: newPasswordController,
                    hintText: "Nouveau mot de passe",
                  ),
                ],
              )),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: defaultStyle(context),
                  onPressed: () {
                    //traitement
                    Navigator.pop(context);
                  },
                  child: const Text("Modifier  "),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
