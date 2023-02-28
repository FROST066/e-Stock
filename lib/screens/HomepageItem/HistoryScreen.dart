import 'dart:convert';

import 'package:e_stock/widgets/CustomLoader.dart';
import 'package:e_stock/widgets/DoubleDatePicker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/HistoryItem.dart';
import '../../other/const.dart';
import '../../widgets/HistoryDialogWidget.dart';
import '../../widgets/customFlutterToast.dart';
import 'package:http/http.dart' as http;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = false;
  List<HistoryItem> _historyItems = [];

  loadHistory() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    int? shopId = prefs.getInt(PrefKeys.SHOP_ID);
    var forData = {"historique": "1", "id": "${shopId!}"};
    try {
      print("---------------requesting $BASE_URL for load history");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: forData);
      try {
        var jsonresponse = json.decode(response.body);
        // print("${response.body}");
        // print("${response.statusCode}");
        print(jsonresponse);

        _historyItems =
            (jsonresponse as List).map((e) => historyItemFromJson(e)).toList();
        // print("---------------response $_historyItems");
      } catch (e) {
        print("------1------${e.toString()}");
        customFlutterToast(msg: "Erreur: ${e.toString()}");
      }
    } catch (e) {
      print("------2------${e.toString()}");
      customFlutterToast(msg: "Erreur: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    loadHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historique des transaction")),
      body: Center(
        child: Column(
          children: [
            const DoubleDatePicker(),
            Flexible(
              flex: 8,
              child: SingleChildScrollView(
                child: _isLoading
                    ? customLoader()
                    : Column(
                        children: _historyItems
                            .map((e) => InkWell(
                                  onTap: () => showCustomDialog(context, e),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey[400]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          e.type == 0
                                              ? "assets/images/transactionA.png"
                                              : "assets/images/transactionV.png",
                                          height: 50,
                                          width: 70,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Column(
                                            children: [
                                              Text("${e.nbr}",
                                                  style: TextStyle(
                                                      color: ThemeData.dark()
                                                          .scaffoldBackgroundColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17)),
                                              const SizedBox(height: 5),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 1),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Text(e.date,
                                                    style: TextStyle(
                                                        color: ThemeData.dark()
                                                            .scaffoldBackgroundColor,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15)),
                                              )
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  e.product.name,
                                                  style: TextStyle(
                                                      color: ThemeData.dark()
                                                          .scaffoldBackgroundColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  e.type == 0
                                                      ? "TYPE: Achat"
                                                      : "TYPE: Vente",
                                                  style: GoogleFonts.aBeeZee(
                                                    fontSize: 11,
                                                    color: ThemeData.dark()
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList()),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context, HistoryItem e) {
  showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) {
        return historyDialogWidget(ctx, e);
      },
      animationType: DialogTransitionType.slideFromBottom,
      // animationType: DialogTransitionType.scale,
      // curve: Curves.linear,
      duration: const Duration(seconds: 1));
}
