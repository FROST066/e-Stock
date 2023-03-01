import 'dart:convert';

import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:e_stock/widgets/CustomLoader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/Shop.dart';
import '../other/const.dart';
import '../other/styles.dart';
import 'customFlutterToast.dart';

class AddOrEditShopDialogWidget extends StatefulWidget {
  AddOrEditShopDialogWidget(
      {super.key, required this.ctx, this.shop, this.updateFun, this.addFun});
  BuildContext ctx;
  Shop? shop;
  void Function(String)? updateFun;
  void Function(int, String)? addFun;
  @override
  State<AddOrEditShopDialogWidget> createState() =>
      _AddOrEditShopDialogWidgetState();
}

class _AddOrEditShopDialogWidgetState extends State<AddOrEditShopDialogWidget> {
  final shopNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool addOrEdit;
  bool _isCreating = false;

  createShop() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt(PrefKeys.USER_ID);
    setState(() {
      _isCreating = true;
    });
    final formData = {
      "createMagasin": "1",
      "nom": shopNameController.text,
      "user": "$userID"
    };
    try {
      print("---------------requesting $BASE_URL");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: formData);
      // print(response.statusCode);
      var jsonresponse = json.decode(response.body);
      print(jsonresponse);
      try {
        widget.addFun!(int.parse(jsonresponse['id']), shopNameController.text);
      } catch (e) {
        //print("-----1-------${e.toString()}");
        customFlutterToast(msg: "Erreur: ----1----${e.toString()}");
      }
    } catch (e) {
      // print("------2------${e.toString()}");
      customFlutterToast(msg: "Erreur: ----2----${e.toString()}");
      // return false;
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  updateShop() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt(PrefKeys.USER_ID);
    setState(() {
      _isCreating = true;
    });
    final formData = {
      "updateShop": "1",
      "nom": shopNameController.text,
      "userID": "$userID",
      "ShopId": "${widget.shop!.id}"
    };
    try {
      print("---------------requesting $BASE_URL  for update");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: formData);
      // print(response.statusCode);
      // print(response.body);
      var jsonresponse = json.decode(response.body);
      print(jsonresponse);
      try {
        widget.updateFun!(shopNameController.text);
      } catch (e) {
        //print("-----1-------${e.toString()}");
        customFlutterToast(msg: "Erreur: ----1----${e.toString()}");
      }
    } catch (e) {
      // print("------2------${e.toString()}");
      customFlutterToast(msg: "Erreur: ----2----${e.toString()}");
      // return false;
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  void initState() {
    shopNameController.text = widget.shop == null ? "" : widget.shop!.shopName;
    addOrEdit = widget.shop == null;
    // true == add
    // false == Edit
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
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: defaultStyle(context),
                  onPressed: () async {
                    if (!_isCreating && _formKey.currentState!.validate()) {
                      addOrEdit ? await createShop() : await updateShop();
                      Navigator.pop(context);
                    }
                  },
                  child: _isCreating
                      ? customLoader()
                      : Text(addOrEdit ? "Valider " : "Modifier  "),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
