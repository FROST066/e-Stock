import 'dart:convert';
import 'dart:io';

import 'package:e_stock/models/Category.dart';
import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/HomePage.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../other/const.dart';
import '../../widgets/CustomLoader.dart';
import '../../widgets/customFlutterToast.dart';

class AddOrEditCategoryScreen extends StatefulWidget {
  AddOrEditCategoryScreen({super.key, required this.category});
  Category? category;
  @override
  State<AddOrEditCategoryScreen> createState() =>
      _AddOrEditCategoryScreenState();
}

class _AddOrEditCategoryScreenState extends State<AddOrEditCategoryScreen> {
  final formKey = GlobalKey<FormState>();
  final categNameController = TextEditingController();
  final descController = TextEditingController();
  late bool addOrEdit;
  bool _isLoading = false;
  @override
  void initState() {
    categNameController.text =
        widget.category == null ? "" : widget.category!.name;
    descController.text =
        widget.category == null ? "" : widget.category!.description;
    addOrEdit = widget.category == null;
    // true == add
    // false == Edit
    super.initState();
  }

  addOrEditFunc() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    int? shopId = prefs.getInt(PrefKeys.SHOP_ID);
    final formData = {
      "categoryID": addOrEdit ? "0" : widget.category!.categoryId.toString(),
      "nom": categNameController.text,
      "descriptions": descController.text,
      "magasin": "${shopId!}",
    };
    try {
      print("---------------requesting $BASE_URL for Category");
      try {
        http.Response response =
            await http.post(Uri.parse(BASE_URL), body: formData);
        print("Avant jsondecode ${response.body}");
        var jsonresponse = json.decode(response.body);

        if (jsonresponse['status']) {
          print(jsonresponse);
          //traitement des données recues
          // Navigator.pop(context);
          if (mounted) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (builder) => const HomePage(selectedIndex: 1)),
                (route) => false);
          }
        }
      } catch (e) {
        //print("-----1-------${e.toString()}");
        customFlutterToast(msg: "Erreur: ----1----${e.toString()}");
      }
    } catch (e) {
      // print("------2------${e.toString()}");
      customFlutterToast(msg: "Erreur: ----2----${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          child: ElevatedButton(
                            style: defaultStyle(context),
                            onPressed: () async {
                              if (!_isLoading &&
                                  formKey.currentState!.validate()) {
                                await addOrEditFunc();
                              }
                            },
                            child: _isLoading
                                ? customLoader()
                                : Text(addOrEdit ? "Ajouter " : "Enregistrer"),
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
}
