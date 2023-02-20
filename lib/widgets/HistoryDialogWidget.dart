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
        color: Theme.of(ctx).scaffoldBackgroundColor,
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
                      color: Theme.of(ctx).textTheme.bodyText2!.color)),
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
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(ctx).primaryColor,
                child: const ClipOval(
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          color: Theme.of(ctx).textTheme.bodyText2!.color),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Catégorie: ${e['Category']!}",
                      style: GoogleFonts.quicksand(
                          fontSize: 13,
                          decoration: TextDecoration.none,
                          color: Theme.of(ctx).textTheme.bodyText2!.color),
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
          ], ctx)
        ],
      ),
    ),
  );
}
