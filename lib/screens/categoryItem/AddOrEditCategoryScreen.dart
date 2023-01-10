import 'dart:io';

import 'package:e_stock/other/styles.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddOrEditCategoryScreen extends StatefulWidget {
  AddOrEditCategoryScreen({super.key, this.name, this.description});
  String? name, description;
  @override
  State<AddOrEditCategoryScreen> createState() =>
      _AddOrEditCategoryScreenState();
}

class _AddOrEditCategoryScreenState extends State<AddOrEditCategoryScreen> {
  final formKey = GlobalKey<FormState>();
  final categNameController = TextEditingController();
  final descController = TextEditingController();
  late bool addOrEdit;
  @override
  void initState() {
    categNameController.text = widget.name ?? "";
    descController.text = widget.description ?? "";
    addOrEdit = widget.name == null;
    // true == add
    // false == Edit
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool keyBordOpen =
        !Platform.isLinux && MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
          title: Text(
              addOrEdit ? "Ajouter une catégorie" : "Modifier la catégorie ")),
      body: Center(
          heightFactor: 1,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 35),
                        CustomTextFormField(
                          controller: categNameController,
                          hintText: "Nom de la catégorie",
                          prefixIcon: Icons.category,
                        ),
                        CustomTextFormField(
                          controller: descController,
                          hintText: "Description",
                          prefixIcon: Icons.description,
                          maxLines: 4,
                        )
                      ],
                    )),
                // Flexible(child: SizedBox()),
                Container(
                  margin:
                      EdgeInsets.only(bottom: 20, top: keyBordOpen ? 30 : 300),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: ElevatedButton(
                          style: defaultStyle,
                          onPressed: () => showMissing(),
                          child: Text(addOrEdit ? "Ajouter " : "Enregistrer"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void showMissing() {
    if (categNameController.text == "") {
      Fluttertoast.showToast(
        msg: "Entrez le nom de la catégorie",
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } else {
      //enregistrement
      Navigator.pop(context);
    }
  }
}
