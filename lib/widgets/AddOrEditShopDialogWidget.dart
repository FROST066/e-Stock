import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/Shop.dart';
import '../other/styles.dart';

class AddOrEditShopDialogWidget extends StatefulWidget {
  AddOrEditShopDialogWidget(
      {super.key, required this.ctx, this.shop, this.updateFun, this.addFun});
  BuildContext ctx;
  Shop? shop;
  void Function(String)? updateFun;
  void Function(String)? addFun;
  @override
  State<AddOrEditShopDialogWidget> createState() =>
      _AddOrEditShopDialogWidgetState();
}

class _AddOrEditShopDialogWidgetState extends State<AddOrEditShopDialogWidget> {
  final shopNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool addOrEdit;
  @override
  void initState() {
    shopNameController.text = widget.shop == null ? "" : widget.shop!.shopName;
    addOrEdit = widget.shop == null;
    // true == add
    // false == Edit
    print(widget.shop!.shopName);
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
            color: Theme.of(widget.ctx).scaffoldBackgroundColor,
          ),
          height: 200,
          width: MediaQuery.of(widget.ctx).size.width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const SizedBox(),
                  Text(
                      addOrEdit
                          ? "Ajouter une boutique "
                          : "Modifier la boutique ",
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
                  key: _formKey,
                  child: CustomTextFormField(
                      autofocus: true,
                      controller: shopNameController,
                      hintText: "Nom de la boutique",
                      prefixIcon: Icons.business_outlined)),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: defaultStyle(context),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addOrEdit
                          ? widget.addFun!(shopNameController.text)
                          : widget.updateFun!(shopNameController.text);
                      Navigator.pop(context);
                    }
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
