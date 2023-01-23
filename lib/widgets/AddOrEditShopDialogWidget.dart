import 'package:e_stock/widgets/CustomTable.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../other/styles.dart';

class AddOrEditShopDialogWidget extends StatefulWidget {
  AddOrEditShopDialogWidget(
      {super.key,
      required this.ctx,
      this.shopName,
      this.updateFun,
      this.addFun});
  BuildContext ctx;
  String? shopName;
  void Function(String)? updateFun;
  void Function(String)? addFun;
  @override
  State<AddOrEditShopDialogWidget> createState() =>
      _AddOrEditShopDialogWidgetState();
}

class _AddOrEditShopDialogWidgetState extends State<AddOrEditShopDialogWidget> {
  final shopNameController = TextEditingController();
  late bool addOrEdit;
  @override
  void initState() {
    shopNameController.text = widget.shopName ?? "";
    addOrEdit = widget.shopName == null;
    // true == add
    // false == Edit
    print(widget.shopName);
    super.initState();
  }

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
          height: 200,
          width: MediaQuery.of(widget.ctx).size.width * 0.8,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text(
                      addOrEdit
                          ? "Ajouter une boutique "
                          : "Modifier la boutique ",
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
                  child: CustomTextFormField(
                      controller: shopNameController,
                      hintText: "Nom de la boutique",
                      prefixIcon: Icons.business_outlined)),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: defaultStyle,
                  onPressed: () {
                    addOrEdit
                        ? widget.addFun!(shopNameController.text)
                        : widget.updateFun!(shopNameController.text);
                    Navigator.pop(context);
                  },
                  child: Text(
                    addOrEdit ? "Valider " : "Modifier  ",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
