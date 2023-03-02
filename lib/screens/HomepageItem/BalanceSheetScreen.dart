import 'dart:convert';
import 'package:e_stock/widgets/CustomLoader.dart';
import 'package:http/http.dart' as http;

import 'package:e_stock/screens/HomepageItem/PDFpreview.dart';
import 'package:e_stock/widgets/DoubleDatePicker.dart';
import 'package:e_stock/widgets/CustomTable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/HistoryItem.dart';
import '../../other/const.dart';
import '../../widgets/customFlutterToast.dart';

class BalanceSheetScreen extends StatefulWidget {
  const BalanceSheetScreen({super.key});

  @override
  State<BalanceSheetScreen> createState() => _BalanceSheetScreenState();
}

class _BalanceSheetScreenState extends State<BalanceSheetScreen> {
  bool _isLoadingSheet = false, _isLoadingHistory = false;
  // List<List<String>> data = [
  //   [
  //     "",
  //     "Nombre \napprovisionné",
  //     "Nombre \n vendu",
  //     "Prix de vente ",
  //     "BENEF"
  //   ],
  //   ["Tomato", "", "", "", ""],
  //   ["Ananas", "", "", "", ""],
  //   ["Total", "", "", "", ""],
  // ];
  List<List<String>> data = [];
  Map<String, dynamic> sheetResult = {}, historyResult = {};
  final TextEditingController _dateFromController =
      TextEditingController(text: "2023-01-01");
  final TextEditingController _dateToController =
      TextEditingController(text: "${DateTime.now()}");
  loadHistory() async {
    setState(() {
      _isLoadingHistory = true;
    });
    final prefs = await SharedPreferences.getInstance();
    int? shopId = prefs.getInt(PrefKeys.SHOP_ID);
    var forData = {
      "historique": "1",
      "id": "${shopId!}",
      "dateDebut": _dateFromController.text.substring(0, 10),
      "dateFin": _dateToController.text.substring(0, 10),
    };
    try {
      print("---------------requesting $BASE_URL for load history");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: forData);
      try {
        var jsonresponse = json.decode(response.body);
        // print("${response.body}");
        // print("${response.statusCode}");
        // print(jsonresponse);
        List<HistoryItem> historyItems =
            (jsonresponse as List).map((e) => historyItemFromJson(e)).toList();

        // Calculer les totaux par produit
        Map<String, dynamic> summary = {};
        for (HistoryItem historyItem in historyItems) {
          String productName = historyItem.product.name;
          if (!summary.containsKey(productName)) {
            summary[productName] = {
              'Nombre \napprovisionné': 0,
              'Nombre \n vendu': 0,
              'Prix de vente': historyItem.product.sellingPrice,
              'BENEF': 0
            };
          }
          summary[productName]['Nombre \napprovisionné'] +=
              (historyItem.type == 0 ? historyItem.nbr : 0);
          summary[productName]['Nombre \n vendu'] +=
              (historyItem.type == 1 ? historyItem.nbr : 0);
          summary[productName]['BENEF'] += (historyItem.type == 1
              ? (historyItem.nbr * historyItem.product.sellingPrice)
              : -(historyItem.nbr * historyItem.prixApprovisionement!));
        }

        data.add(
          [
            "",
            "Nombre \napprovisionné",
            "Nombre \n vendu",
            "Prix de vente ",
            "BENEF"
          ],
        );
        summary.forEach((key, value) {
          data.add([
            key,
            value['Nombre \napprovisionné'].toString(),
            value['Nombre \n vendu'].toString(),
            value['Prix de vente'].toString(),
            value['BENEF'].toString()
          ]);
        });
        num tta = 0, ttv = 0, ttb = 0;
        summary.forEach((key, value) {
          tta += value['Nombre \napprovisionné'];
          ttv += value['Nombre \n vendu'];
          ttb += value['BENEF'];
        });
        data.add(["Total", tta.toString(), ttv.toString(), "", ttb.toString()]);
      } catch (e) {
        print("------1------${e.toString()}");
        customFlutterToast(msg: "Erreur: ${e.toString()}");
      }
    } catch (e) {
      print("------2------${e.toString()}");
      customFlutterToast(msg: "Erreur: ${e.toString()}");
    } finally {
      setState(() {
        _isLoadingHistory = false;
      });
    }
  }

  loadBalanceSheet() async {
    setState(() {
      _isLoadingSheet = true;
    });
    final prefs = await SharedPreferences.getInstance();
    int? shopId = prefs.getInt(PrefKeys.SHOP_ID);
    var forData = {
      "bilan": "1",
      "magasin": "${shopId!}",
      "dateDebut": _dateFromController.text.substring(0, 10),
      "dateFin": _dateToController.text.substring(0, 10),
    };
    print("----------formData: $forData");
    try {
      print("---------------requesting $BASE_URL for load balance sheet");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: forData);
      try {
        var jsonresponse = json.decode(response.body);
        // print("${response.body}");
        // print("${response.statusCode}");
        // print(jsonresponse);
        sheetResult = jsonresponse;
      } catch (e) {
        print("------1------${e.toString()}");
        customFlutterToast(msg: "Erreur: ${e.toString()}");
      }
    } catch (e) {
      print("------2------${e.toString()}");
      customFlutterToast(msg: "Erreur: ${e.toString()}");
    } finally {
      setState(() {
        _isLoadingSheet = false;
      });
    }
  }

  @override
  void initState() {
    loadHistory();
    loadBalanceSheet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bilan"),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => pdfScreen(
                          data: data,
                          fileName:
                              "Bilan_du_${_dateFromController.text.substring(0, 10)}_au_${_dateToController.text.substring(0, 10)}",
                        ))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/pdf.png"),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
                flex: !isPortrait ? 6 : 2,
                child: DoubleDatePicker(
                  onChanged: (value) {
                    loadBalanceSheet();
                    loadHistory();
                  },
                  dateDebutController: _dateFromController,
                  dateFinController: _dateToController,
                )),
            Flexible(
              flex: 8,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: _isLoadingSheet && _isLoadingHistory
                      ? MediaQuery.of(context).size.height * 0.5
                      : MediaQuery.of(context).size.height * 0.9,
                  child: Column(children: [
                    _isLoadingSheet
                        ? Flexible(child: customLoader())
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 4),
                            margin: const EdgeInsets.only(bottom: 20),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[400]),
                            child: GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.9,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              padding: const EdgeInsets.all(10),
                              shrinkWrap: true,
                              children: [
                                iconWithTex(
                                    Icons.assignment_outlined,
                                    "Total Vendu",
                                    "${sheetResult["total"] ?? 0}"),
                                iconWithTex(CupertinoIcons.star, "Revenu",
                                    "${sheetResult["revenu"] ?? 0} FCFA"),
                                iconWithTex(Icons.shopping_cart_checkout_sharp,
                                    "Cout", "${sheetResult["cout"] ?? 0} FCFA"),
                                iconWithTex(
                                    CupertinoIcons.money_dollar_circle,
                                    "Bénéfice",
                                    "${sheetResult["benefice"] ?? 0} FCFA"),
                              ],
                            )),
                    _isLoadingHistory
                        ? Flexible(child: customLoader())
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: customTableWithArray(data, context),
                          )
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iconWithTex(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      // width: 150,
      child: Row(
        children: [
          Flexible(
            flex: 4,
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 50),
          ),
          Flexible(
            flex: 8,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: ThemeData.dark().scaffoldBackgroundColor),
                  ),
                ),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ThemeData.dark().scaffoldBackgroundColor),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
