import 'dart:convert';
import 'dart:io';
import 'package:e_stock/other/styles.dart';
import 'package:e_stock/services/static.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:e_stock/widgets/Loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/product.dart';
import '../../other/const.dart';
import '../../widgets/customFlutterToast.dart';

class AddOrEditProductScreen extends StatefulWidget {
  AddOrEditProductScreen({super.key, this.product, required this.refresh});
  Product? product;
  final Future<void> Function() refresh;
  @override
  State<AddOrEditProductScreen> createState() => _AddOrEditProductScreenState();
}

class _AddOrEditProductScreenState extends State<AddOrEditProductScreen> {
  final formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final lowController = TextEditingController();
  final priceController = TextEditingController();
  late bool addOrEdit;
  bool _isLoading = false, _isFecthing = false;
  int? selectedCategorie;
  String? url;

  File? imageFile;
  @override
  void initState() {
    if (widget.product != null) {
      productNameController.text = widget.product!.name;
      descriptionController.text = widget.product!.description;
      lowController.text = widget.product!.stockMin.toString();
      priceController.text = widget.product!.sellingPrice.toString();
      selectedCategorie = widget.product!.categoryID;
      url = widget.product!.url;
    }
    addOrEdit = widget.product == null;
    // true == add
    // false == Edit
    initialize();
    super.initState();
  }

  initialize() async {
    setState(() {
      _isFecthing = true;
    });
    if (StaticValues.getListCategories.isEmpty) {
      await StaticValues.loadCategoryList();
    }
    setState(() {
      _isFecthing = false;
    });
  }

  addOrEditFunc() async {
    setState(() {
      _isLoading = true;
    });
    final urlGot = await uploadAndGetUrl();
    final formData = addOrEdit
        ? {
            "nom": productNameController.text,
            "createProduct": "1",
            "description": descriptionController.text,
            "prixUnitaire": priceController.text,
            "quantiteDisponible": "0",
            "categorie": "${selectedCategorie!}",
            "urlPhoto": urlGot ?? url ?? ""
          }
        : {
            "updateProduct": "1",
            "nom": productNameController.text,
            "description": descriptionController.text,
            "prixUnitaire": priceController.text,
            "quantiteDisponible": "0",
            "categorie": "${selectedCategorie!}",
            "idProduct": widget.product!.productID.toString(),
          };
    print("${formData}");
    try {
      print(
          "---------------requesting $BASE_URL for ${addOrEdit ? "add" : "edit "} product ");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: formData);
      var jsonresponse = json.decode(response.body);
      print("${response.body}");
      print("${response.statusCode}");
      print(jsonresponse);
      if (mounted && jsonresponse["status"]) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("------1------${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          const SizedBox(height: 25),
                          CustomTextFormField(
                            controller: productNameController,
                            hintText: "Nom du produit",
                          ),
                          CustomTextFormField(
                            controller: descriptionController,
                            hintText: "Description du produit",
                          ),
                          _isFecthing
                              ? customLoader()
                              : Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 10, top: 5),
                                  child: DropdownButtonFormField<int>(
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                        labelText: "Selectionner une categorie",
                                        labelStyle: Theme.of(context)
                                            .inputDecorationTheme
                                            .labelStyle,
                                        enabledBorder: Theme.of(context)
                                            .inputDecorationTheme
                                            .enabledBorder,
                                        focusedBorder: Theme.of(context)
                                            .inputDecorationTheme
                                            .focusedBorder,
                                        iconColor: Colors.black),
                                    value: selectedCategorie,
                                    items: StaticValues.getListCategories
                                        .map((e) => DropdownMenuItem(
                                            value: e.categoryId,
                                            child: Text(
                                              e.name,
                                              style:
                                                  const TextStyle(fontSize: 21),
                                            )))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCategorie = value ?? 0;
                                      });
                                    },
                                    validator: (e) {
                                      return (e == null)
                                          ? "Ce champ est obligatoire"
                                          : null;
                                    },
                                  ),
                                ),
                          // CustomTextFormField(
                          //   controller: lowController,
                          //   hintText: "Stock critique",
                          //   textInputType: TextInputType.number,
                          // ),
                          CustomTextFormField(
                            controller: priceController,
                            hintText: "Prix de vente",
                            textInputType: TextInputType.number,
                          ),
                        ],
                      )),
                  const Text("Image du produit",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: url == null
                          ? imageFile != null
                              ? Stack(
                                  children: [
                                    ClipOval(
                                      child: Image.file(
                                        imageFile!,
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Theme.of(context).primaryColor),
                                        child: InkWell(
                                          onTap: () => getFile(),
                                          child: const Icon(
                                              CupertinoIcons.camera,
                                              size: 40),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : InkWell(
                                  onTap: () => getFile(),
                                  child: const Icon(Icons.add_a_photo_outlined,
                                      size: 80),
                                )
                          : Stack(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    url!,
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    height:
                                        MediaQuery.of(context).size.width * .5,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor),
                                    child: InkWell(
                                      onTap: () => getFile(),
                                      child: const Icon(CupertinoIcons.camera,
                                          size: 40),
                                    ),
                                  ),
                                )
                              ],
                            )),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 30),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: ElevatedButton(
                        style: defaultStyle(context),
                        onPressed: () async {
                          if (!_isLoading && formKey.currentState!.validate()) {
                            await addOrEditFunc();
                            widget.refresh();
                          }
                        },
                        child: _isLoading
                            ? customLoader()
                            : Text(addOrEdit ? "Ajouter " : "Enregistrer"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      print(result.files.single.path);
      setState(() {
        url = null;
        imageFile = File(result.paths[0]!);
      });
    }
  }

  Future<String?> uploadAndGetUrl() async {
    if (imageFile == null) {
      return null;
    }
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt(PrefKeys.USER_ID);
    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();
    // Upload file and metadata to the path 'images/mountains.jpg'
    final childTask = storageRef
        .child("user$userID/produts/${imageFile!.path.split('/').last}");
    final uploadTask = await childTask.putFile(imageFile!);
    final essai = await childTask.getDownloadURL();
    print(essai);
    return essai;
  }
}
