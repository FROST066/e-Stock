import 'dart:convert';
import 'dart:io';
import 'package:e_stock/other/styles.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/product.dart';
import '../../other/const.dart';
import '../../widgets/customFlutterToast.dart';

class AddOrEditProductScreen extends StatefulWidget {
  AddOrEditProductScreen({super.key, this.product});
  Product? product;
  @override
  State<AddOrEditProductScreen> createState() => _AddOrEditProductScreenState();
}

class _AddOrEditProductScreenState extends State<AddOrEditProductScreen> {
  final formKey = GlobalKey<FormState>();
  final categNameController = TextEditingController();
  final descController = TextEditingController();
  late bool addOrEdit;
  bool _isLoading = false;
  @override
  void initState() {
    categNameController.text =
        widget.product == null ? "" : widget.product!.name;
    descController.text =
        widget.product == null ? "" : widget.product!.description;
    addOrEdit = widget.product == null;
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
      "categoryID": addOrEdit ? "0" : widget.product!.categoryId.toString(),
      "nom": categNameController.text,
      "descriptions": descController.text,
      "magasin": "${shopId!}",
    };
    try {
      print(
          "---------------requesting $BASE_URL for ${addOrEdit ? "add" : "edit "}Category");
      try {
        http.Response response =
            await http.post(Uri.parse(BASE_URL), body: formData);
        print("Avant jsondecode ${response.body}");
        var jsonresponse = json.decode(response.body);

        if (jsonresponse['status']) {
          print(jsonresponse);
          //traitement des données recues
          if (mounted) {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (builder) => const HomePage(selectedIndex: 1)),
            //     (route) => false);
          }
        }
      } catch (e) {
        print("-----1-------${e.toString()}");
      }
    } catch (e) {
      print("------2------${e.toString()}");
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
          title:
              Text(addOrEdit ? "Ajouter une Produit" : "Modifier la Produit ")),
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
                            controller: categNameController,
                            hintText: "Nom de la catégorie",
                            prefixIcon: Icons.category,
                          ),
                          CustomTextFormField(
                            controller: categNameController,
                            hintText: "Nom de la catégorie",
                            prefixIcon: Icons.category,
                          ),
                          CustomTextFormField(
                            controller: categNameController,
                            hintText: "Nom de la catégorie",
                            prefixIcon: Icons.category,
                          ),
                          CustomTextFormField(
                            controller: categNameController,
                            hintText: "Nom de la catégorie",
                            prefixIcon: Icons.category,
                          ),
                          CustomTextFormField(
                            controller: categNameController,
                            hintText: "Nom de la catégorie",
                            prefixIcon: Icons.category,
                          ),
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
                              if (!_isLoading &&
                                  formKey.currentState!.validate()) {
                                await addOrEditFunc();
                              }
                            },
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
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

  void showMissing() {
    if (categNameController.text == "") {
      customFlutterToast(msg: "Entrez le nom de la catégorie");
    } else {
      //enregistrement
      Navigator.pop(context);
    }
  }
}
