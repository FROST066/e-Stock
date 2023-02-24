import 'dart:convert';

import 'package:e_stock/models/order.dart';
import 'package:e_stock/other/const.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:e_stock/widgets/Loader.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../models/product.dart';
import 'package:http/http.dart' as http;
import '../../other/styles.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});
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
    commande = Order(orderId: 1, type: 0, shopId: shopID!, list: []);
    setState(() {
      _isLoading = false;
    });
  }

  submitTransaction(Map<String, dynamic> data) async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      var headers = {'Content-Type': 'application/json'};
      var body = json.encode(data);
      print("body: $body");
      print("---------------requesting $BASE_URL for submit transaction");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), headers: headers, body: body);
      var jsonresponse = json.decode(response.body);
      print("${response.body}");
      print("${response.statusCode}");
      print(jsonresponse);
      // if (jsonresponse["status"]) {
      //   while (transactionItemList.isNotEmpty) {
      //     removeTransactionItem(transactionItemList.last.product);
      //   }
      // }
    } catch (e) {
      print("------1------${e.toString()}");
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
        print("-----1-------${e.toString()}");
      }
    } catch (e) {
      print("------2------${e.toString()}");
      // return false;
    } finally {}
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  // List<Product> listProducts = [
  //   Product(
  //     productId: 1,
  //     name: "Carotte",
  //     description: "bla bal balla bla bla bla c'est une longue descritption",
  //     categoryId: 1,
  //     low: 20,
  //     sellingPrice: 250,
  //     purchasePrice: 500,
  //   ),
  //   Product(
  //     productId: 2,
  //     name: "Tomate",
  //     description: "bla bal balla bla bla bla c'est une longue descritption",
  //     categoryId: 1,
  //     low: 30,
  //     sellingPrice: 350,
  //     purchasePrice: 500,
  //   ),
  //   Product(
  //     productId: 2,
  //     name: "Telephone",
  //     description: "bla bal balla bla bla bla c'est une longue descritption",
  //     categoryId: 1,
  //     low: 20,
  //     sellingPrice: 250,
  //     purchasePrice: 500,
  //   ),
  //   Product(
  //     productId: 3,
  //     name: "Pomme",
  //     description: "bla bal balla bla bla bla c'est une longue descritption",
  //     categoryId: 1,
  //     low: 10,
  //     sellingPrice: 100,
  //     purchasePrice: 300,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    items: dropdownItems,
                    hint: "  Produit",
                    searchHint: "Selectionner un produit",
                    fieldDecoration: BoxDecoration(
                      color: appGrey,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: appGrey),
                    ),
                    searchInputDecoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 2)
                            .copyWith(right: 0),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: appDarkGrey,
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
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: const EdgeInsets.only(
                          // bottom: 20, top: !isKeyboardVisible ? 30 : 250),
                          bottom: 20,
                          top: 30),
                      child: ElevatedButton(
                        style: defaultStyle(context),
                        onPressed: () async {
                          commande.list = transactionItemList
                              .map((e) => OrderItem(
                                  productId: e.product.productID,
                                  quantity:
                                      int.parse(e.quantityController.text),
                                  purchasePrice:
                                      double.parse(e.priceController.text)))
                              .toList();
                          // print("${commande.toJsonEndoded()}");
                          await submitTransaction(commande.toJsonEndoded());
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
  TransactionItem(
      {super.key,
      required this.product,
      required this.removeTransactionItem,
      required this.type});
  final Product product;
  void Function(Product) removeTransactionItem;
  final int type;
  TextEditingController quantityController = TextEditingController(text: "0");
  TextEditingController priceController = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .85,
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
    );
  }
}
