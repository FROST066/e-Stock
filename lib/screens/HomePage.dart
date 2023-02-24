import 'package:e_stock/screens/HomepageItem/OverviewScreen.dart';
import 'package:e_stock/screens/ProfilItem/ProfilItem.dart';
import 'package:e_stock/screens/TransactionsItem/TransactionScreen.dart';
import 'package:e_stock/screens/categoryItem/AddOrEditCategoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'categoryItem/AllCategoriesScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.selectedIndex});
  final int? selectedIndex;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  List<Widget> listPages = [
    const OverViewScreen(),
    const AllCategoriesScreen(),
    TransactionScreen(),
    const ProfilItem()
  ];
  @override
  void initState() {
    _selectedIndex = widget.selectedIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _selectedIndex != 1
            ? null
            : FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddOrEditCategoryScreen(category: null)));
                },
                child: const Icon(Icons.add),
              ),
        body: listPages[_selectedIndex],
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
              ],
            ),
            child: SafeArea(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                // rippleColor: Colors.grey[300]!,
                // hoverColor: Colors.grey[100]!,
                textStyle:
                    TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 500),
                color: Theme.of(context).textTheme.bodyText2!.color,
                tabs: [
                  GButton(
                    iconActiveColor: Theme.of(context).scaffoldBackgroundColor,
                    icon: Icons.home,
                    backgroundColor: Theme.of(context).primaryColor,
                    text: 'Acceuil',
                  ),
                  GButton(
                    iconActiveColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: Theme.of(context).primaryColor,
                    icon: Icons.account_tree_outlined,
                    text: 'Catégories',
                  ),
                  GButton(
                    iconActiveColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: Theme.of(context).primaryColor,
                    icon: LineIcons.coins,
                    text: 'Transactions',
                  ),
                  GButton(
                    iconActiveColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: Theme.of(context).primaryColor,
                    icon: LineIcons.user,
                    text: 'Profil',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ))));
  }
}
