import 'package:e_stock/widgets/CustomTable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../models/produit.dart';
import '../other/styles.dart';

Widget productDialogWidget(BuildContext ctx, Produit e) {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(ctx).scaffoldBackgroundColor,
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
                      e.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          color: Theme.of(ctx).textTheme.bodyText2!.color),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Catégorie: ${e.idCategorie}",
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
          Padding(
            padding: const EdgeInsets.only(
              right: 8,
              bottom: 10,
              left: 8,
            ),
            child: Text(
              e.description,
              style: GoogleFonts.quicksand(
                  fontSize: 15,
                  decoration: TextDecoration.none,
                  color: Theme.of(ctx).textTheme.bodyText2!.color),
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
            ["Prix d'achat", e.priceA.toString()],
            ["Prix de vente", e.priceV.toString()],
            ["Stock critique", e.low.toString()],
          ], ctx),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    style: productDialogBtStyle(Theme.of(ctx).primaryColor),
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
