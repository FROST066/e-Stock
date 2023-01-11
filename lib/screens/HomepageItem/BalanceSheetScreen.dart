import 'package:e_stock/screens/HomepageItem/PDFpreview.dart';
import 'package:e_stock/widgets/DoubleDatePicker.dart';
import 'package:e_stock/widgets/CustomTable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../other/styles.dart';

class BalanceSheetScreen extends StatefulWidget {
  const BalanceSheetScreen({super.key});

  @override
  State<BalanceSheetScreen> createState() => _BalanceSheetScreenState();
}

class _BalanceSheetScreenState extends State<BalanceSheetScreen> {
  List<List<String>> data = [
    ["", "Unité", "PA", "PV", "BENEF"],
    ["Tomato", "", "", "", ""],
    ["Ananas", "", "", "", ""],
    ["Total", "", "", "", ""],
  ];
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
                          fileName: "Bilan_du__au__",
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
                flex: !isPortrait ? 6 : 2, child: const DoubleDatePicker()),
            Flexible(
              flex: 8,
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 20),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: appGrey),
                      child: Wrap(
                        children: <Widget>[
                          iconWithTex(
                              Icons.assignment_outlined, "Total Vendu", "200"),
                          iconWithTex(
                              CupertinoIcons.star, "Revenu", "5000 FCFA"),
                          iconWithTex(Icons.shopping_cart_checkout_sharp,
                              "Cout", "3500 FCFA"),
                          iconWithTex(CupertinoIcons.money_dollar_circle,
                              "Bénéfice", "1500 FCFA"),
                        ],
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: customTableWithArray(data),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget iconWithTex(IconData icon, String title, String value) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 18),
    width: 150,
    child: Row(
      children: [
        Icon(
          icon,
          color: appBlue,
          size: 50,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            const SizedBox(),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    ),
  );
}
