import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:e_stock/screens/HomepageItem/AllProductsScreen.dart';
import 'package:e_stock/screens/HomepageItem/BalanceSheetScreen.dart';
import 'package:e_stock/screens/HomepageItem/HistoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/product.dart';
import '../../other/const.dart';
import '../../other/styles.dart';
import '../../widgets/customFlutterToast.dart';

class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  int lowerProductCounter = 0;
  Future<void> loadProductList() async {
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
        lowerProductCounter = (jsonresponse as List)
            .map((e) => Product.fromJson(e))
            .toList()
            .where((element) => element.quantiteDisponible < element.stockMin)
            .length;
        print("lowerProductCounter: $lowerProductCounter");
        setState(() {
          lowerProductCounter;
        });
      } catch (e) {
        //print("-----1-------${e.toString()}");
        customFlutterToast(msg: "Erreur: ----1----${e.toString()}");
      }
    } catch (e) {
      // print("------2------${e.toString()}");
      customFlutterToast(msg: "Erreur: ----2----${e.toString()}");
    } finally {}
  }

  @override
  void initState() {
    super.initState();
    loadProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Flexible(
              flex: 2,
              child: PieChart(
                  animationDuration: Duration(milliseconds: 1000),
                  dataMap: {"Entreé": 100, "Sortie": 70, "En stock": 30},
                  colorList: [Colors.green, Colors.red, Colors.blue],
                  chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValues: true,
                      // showChartValuesOutside: true,
                      decimalPlaces: 0,
                      chartValueStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  initialAngleInDegree: 90,
                  chartLegendSpacing: 20,
                  legendOptions: LegendOptions(
                    showLegendsInRow: true,
                    legendPosition: LegendPosition.bottom,
                    legendTextStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ))),
          Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Badge(
                    key: UniqueKey(),
                    badgeAnimation: const BadgeAnimation.slide(
                      animationDuration: Duration(seconds: 2),
                      loopAnimation: true,
                      curve: Curves.slowMiddle,
                    ),
                    showBadge: lowerProductCounter > 0,
                    badgeContent: Text(
                      "$lowerProductCounter",
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: ElevatedButton(
                      style: homePageBtStyle(context),
                      child: const Text("EN RUPTURE"),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) =>
                                  AllProductsScreen(initFilter: true))),
                    ),
                  ),
                  ElevatedButton(
                    style: homePageBtStyle(context),
                    child: const Text(" PRODUITS "),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => AllProductsScreen())),
                  )
                ],
              )),
          Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: homePageBtStyle(context),
                    child: const Text("HISTORIQUE"),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const HistoryScreen())),
                  ),
                  ElevatedButton(
                      style: homePageBtStyle(context),
                      child: const Text("     BILAN      "),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) =>
                                  const BalanceSheetScreen()))),
                ],
              )),
        ],
      ),
    );
  }
}
