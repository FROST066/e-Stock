import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:e_stock/models/product.dart';
import 'package:e_stock/screens/HomepageItem/AddOrEditProductScreen.dart';
import 'package:e_stock/screens/HomepageItem/filteringScreen.dart';
import 'package:e_stock/services/static.dart';
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

import '../../widgets/customFlutterToast.dart';

class AllProductsScreen extends StatefulWidget {
  AllProductsScreen({super.key, this.initFilter});
  bool? initFilter;
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
  String filterStatus = "Tous les produits";
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

  Future<void> filter(bool isLowStock, int categoryId) async {
    filteredProductsList.clear();
    if (isLowStock && categoryId != 0) {
      for (Product item in productsList) {
        if (item.stockMin > item.quantiteDisponible &&
            item.categoryID == categoryId) {
          filteredProductsList.add(item);
        }
      }
      var categoryName = await StaticValues.getCategoryNameByID(categoryId);
      filterStatus =
          "Tous les produits \nen rupture de stock \nde  $categoryName";
    } else if (categoryId != 0) {
      for (Product item in productsList) {
        if (item.categoryID == categoryId) {
          filteredProductsList.add(item);
        }
      }
      var categoryName = await StaticValues.getCategoryNameByID(categoryId);
      filterStatus = "Tous les produits \nde la  $categoryName";
    } else if (isLowStock) {
      for (Product item in productsList) {
        if (item.stockMin > item.quantiteDisponible) {
          filteredProductsList.add(item);
        }
      }
      filterStatus = "Tous les produits \nen rupture de stock";
    } else {
      filteredProductsList.addAll(productsList);
      filterStatus = "Tous les produits";
    }
    setState(() {});
  }

  @override
  void initState() {
    loadProductList();
    if (widget.initFilter == true) {
      filter(true, 0);
    }
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
      appBar: AppBar(title: const Text("Mes produits")),
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
                          if (filterStatus != "Tous les produits") {
                            filter(false, 0);
                          }
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
                    icon: const Icon(MdiIcons.tuneVertical, size: 30),
                    padding: const EdgeInsets.only(bottom: 10),
                    onPressed: () => showAnimatedDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext ctx) =>
                            FilteringDialog(filter: filter),
                        animationType: DialogTransitionType.slideFromBottom,
                        // animationType: DialogTransitionType.scale,
                        // curve: Curves.linear,
                        duration: const Duration(seconds: 1)),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(filterStatus, style: ts),
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
                            customCard(filteredProductsList[index], context,
                                loadProductList),
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
    child: badges.Badge(
      badgeAnimation: const badges.BadgeAnimation.slide(
        animationDuration: Duration(seconds: 2),
        loopAnimation: true,
        curve: Curves.slowMiddle,
      ),
      showBadge: e.stockMin > e.quantiteDisponible,
      badgeContent: Text(
        e.quantiteDisponible.toString(),
        style: const TextStyle(color: Colors.white),
      ),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
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
                decoration: BoxDecoration(
                    color: StaticValues.getIsLightMode! ? appGrey : appDarkGrey,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(e.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
    ),
  );
}
