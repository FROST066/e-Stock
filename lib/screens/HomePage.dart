import 'package:e_stock/other/styles.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
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
                        legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                        onPressed: () {},
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
        ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 500),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: const [
                  GButton(
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: appBlue,
                    icon: Icons.home,
                    text: 'Acceuil',
                  ),
                  GButton(
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: appBlue,
                    icon: Icons.account_tree_outlined,
                    text: 'Catégories',
                  ),
                  GButton(
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: appBlue,
                    icon: LineIcons.coins,
                    text: 'Transactions',
                  ),
                  GButton(
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: appBlue,
                    icon: LineIcons.user,
                    text: 'Profil',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                    print(_selectedIndex);
                  });
                },
              ),
            ))));
  }
}
