import 'dart:convert';

import 'package:e_stock/models/order.dart';
import 'package:e_stock/other/const.dart';
import 'package:e_stock/screens/HomepageItem/AllProductsScreen.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:e_stock/widgets/CustomLoader.dart';
import 'package:e_stock/widgets/customFlutterToast.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../models/product.dart';
import 'package:http/http.dart' as http;
import '../../other/styles.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({
    super.key,
    this.type,
    this.e,
  });
  int? type;
  Product? e;
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late Order commande;
  late SharedPreferences prefs;
  late List<DropdownMenuItem> dropdownItems;
  List<Product> listProducts = [];
  late List<Product> listProductsToDisplay;
  List<TransactionItem> transactionItemList = [];
  bool _isLoading = false, _isSubmitting = false;
  initialize() async {
    setState(() {
      _isLoading = true;
    });
    await loadProductList();
    listProductsToDisplay = listProducts;
    dropdownItems = listProductsToDisplay
        .map((e) => DropdownMenuItem(
            value: e.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(e.name),
            )))
        .toList();
    prefs = await SharedPreferences.getInstance();
    int? shopID = prefs.getInt(PrefKeys.SHOP_ID);
    commande =
        Order(orderId: 1, type: widget.type ?? 0, shopId: shopID!, list: []);
    if (widget.e != null) {
      addTransactionItem(widget.e!.name);
    }
    setState(() {
      _isLoading = false;
    });
  }

  submitTransaction(Map<String, dynamic> data) async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      var body = data;
      body['commandes'] = json.encode(data['commandes']);
      print("---------------requesting $BASE_URL for submit transaction");
      http.Response response = await http.post(Uri.parse(BASE_URL), body: data);
      print("  response.body--------${response.body}");
      try {
        var jsonresponse = json.decode(response.body);
        // print("${response.body}");
        // print("${response.statusCode}");
        // print(jsonresponse);
        if (jsonresponse["status"]) {
          while (transactionItemList.isNotEmpty) {
            removeTransactionItem(transactionItemList.last.product);
          }
          customFlutterToast(
              msg: "Transaction effectuée avec succès", show: true);
          if (mounted && widget.e != null) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (builder) => const AllProductsScreen()));
          }
        }
      } catch (e) {
        customFlutterToast(msg: "------1------${e.toString()}");
      }
    } catch (e) {
      customFlutterToast(msg: "------2------${e.toString()}");
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  loadProductList() async {
    final prefs = await SharedPreferences.getInstance();
    final shopID = prefs.getInt(PrefKeys.SHOP_ID);
    final url = "$BASE_URL?magasin=$shopID&products";
    print(url);
    try {
      print("---------------requesting $url for get all products");
      http.Response response = await http.get(Uri.parse(url));
      var jsonresponse = json.decode(response.body);
      // print(response.body);
      // print(response.statusCode);
      print(jsonresponse);
      try {
        listProducts =
            (jsonresponse as List).map((e) => Product.fromJson(e)).toList();
      } catch (e) {
        customFlutterToast(msg: "Erreur: ----1----${e.toString()}");
      }
    } catch (e) {
      customFlutterToast(msg: "Erreur: ----2----${e.toString()}");
    } finally {}
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? customLoader(color: Theme.of(context).primaryColor)
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 60, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("    Type de transaction"),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10),
                          child: ToggleSwitch(
                            minWidth: MediaQuery.of(context).size.width * .4,
                            minHeight: 50,
                            // cornerRadius: 20,
                            activeBgColors: [
                              [Colors.green[800]!],
                              [Colors.red[800]!]
                            ],
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            initialLabelIndex: commande.type,
                            totalSwitches: 2,
                            animate: true,
                            curve: Curves.fastLinearToSlowEaseIn,
                            labels: const ['ENTREE', 'SORTIE'],
                            radiusStyle: true,
                            onToggle: (index) {
                              // 1 correspond a vente et 0 a approvisionnement
                              if (index! != commande.type) {
                                setState(() {
                                  commande.type = index;
                                  while (transactionItemList.isNotEmpty) {
                                    removeTransactionItem(
                                        transactionItemList.last.product);
                                  }
                                });
                                print('switched to: $index');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SearchChoices.single(
                    items: dropdownItems,
                    hint: "  Selectionner un produit ici",
                    searchHint: "Selectionner un produit",
                    fieldDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            width: 2, color: Theme.of(context).primaryColor)),
                    searchInputDecoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 2)
                            .copyWith(right: 0),
                        prefixIcon: const Icon(Icons.search),
                        iconColor: Colors.black),
                    onChanged: (value) => addTransactionItem(value.toString()),
                    isExpanded: true,
                  ),
                  Flexible(
                      flex: 5,
                      child: SingleChildScrollView(
                          child: Column(children: transactionItemList))),
                  Center(
                    heightFactor: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: const EdgeInsets.only(
                          // bottom: 20, top: !isKeyboardVisible ? 30 : 250),
                          bottom: 20,
                          top: 30),
                      child: ElevatedButton(
                        style: defaultStyle(context),
                        onPressed: () async {
                          if (transactionItemList.isEmpty) {
                            customFlutterToast(
                                msg: "Veuillez ajouter au moins un produit",
                                show: true);
                          } else if (!validateTransactionItem()) {
                            customFlutterToast(
                                msg: "Veuillez bien remplir tous les champs",
                                show: true);
                          } else {
                            commande.list = transactionItemList
                                .map((e) => OrderItem(
                                    productId: e.product.productID,
                                    quantity:
                                        int.parse(e.quantityController.text),
                                    purchasePrice:
                                        double.parse(e.priceController.text)))
                                .toList();
                            // print("${commande.toJsonEndoded()}");
                            if (await validateTransactionItem2()) {
                              await submitTransaction(commande.toJsonEndoded());
                            }
                          }
                        },
                        child: _isSubmitting
                            ? customLoader()
                            : const Text("Valider"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<bool> validateTransactionItem2() async {
    bool isValid = true;

    for (var element in transactionItemList) {
      if (commande.type == 0 &&
          element.product.sellingPrice <=
              double.parse(element.priceController.text)) {
        print("validateTransactionItem2");

        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Attention !!!'),
              content: Text(
                  "Pour le produit ${element.product.name} , le prix d'approvisionnement renseigné doit être inférieur au prix de vente\n Voulez-vous continuer ?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Oui', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    isValid = false;
                    Navigator.pop(context);
                  },
                  child:
                      const Text('Non', style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      }
      if (!isValid) break;
    }
    return isValid;
  }

  bool validateTransactionItem() {
    bool isValid = true;
    for (var element in transactionItemList) {
      if (!element.formKey.currentState!.validate()) {
        isValid = false;
      }
    }
    return isValid;
  }

  addTransactionItem(String name) {
    setState(() {
      Product product =
          listProductsToDisplay.firstWhere((element) => element.name == name);
      listProductsToDisplay.remove(product);
      transactionItemList.add(TransactionItem(
        type: commande.type,
        product: product,
        removeTransactionItem: removeTransactionItem,
      ));
      dropdownItems = listProductsToDisplay
          .map((e) => DropdownMenuItem(
              value: e.name,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(e.name),
              )))
          .toList();
    });
  }

  removeTransactionItem(Product product) {
    setState(() {
      listProductsToDisplay.add(product);
      transactionItemList.removeWhere((element) => element.product == product);
      dropdownItems = listProductsToDisplay
          .map((e) => DropdownMenuItem(
              value: e.name,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(e.name),
              )))
          .toList();
    });
  }
}

class TransactionItem extends StatelessWidget {
  TransactionItem({
    super.key,
    required this.product,
    required this.removeTransactionItem,
    required this.type,
  });
  final Product product;
  final void Function(Product) removeTransactionItem;
  final int type;
  final TextEditingController quantityController =
      TextEditingController(text: "0");
  final TextEditingController priceController =
      TextEditingController(text: "0");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .85,
      child: Form(
        key: formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 2, child: Center(child: Text(product.name))),
            const Flexible(flex: 1, child: SizedBox()),
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: CustomTextFormField(
                  textAlign: TextAlign.center,
                  hintText: "Quantité",
                  textInputType: TextInputType.number,
                  controller: quantityController,
                  onChanged: (value) {},
                  validatorFun: (p0) {
                    if (int.parse(p0!) <= 0) {
                      customFlutterToast(
                          msg: "La quantité doit être strtement positive",
                          show: true);
                      return " ";
                    } else if (type == 1 &&
                        int.parse(p0) > product.quantiteDisponible) {
                      customFlutterToast(
                          msg: product.quantiteDisponible == 0
                              ? "Le produit ${product.name} est épuisé"
                              : "Il n'y a que ${product.quantiteDisponible} ${product.name} en stock}",
                          show: true);
                      return " ";
                    }
                    return null;
                  },
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Visibility(
                visible: type == 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CustomTextFormField(
                    textAlign: TextAlign.center,
                    hintText: "Prix",
                    textInputType: TextInputType.number,
                    controller: priceController,
                    onChanged: (value) {},
                    validatorFun: (p0) {
                      if (type == 0 && double.parse(p0!) <= 0) {
                        customFlutterToast(
                            msg: "Le prix doit être strictement positif",
                            show: true);
                        return " ";
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Flexible(
                flex: 3,
                child: IconButton(
                    onPressed: () => removeTransactionItem(product),
                    icon: const Icon(Icons.delete, color: Colors.red)))
          ],
        ),
      ),
    );
  }
}
