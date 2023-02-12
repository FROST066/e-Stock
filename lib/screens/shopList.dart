import 'dart:convert';

import 'package:e_stock/models/Shop.dart';
import 'package:e_stock/other/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../other/styles.dart';
import '../widgets/CustomTextFormField.dart';
import '../widgets/customFlutterToast.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;

class ShopList extends StatefulWidget {
  const ShopList({super.key});
  @override
  State<ShopList> createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  final shopNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<Shop> shopList = [];

  loadShopList() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt(PrefKeys.USER_ID);
    setState(() {
      _isLoading = true;
    });
    final url = "$BASE_URL?magasins=1&owner=$userID";
    try {
      print("---------------requesting $url");
      http.Response response = await http.get(Uri.parse(url));
      // print(response.body);
      var jsonresponse = json.decode(response.body);
      print(jsonresponse);
      // print(response.statusCode);
      try {
        shopList = (jsonresponse as List).map((e) => shopFromJson(e)).toList();
        if (shopList.length == 1) {
          prefs.setInt(PrefKeys.SHOP_ID, shopList[0].id);
          if (mounted) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (e) => const HomePage()),
                (route) => false);
          }
        }
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
    loadShopList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : shopList.isEmpty
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Créer une boutique ",
                                style: GoogleFonts.oswald(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    decoration: TextDecoration.none,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color)),
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
                          width: MediaQuery.of(context).size.width * 0.9,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            style: defaultStyle(context),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {}
                            },
                            child: const Text("Créer"),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: MediaQuery.of(context).size.width * .09,
                        ),
                        child: Text("Selectionnez une boutique ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontSize: 22)),
                      ),
                      ...shopList
                          .map((e) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                margin: const EdgeInsets.symmetric(vertical: 7),
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Theme.of(context).primaryColor),
                                child: InkWell(
                                  onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt(PrefKeys.SHOP_ID, e.id);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Text(
                                          e.shopName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ]),
                  ),
      ),
    );
  }
}
