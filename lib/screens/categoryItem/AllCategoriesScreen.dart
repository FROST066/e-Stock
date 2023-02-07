import 'package:e_stock/models/Categorie.dart';
import 'package:flutter/material.dart';
import '../../other/styles.dart';
import 'AddOrEditCategoryScreen.dart';
import 'package:search_choices/search_choices.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  List<Categorie> listCategories = [
    Categorie("0019", "Technologies", "Une description"),
    Categorie("0019", "Electromenager", "Une description"),
    Categorie("0019", "Alimentation", "Une description"),
    Categorie("0019", "Bricolage", "Une description"),
  ];
  List<Categorie> listCategoriesToDisplay = [];
  List<DropdownMenuItem> items = [];
  String? selectedValueSingleDialog;
  @override
  void initState() {
    items = listCategories
        .map((e) => DropdownMenuItem(
            value: e.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(e.name),
            )))
        .toList();
    listCategoriesToDisplay = listCategories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: Container(
                margin: const EdgeInsets.only(top: 90, bottom: 20),
                width: MediaQuery.of(context).size.width * 0.93,
                child: searchableSelect()),
          ),
          Flexible(
            flex: 7,
            child: SingleChildScrollView(
              child: Column(
                  children: listCategoriesToDisplay
                      .map((e) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            margin: const EdgeInsets.symmetric(vertical: 7),
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: appGrey),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      Text(e.description)
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddOrEditCategoryScreen(
                                                        name: e.name,
                                                        description:
                                                            e.description))),
                                        icon: const Icon(
                                          Icons.edit,
                                          color: appBlue,
                                        )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ))
                      .toList()),
            ),
          )
        ],
      ),
    );
  }

  Widget searchableSelect() {
    return SearchChoices.single(
      items: items,
      value: selectedValueSingleDialog,
      hint: "  Rechercher une catégorie",
      searchHint: "Rechercher une catégorie",
      fieldDecoration: BoxDecoration(
        color: appGrey,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: appGrey),
      ),
      searchInputDecoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: appGrey,
          iconColor: Colors.black),
      onChanged: (value) {
        setState(() {
          selectedValueSingleDialog = value;
          if (value == null) {
            listCategoriesToDisplay = listCategories;
          } else {
            listCategoriesToDisplay = listCategories
                .where((element) => element.name == selectedValueSingleDialog)
                .toList();
          }
        });
      },
      isExpanded: true,
    );
  }
}
