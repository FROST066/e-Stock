import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
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
import '../HomePage.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key, this.initFilter});
  final bool? initFilter;
  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

TextStyle ts = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

class _AllProductsScreenState extends State<AllProductsScreen> {
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
        widget.initFilter != null && widget.initFilter == true
            ? await filter(true, 0)
            : await filter(false, 0);
      } catch (e) {
        customFlutterToast(msg: "Erreur: ----1----${e.toString()}");
      }
    } catch (e) {
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
      print("filteredProductsList: ${filteredProductsList.length}");
      filterStatus = "Tous les produits \nen rupture de stock";
    } else {
      filteredProductsList.addAll(productsList);
      filterStatus = "Tous les produits";
    }
    // setState(() {
    //   filteredProductsList;
    // });
  }

  @override
  void initState() {
    super.initState();
    loadProductList();
  }

  Future<bool> onWillPop() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (builder) => const HomePage(selectedIndex: 0)),
        (route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) =>
                        AddOrEditProductScreen(refresh: loadProductList))),
            child: const Icon(Icons.add)),
        appBar: AppBar(
            title: const Text("Mes produits"),
            leading: const BackButton(
                // onPressed: (() => Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //         builder: (builder) => const HomePage(selectedIndex: 0)),
                //     (route) => false)),
                )),
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
                        Text("Total: ${filteredProductsList.length}",
                            style: ts),
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
                      : filteredProductsList.isEmpty
                          ? const Center(
                              child: Text(
                                "Aucun produit trouvé",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                            )
                          : GridView.builder(
                              itemCount: filteredProductsList.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  customCard(filteredProductsList[index],
                                      context, loadProductList),
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
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColor.withAlpha(100),
                blurRadius: 10,
                offset: const Offset(5, 2))
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
                    : CachedNetworkImage(
                        imageUrl: e.url!,
                        fit: BoxFit.fill,
                        width: 190,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
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
