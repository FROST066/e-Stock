import 'package:e_stock/widgets/CustomTable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../other/styles.dart';

Widget historyDialogWidget(BuildContext ctx, Map<String, String> e) {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      height: 300,
      width: MediaQuery.of(ctx).size.width * 0.8,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Text("Détails de la transaction",
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
                      e["name"]!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Catégorie: ${e['categorie']!}",
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
          customTableWithArray([
            ["Heure", e["hour"]!],
            ["Date", e["date"]!],
            ["Nombre d'article", e["nbre"]!],
            ["Prix unitaire", e["price"]!],
            ["Total", e["total"]!],
          ])
        ],
      ),
    ),
  );
}
