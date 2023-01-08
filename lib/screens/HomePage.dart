import 'package:e_stock/other/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, double> dataMap = {
    "Entreé": 100,
    "Sortie": 70,
    "En stock": 30,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Flexible(
                  flex: 3,
                  child: PieChart(
                      animationDuration: Duration(milliseconds: 1000),
                      dataMap: {"Entreé": 100, "Sortie": 70, "En stock": 30},
                      colorList: [Colors.green, Colors.red, Colors.blue],
                      legendOptions: LegendOptions(
                        showLegendsInRow: true,
                        legendPosition: LegendPosition.bottom,
                      ))),
              Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: homePageBtStyle,
                        child: Text("EN RUPTURE"),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                        style: homePageBtStyle,
                        child: Text(" PRODUITS "),
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
                        child: Text("HISTORIQUE"),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                        style: homePageBtStyle,
                        child: Text("     BILAN      "),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: [
                  GButton(
                    backgroundColor: appBlue,
                    icon: Icons.home,
                    text: 'Acceuil',
                  ),
                  GButton(
                    backgroundColor: appBlue,
                    icon: Icons.account_tree_outlined,
                    text: 'Catégories',
                  ),
                  GButton(
                    backgroundColor: appBlue,
                    icon: LineIcons.coins,
                    text: 'Transactions',
                  ),
                  GButton(
                    backgroundColor: appBlue,
                    icon: LineIcons.user,
                    text: 'Profil',
                  ),
                ],
                selectedIndex: 0,
                onTabChange: (index) {
                  setState(() {
                    // _selectedIndex = index;
                  });
                },
              ),
            ))));
  }
}
