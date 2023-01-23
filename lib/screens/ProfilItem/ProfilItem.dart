import 'dart:io';

import 'package:e_stock/models/Shop.dart';
import 'package:e_stock/other/styles.dart';
import 'package:e_stock/widgets/AddOrEditShopDialogWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class ProfilItem extends StatefulWidget {
  const ProfilItem({super.key});

  @override
  State<ProfilItem> createState() => _ProfilItemState();
}

class _ProfilItemState extends State<ProfilItem> {
  File? imageFile;
  List<Shop> shopList = [
    Shop("89uinr", "Quincaillerie", true),
    Shop("89inr", "Patisserie", false),
    Shop("8uinr", "Salon de coiffure", false),
  ];
  int selectedShop = 0;
  // TabController tabController = TabController(length: 2, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            child: Column(children: [
      Flexible(
        flex: 2,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 30),
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .25,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color.fromARGB(255, 171, 205, 233),
                    foregroundColor: Colors.white,
                    child: ClipOval(
                      child: imageFile != null
                          ? Image.file(
                              imageFile!,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              CupertinoIcons.person_crop_circle_fill,
                              size: 120,
                            ),
                    ),
                  ),
                ),
                Positioned(
                    // bottom: 25,
                    bottom: MediaQuery.of(context).size.height * .3 * .15,
                    right: MediaQuery.of(context).size.width * .1,
                    child: const Icon(Icons.add_a_photo_rounded, size: 30))
              ],
            ),
            const Text("User Name"),
          ],
        ),
      ),
      Expanded(
          flex: 3,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  labelPadding: const EdgeInsets.symmetric(vertical: 12),
                  indicatorColor: appBlue,
                  tabs: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.business, color: appBlue),
                          Text("Mes boutiques",
                              style: TextStyle(color: Colors.black))
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.settings, color: appBlue),
                          Text("Parametres",
                              style: TextStyle(color: Colors.black))
                        ]),
                  ],
                ),
                // title: const Text('Tabs Demo'),
              ),
              body: TabBarView(
                children: [
                  SizedBox(
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            flex: 8,
                            child: SingleChildScrollView(
                              child: Column(
                                children: shopList
                                    .map((e) => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 6),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 7),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: e.isActive
                                                  ? appBlue
                                                  : appGrey),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Text(
                                                  e.shopName,
                                                  style: TextStyle(
                                                      color: e.isActive
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () =>
                                                          showCustomDialog(
                                                              context, e.id),
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color: e.isActive
                                                            ? Colors.white
                                                            : appBlue,
                                                      )),
                                                  IconButton(
                                                      onPressed: () =>
                                                          removeFun(e.id),
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            )),
                        Flexible(
                          flex: 2,
                          child: Container(
                            width: 100,
                            // margin: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              style: defaultStyle,
                              onPressed: () => showCustomDialog(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add),
                                  Text("Créer",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ), //for Settings
                  Column(
                    children: [],
                  )
                ],
              ),
            ),
          ))
    ])));
  }

  void updateFun(String id, String newShopName) {
    shopList.firstWhere((element) => element.id == id).shopName = newShopName;
    setState(() {
      shopList;
    });
  }

  void addFun(String shopName) {
    shopList.add(Shop("$shopName+id", shopName, false));
    setState(() {
      shopList;
    });
  }

  void removeFun(String shopId) {
    shopList.removeWhere((element) => element.id == shopId);
    setState(() {
      shopList;
    });
  }

  void showCustomDialog(BuildContext context, [String? shopId]) {
    updateFunc(newShopName) => updateFun(shopId ?? "", newShopName);
    showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return AddOrEditShopDialogWidget(
            ctx: ctx,
            shopName: shopId != null
                ? shopList
                    .firstWhere((element) => element.id == shopId)
                    .shopName
                : null,
            updateFun: updateFunc,
            addFun: addFun,
          );
        },
        animationType: DialogTransitionType.slideFromBottom,
        // animationType: DialogTransitionType.scale,
        // curve: Curves.linear,
        duration: const Duration(seconds: 1));
  }
}
