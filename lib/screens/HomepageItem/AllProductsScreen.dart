import 'dart:convert';

import 'package:e_stock/models/product.dart';
import 'package:e_stock/screens/HomepageItem/AddOrEditProductScreen.dart';
import 'package:e_stock/screens/HomepageItem/filteringScreen.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:e_stock/widgets/ProductDialogWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../other/const.dart';
import '../../other/styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

TextStyle ts = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

class _AllProductsScreenState extends State<AllProductsScreen> {
  // List<Product> productsList = [
  //   Product(
  //       productId: 1,
  //       name: "Carotte",
  //       description: "bla bal balla bla bla bla c'est une longue descritption",
  //       categoryId: 11,
  //       low: 20,
  //       sellingPrice: 250,
  //       purchasePrice: 500,
  //       url:
  //           "https://firebasestorage.googleapis.com/v0/b/e-stock0.appspot.com/o/user1%2Fproduts%2F66700634ebb34731a4adb6a1f2f74bb2.jpg?alt=media&token=67bf0513-7362-4f1e-8185-676bec5c6412"),
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
  //     name: "Carotte",
  //     description: "bla bal balla bla bla bla c'est une longue descritption",
  //     categoryId: 1,
  //     low: 20,
  //     sellingPrice: 250,
  //     purchasePrice: 500,
  //   ),
  //   Product(
  //       productId: 3,
  //       name: "Pomme",
  //       description: "bla bal balla bla bla bla c'est une longue descritption",
  //       categoryId: 1,
  //       low: 10,
  //       sellingPrice: 100,
  //       purchasePrice: 300),
  // ];
  List<Product> productsList = [];
  List<Product> filteredProductsList = [];
  bool _isLoading = false;
  Future<void> loadProductList() async {
    final prefs = await SharedPreferences.getInstance();
    final shopID = prefs.getInt(PrefKeys.SHOP_ID);
    setState(() {
      _isLoading = true;
    });
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
        productsList =
            (jsonresponse as List).map((e) => Product.fromJson(e)).toList();
        filteredProductsList.clear();
        filteredProductsList.addAll(productsList);
      } catch (e) {
        print("-----1-------${e.toString()}");
      }
    } catch (e) {
      print("------2------${e.toString()}");
      // return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    loadProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) =>
                      AddOrEditProductScreen(refresh: loadProductList))),
          child: const Icon(Icons.add)),
      appBar: AppBar(title: const Text("Produits")),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 7,
                      child: CustomTextFormField(
                        hintText: "Chercher un produit",
                        prefixIcon: Icons.search,
                        onChanged: (value) {
                          setState(() {
                            filteredProductsList.clear();
                            if (value.isEmpty) {
                              filteredProductsList.addAll(productsList);
                            } else {
                              for (Product item in productsList) {
                                if (item.name
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) {
                                  filteredProductsList.add(item);
                                }
                              }
                            }
                          });
                        },
                      )),
                  IconButton(
                      padding: const EdgeInsets.only(bottom: 10),
                      onPressed: () => showCustomDialogForFilter(),
                      icon: const Icon(MdiIcons.tuneVertical, size: 30))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tous les produits", style: ts),
                      Text("Total: ${filteredProductsList.length}", style: ts),
                    ]),
              ),
              Expanded(
                flex: 9,
                child: _isLoading
                    ? const Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()))
                    : GridView.builder(
                        itemCount: filteredProductsList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            customCard(
                          filteredProductsList[index],
                          context,
                          loadProductList,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10),
                        padding: const EdgeInsets.all(10),
                        shrinkWrap: true,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showCustomDialogForFilter() {
    showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return FilteringDialog(ctx: ctx);
        },
        animationType: DialogTransitionType.slideFromBottom,
        // animationType: DialogTransitionType.scale,
        // curve: Curves.linear,
        duration: const Duration(seconds: 1));
  }
}

Widget customCard(
    Product e, BuildContext context, Future<void> Function() refresh) {
  return GestureDetector(
    onTap: () => showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return ProductDialogWidget(e: e, refresh: refresh, ctx: ctx);
        },
        animationType: DialogTransitionType.slideFromBottom,
        // animationType: DialogTransitionType.scale,
        // curve: Curves.linear,
        duration: const Duration(seconds: 1)),
    child: Container(
      // margin: const EdgeInsets.symmetric(vertical: 7),
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Colors.grey, //New
              blurRadius: 20.0,
              offset: Offset(0, 12))
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Center(
              child: e.url == null
                  ? Icon(
                      LineIcons.tags,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    )
                  : Image.network(e.url!, width: 190),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 12),
              decoration: const BoxDecoration(
                  color: appGrey,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(e.name,
                      style: ts.copyWith(
                          color: ThemeData.dark().scaffoldBackgroundColor)),
                  Text(
                    "${e.sellingPrice} FCFA",
                    style: TextStyle(
                        color: ThemeData.dark().scaffoldBackgroundColor),
                  ),
                  const SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

// void showCustomDialog(BuildContext context, Product e) {
//   showAnimatedDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext ctx) {
//         return productDialogWidget(ctx, e);
//       },
//       animationType: DialogTransitionType.slideFromBottom,
//       // animationType: DialogTransitionType.scale,
//       // curve: Curves.linear,
//       duration: const Duration(seconds: 1));
// }
