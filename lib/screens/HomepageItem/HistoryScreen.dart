import 'package:date_time_picker/date_time_picker.dart';
import 'package:e_stock/widgets/DoubleDatePicker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import '../../other/styles.dart';
import '../../widgets/HistoryDialogWidget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique des transaction"),
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
                flex: !isPortrait ? 6 : 2, child: const DoubleDatePicker()),
            Flexible(
              flex: 8,
              child: SingleChildScrollView(
                child: Column(
                    children: [
                  {
                    "name": "Tomato",
                    "categorie": "Fruit",
                    "type": "V",
                    "hour": "10:34",
                    "date": "31-12-2022",
                    "nbre": "50",
                    "price": "50 FCFA",
                    "total": "2500 FCFA"
                  },
                  {
                    "name": "Ananas",
                    "categorie": "Fruit",
                    "type": "A",
                    "hour": "10:34",
                    "date": "31-12-2022",
                    "nbre": "50",
                    "price": "50 FCFA",
                    "total": "2500 FCFA"
                  },
                  {
                    "name": "Tomato",
                    "categorie": "Fruit",
                    "type": "V",
                    "hour": "10:34",
                    "date": "31-12-2022",
                    "nbre": "50",
                    "price": "50 FCFA",
                    "total": "2500 FCFA"
                  },
                ]
                        .map((e) => InkWell(
                              onTap: () => showCustomDialog(context, e),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                margin: const EdgeInsets.symmetric(vertical: 7),
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: appGrey),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          (e["type"] == "A")
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
                                              Text(e["nbre"]!,
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
                                                            15),
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                child: Text(e["date"]!,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 11)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
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
                                              e["name"]!,
                                              style: TextStyle(
                                                  color: ThemeData.dark()
                                                      .scaffoldBackgroundColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              (e["type"]! == "A")
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

void showCustomDialog(BuildContext context, Map<String, String> e) {
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
