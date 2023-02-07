import 'dart:io';

import 'package:e_stock/models/Shop.dart';
import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/FirstPage.dart';
import 'package:e_stock/widgets/AddOrEditShopDialogWidget.dart';
import 'package:e_stock/widgets/ChangePasswordDialogWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../other/const.dart';
import '../../other/themes.dart';
import 'AboutScreen.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

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
    bool isLight = Theme.of(context).brightness == Brightness.light;
    return Center(
        child: SizedBox(
            child: Column(children: [
      const SizedBox(height: 35),
      Flexible(
        flex: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 30),
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .25,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).primaryColor,
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
                    child: GestureDetector(
                        onTap: () => getFile(),
                        child: const Icon(Icons.add_a_photo_rounded, size: 30)))
              ],
            ),
            const Text("User Name"),
          ],
        ),
      ),
      Flexible(
          flex: 5,
          child: DefaultTabController(
            length: 2,
            child: ThemeSwitchingArea(
              child: Scaffold(
                appBar: TabBar(
                  labelPadding: const EdgeInsets.symmetric(vertical: 12),
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.business,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text("Mes boutiques",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontWeight: FontWeight.bold))
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.settings,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text("Parametres",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontWeight: FontWeight.bold))
                        ]),
                  ],

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
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : appGrey),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                            showCustomDialogForSHop(
                                                                e.id),
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: e.isActive
                                                              ? Colors.white
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor,
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
                            child: SizedBox(
                              width: 100,
                              // margin: const EdgeInsets.only(bottom: 10),
                              child: ElevatedButton(
                                style: defaultStyle(context),
                                onPressed: () => showCustomDialogForSHop(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add),
                                    Text("Créer",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ), //for Settings
                    Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ThemeSwitcher.withTheme(
                              builder: (_, switcher, theme) {
                                return ToggleSwitch(
                                    radiusStyle: true,
                                    minWidth: 90.0,
                                    changeOnTap: true,
                                    minHeight: 40.0,
                                    initialLabelIndex: isLight ? 0 : 1,
                                    cornerRadius: 20.0,
                                    inactiveBgColor:
                                        isLight ? appGrey : appDarkGrey,
                                    activeFgColor: isLight
                                        ? Colors.black.withOpacity(0.85)
                                        : Colors.white,
                                    inactiveFgColor:
                                        isLight ? Colors.white : Colors.black,
                                    totalSwitches: 2,
                                    icons: const [
                                      Icons.lightbulb,
                                      Icons.nights_stay_outlined
                                    ],
                                    labels: const ['Light', 'Dark'],
                                    iconSize: 30.0,
                                    activeBgColors: [
                                      const [Colors.white],
                                      [Colors.black.withOpacity(0.85)]
                                    ],
                                    animate: true,
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    onToggle: (index) => switcher.changeTheme(
                                          theme: index == 1
                                              ? darkTheme
                                              : lightTheme,
                                        ));
                              },
                            ),
                          ),
                          settingItem(Icons.edit, "Modifier mon mot de passe",
                              () => showCustomDialogForChangePassword()),
                          settingItem(
                              Icons.info_outline,
                              "A propos",
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => AboutScreen()))),
                          settingItem(Icons.logout, "Déconnexion", () {
                            //traitement
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => const FirstPage()),
                                (route) => false);
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ))
    ])));
  }

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      setState(() {
        imageFile = File(result.paths[0]!);
      });
    }
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

  void showCustomDialogForSHop([String? shopId]) {
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

  Widget settingItem(IconData iconData, String text, void Function() func) {
    return InkWell(
      onTap: () => func(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(iconData, color: Theme.of(context).primaryColor, size: 30),
            SizedBox(width: MediaQuery.of(context).size.width * .09),
            Text(text,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  void showCustomDialogForChangePassword() {
    showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return ChangePasswordDialogWidget(ctx: ctx);
        },
        animationType: DialogTransitionType.slideFromBottom,
        // animationType: DialogTransitionType.scale,
        // curve: Curves.linear,
        duration: const Duration(seconds: 1));
  }
}
