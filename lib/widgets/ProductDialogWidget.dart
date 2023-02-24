import 'dart:convert';

import 'package:e_stock/screens/HomepageItem/AddOrEditProductScreen.dart';
import 'package:e_stock/screens/TransactionsItem/TransactionScreen.dart';
import 'package:e_stock/widgets/CustomTable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../models/product.dart';
import '../other/const.dart';
import '../other/styles.dart';
import 'package:http/http.dart' as http;

import 'CustomLoader.dart';
import 'customFlutterToast.dart';

class ProductDialogWidget extends StatefulWidget {
  const ProductDialogWidget(
      {super.key, required this.ctx, required this.e, required this.refresh});
  final BuildContext ctx;
  final Product e;
  final Future<void> Function() refresh;
  @override
  State<ProductDialogWidget> createState() => _ProductDialogWidgetState();
}

class _ProductDialogWidgetState extends State<ProductDialogWidget> {
  bool _isRemoving = false;

  removeProduct() async {
    setState(() {
      _isRemoving = true;
    });
    final formData = {
      "idProduct": widget.e.productID.toString(),
      "delete": "1"
    };
    try {
      print("---------------requesting $BASE_URL remove product ");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: formData);
      var jsonresponse = json.decode(response.body);
      print("${response.body}");
      print("${response.statusCode}");
      print(jsonresponse);
      if (mounted && jsonresponse["status"]) {
        widget.refresh();
        Navigator.pop(context);
      }
    } catch (e) {
      print("------1------${e.toString()}");
      customFlutterToast(msg: "Erreur: ${e.toString()}");
    } finally {
      setState(() {
        _isRemoving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(widget.ctx).scaffoldBackgroundColor),
        height: 400,
        width: MediaQuery.of(widget.ctx).size.width * 0.8,
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
                        color:
                            Theme.of(widget.ctx).textTheme.bodyText2!.color)),
                GestureDetector(
                  onTap: () => Navigator.pop(widget.ctx),
                  child: const Icon(Icons.cancel, size: 35, color: appGrey),
                )
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(widget.ctx).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(widget.ctx).primaryColor,
                  child: ClipOval(
                    child: widget.e.url != null && widget.e.url != ""
                        ? Image.network(widget.e.url!, fit: BoxFit.cover)
                        : const Icon(LineIcons.tags, size: 70),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 8),
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.e.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            decoration: TextDecoration.none,
                            color: Theme.of(widget.ctx)
                                .textTheme
                                .bodyText2!
                                .color),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Catégorie: ${widget.e.categoryID}",
                        style: GoogleFonts.quicksand(
                            fontSize: 13,
                            decoration: TextDecoration.none,
                            color: Theme.of(widget.ctx)
                                .textTheme
                                .bodyText2!
                                .color),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 10, left: 8),
              child: Text(
                widget.e.description,
                style: GoogleFonts.quicksand(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Theme.of(widget.ctx).textTheme.bodyText2!.color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      style: productDialogBtStyle(Colors.green),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => Scaffold(
                                  appBar: AppBar(),
                                  body: TransactionScreen(
                                      type: 0, e: widget.e)))),
                      child: const Text("Acheter")),
                  TextButton(
                      style: productDialogBtStyle(Colors.red),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => Scaffold(
                                  appBar: AppBar(),
                                  body: TransactionScreen(
                                      type: 1, e: widget.e)))),
                      child: const Text("Vendre"))
                ],
              ),
            ),
            customTableWithArray([
              ["Quantite disponible", widget.e.quantiteDisponible.toString()],
              ["Prix de vente", widget.e.sellingPrice.toString()],
              ["Stock critique", widget.e.stockMin.toString()],
            ], widget.ctx),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      style: productDialogBtStyle(
                          Theme.of(widget.ctx).primaryColor),
                      onPressed: () => Navigator.pushReplacement(
                          widget.ctx,
                          MaterialPageRoute(
                              builder: (builder) => AddOrEditProductScreen(
                                    product: widget.e,
                                    refresh: widget.refresh,
                                  ))),
                      child: const Text("Modifier")),
                  TextButton(
                      style: productDialogBtStyle(Colors.red),
                      onPressed: () async {
                        await removeProduct();
                      },
                      child: _isRemoving
                          ? customLoader()
                          : const Text("Supprimer"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
