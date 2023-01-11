import 'package:e_stock/widgets/CustomTable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../other/styles.dart';

Widget productDialogWidget(BuildContext ctx, Map<String, String> e) {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      height: 400,
      width: MediaQuery.of(ctx).size.width * 0.8,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Text("Détails sur le produit",
                  style: GoogleFonts.oswald(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      decoration: TextDecoration.none,
                      color: Colors.black)),
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: const Icon(
                  Icons.cancel,
                  size: 35,
                  color: appGrey,
                ),
              )
            ],
          ),
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                foregroundColor: appBlue,
                child: ClipOval(
                  child: Icon(
                    LineIcons.tags,
                    size: 70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e["name"] ?? "Erreur",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Catégorie: ${e['categorie'] ?? "Erreur"}",
                      style: GoogleFonts.quicksand(
                          fontSize: 13,
                          decoration: TextDecoration.none,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 8,
              bottom: 10,
              left: 8,
            ),
            child: Text(
              e['description'] ?? "Erreur",
              style: GoogleFonts.quicksand(
                  fontSize: 15,
                  decoration: TextDecoration.none,
                  color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    style: productDialogBtStyle(Colors.green),
                    onPressed: () {},
                    child: const Text("Acheter")),
                TextButton(
                    style: productDialogBtStyle(Colors.red),
                    onPressed: () {},
                    child: const Text("Vendre"))
              ],
            ),
          ),
          customTableWithArray([
            ["Prix d'achat", e["priceA"] ?? "Erreur"],
            ["Prix de vente", e["priceV"] ?? "Erreur"],
            ["Stock critique", e["low"] ?? "Erreur"],
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    style: productDialogBtStyle(Colors.blue),
                    onPressed: () {},
                    child: const Text("Modifier")),
                TextButton(
                    style: productDialogBtStyle(Colors.red),
                    onPressed: () {},
                    child: const Text("Supprimer"))
              ],
            ),
          ),
        ],
      ),
    ),
  );
}