import 'package:e_stock/other/styles.dart';
import 'package:e_stock/screens/HomepageItem/OverviewScreen.dart';
import 'package:e_stock/screens/ProfilItem/ProfilItem.dart';
import 'package:e_stock/screens/TransactionsItem/TransactionScreen.dart';
import 'package:e_stock/screens/categoryItem/AddOrEditCategoryScreen.dart';
import 'package:e_stock/screens/categoryItem/AllCategoriesScreen.dart';
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
  List<Widget> listPages = const [
    OverViewScreen(),
    AllCategoriesScreen(),
    TransactionScreen(),
    ProfilItem()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _selectedIndex != 1
            ? null
            : FloatingActionButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddOrEditCategoryScreen())),
                backgroundColor: appBlue,
                child: const Icon(Icons.add),
              ),
        body: listPages[_selectedIndex],
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
