import 'dart:convert';
import 'package:badges/badges.dart' as Badge;
import 'package:e_stock/screens/HomepageItem/AllProductsScreen.dart';
import 'package:e_stock/screens/HomepageItem/BalanceSheetScreen.dart';
import 'package:e_stock/screens/HomepageItem/HistoryScreen.dart';
import 'package:e_stock/widgets/CustomLoader.dart';
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
  bool _isLoading = false;
  Map<String, double> dataMap = {"Entrée": 0, "Sortie": 0, "En stock": 0};
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
        customFlutterToast(msg: "Erreur: ----1----${e.toString()}");
      }
    } catch (e) {
      customFlutterToast(msg: "Erreur: ----2----${e.toString()}");
    } finally {}
  }

  loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt(PrefKeys.USER_ID);
    try {
      print("---------------requesting $BASE_URL/?user=$userID");
      http.Response response =
          await http.get(Uri.parse("$BASE_URL/?user=$userID"));
      // var jsonresponse = json.decode(response.body);
      print(response.body);
      print(response.statusCode);
      // print(jsonresponse);
    } catch (e) {
      customFlutterToast(msg: "Erreur: ----1----${e.toString()}");
    }
  }

  loadDataMap() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    int? shopId = prefs.getInt(PrefKeys.SHOP_ID);
    var forData = {
      "historique": "1",
      "id": "${shopId!}",
      "dateDebut": "01-01-2022",
      "dateFin": DateTime.now().toString().substring(0, 10),
    };
    print("---------Fordata $forData");
    try {
      print("---------------requesting $BASE_URL for load data map");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: forData);
      try {
        var jsonresponse = json.decode(response.body);
        // print("${response.body}");
        // print("${response.statusCode}");
        // print(jsonresponse);
        List<double> result = [0, 0, 0];
        for (var item in jsonresponse as List) {
          var i = json.decode(item);
          result[i["type"]] += (i["nbr"]);
        }
        result[2] = result[0] - result[1];
        dataMap = {
          "Entrée": result[0],
          "Sortie": result[1],
          "En stock": result[2],
        };
      } catch (e) {
        customFlutterToast(msg: "In load data------1------${e.toString()}");
      }
    } catch (e) {
      customFlutterToast(msg: "------2------${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadDataMap();
    loadProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              flex: 2,
              child: _isLoading
                  ? customLoader(color: Theme.of(context).primaryColor)
                  : dataMap["Entrée"] == 0
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * .55,
                          child: const Center(
                            child: Text(
                              "Effectuez votre première transaction pour pouvoir consulter les statistiques",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.grey,
                                  height: 1.5),
                            ),
                          ),
                        )
                      : PieChart(
                          animationDuration: const Duration(milliseconds: 1000),
                          dataMap: dataMap,
                          colorList: const [
                            Colors.green,
                            Colors.red,
                            Colors.blue
                          ],
                          chartValuesOptions: const ChartValuesOptions(
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
                          legendOptions: const LegendOptions(
                            showLegendsInRow: true,
                            legendPosition: LegendPosition.bottom,
                            legendTextStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ))),
          Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Badge.Badge(
                    key: UniqueKey(),
                    badgeAnimation: const Badge.BadgeAnimation.slide(
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
                              builder: (builder) => const AllProductsScreen(
                                    initFilter: true,
                                  ))),
                    ),
                  ),
                  ElevatedButton(
                    style: homePageBtStyle(context),
                    child: const Text(" PRODUITS "),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const AllProductsScreen())),
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
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        const BalanceSheetScreen())),
                          }),
                ],
              )),
        ],
      ),
    );
  }
}
