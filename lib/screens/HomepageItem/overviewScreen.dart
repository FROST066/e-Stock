import 'package:e_stock/screens/HomepageItem/HistoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../other/styles.dart';

class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
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
                  ElevatedButton(
                    style: homePageBtStyle,
                    child: const Text("EN RUPTURE"),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    style: homePageBtStyle,
                    child: const Text(" PRODUITS "),
                    onPressed: () {},
                  )
                ],
              )),
          Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: homePageBtStyle,
                    child: const Text("HISTORIQUE"),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const HistoryScreen())),
                  ),
                  ElevatedButton(
                    style: homePageBtStyle,
                    child: const Text("     BILAN      "),
                    onPressed: () {},
                  )
                ],
              )),
        ],
      ),
    );
  }
}
