import 'dart:convert';
import 'dart:io';

import 'package:e_stock/models/Categorie.dart';
import 'package:e_stock/other/styles.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../other/const.dart';

class AddOrEditCategoryScreen extends StatefulWidget {
  AddOrEditCategoryScreen({super.key, required this.categorie});
  Categorie? categorie;
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
    categNameController.text =
        widget.categorie == null ? "" : widget.categorie!.name;
    descController.text =
        widget.categorie == null ? "" : widget.categorie!.description;
    addOrEdit = widget.categorie == null;
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .9,
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
                            maxLines: 3,
                          )
                        ],
                      )),
                  // Flexible(child: SizedBox()),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 20, top: keyBordOpen ? 30 : 300),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          child: ElevatedButton(
                            style: defaultStyle(context),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              int? shopId = prefs.getInt(PrefKeys.SHOP_ID);
                              print(shopId);
                              final formData = {
                                "categoryID": addOrEdit
                                    ? "0"
                                    : widget.categorie!.categorieID.toString(),
                                "nom": categNameController.text,
                                "descriptions": descController.text,
                                "magasin": shopId!.toString(),
                              };
                              print(
                                  "---------------requesting $BASE_URL for categorie");
                              try {
                                http.Response response = await http.post(
                                  Uri.parse(BASE_URL),
                                  body: formData,
                                );
                                print("Avant jsondecode ${response.body}");
                                var jsonresponse = json.decode(response.body);
                                if (response.statusCode
                                    .toString()
                                    .startsWith("2")) {
                                  try {
                                    if (jsonresponse['status']) {
                                      print(jsonresponse);
                                      //traitement des données recues
                                      Navigator.pop(context);
                                    } else {
                                      print(
                                          "Une erreur est survenue lors de l'ajout de la catégorie");
                                    }
                                  } catch (e) {
                                    print("-----1-------${e.toString()}");
                                  }
                                } else {
                                  print(
                                      "pb httt code statuts ${response.statusCode}");
                                  // return false;
                                }
                              } catch (e) {
                                print("------2------${e.toString()}");
                                // return false;
                              } finally {
                                //set loading to false
                              }
                            },
                            child: Text(addOrEdit ? "Ajouter " : "Enregistrer"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
