import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_stock/models/HistoryItem.dart';
import 'package:e_stock/widgets/CustomTable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

Widget historyDialogWidget(BuildContext ctx, HistoryItem e) {
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
                child: Icon(Icons.cancel,
                    size: 35, color: Theme.of(ctx).scaffoldBackgroundColor),
              )
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
                foregroundColor: Theme.of(ctx).primaryColor,
                child: ClipOval(
                  child: e.product.url != null && e.product.url != ""
                      ? CachedNetworkImage(
                          imageUrl: e.product.url!,
                          fit: BoxFit.fill,
                          width: 80,
                          height: 80,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : const Icon(LineIcons.tags, size: 70),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.product.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          color: Theme.of(ctx).textTheme.bodyText2!.color),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Catégorie: ${e.categoryName}",
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
            ["Heure", e.heure],
            ["Date", e.date],
            ["Nombre d'article", "${e.nbr}"],
            [
              "Prix unitaire",
              "${e.prixApprovisionement ?? e.product.sellingPrice}"
            ],
            [
              "Total",
              "${(e.prixApprovisionement ?? e.product.sellingPrice) * e.nbr}"
            ],
          ], ctx)
        ],
      ),
    ),
  );
}
