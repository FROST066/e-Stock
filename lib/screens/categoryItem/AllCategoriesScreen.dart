import 'package:flutter/material.dart';

import '../../other/styles.dart';
import 'AddOrEditCategoryScreen.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              margin: const EdgeInsets.only(top: 60, bottom: 30),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: appGrey),
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    hintText: "Chercher une categorie",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    iconColor: Colors.black),
                onChanged: (value) {},
              ),
            ),
          ),
          Flexible(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                  children: [
                {
                  "nom": "Le nom",
                  "description":
                      "Une descrjeduhuhf ef iejfief efijeije fioefjdci efiejfoef efoijiption"
                },
                {
                  "nom": "Le nom",
                  "description":
                      "Une descrip ddnidniwdiwd wdwjd0owjdowd wdjwodjwdjndjd ecmnedimwdtion"
                }
              ]
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
                                        e["nom"]!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      Text(e["description"]!)
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
                                                        name: e["nom"]!,
                                                        description: e[
                                                            "description"]!))),
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
}
