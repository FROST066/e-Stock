import 'package:e_stock/widgets/CustomTable.dart';
import 'package:e_stock/widgets/ProductDialogWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:line_icons/line_icons.dart';
import '../../other/styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

TextStyle ts = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

class _AllProductsScreenState extends State<AllProductsScreen> {
  List<Map<String, String>> list = [
    {
      "name": "Tomato",
      "description": "bla bal balla bla bla bla c'est une longue descritption",
      "categorie": "Fruit",
      "low": "50",
      "priceA": "50 FCFA",
      "priceV": "2500 FCFA"
    },
    {
      "name": "Carotte",
      "description": "bla bal balla bla bla bla c'est une longue descritption",
      "categorie": "Légume",
      "low": "50",
      "priceA": "50 FCFA",
      "priceV": "2500 FCFA"
    },
    {
      "name": "Avocat",
      "description": "bla bal balla bla bla bla c'est une longue descritption",
      "categorie": "Fruit",
      "low": "50",
      "priceA": "50 FCFA",
      "priceV": "2500 FCFA"
    },
    {
      "name": "Ananas",
      "description": "bla bal balla bla bla bla c'est une longue descritption",
      "categorie": "Fruit",
      "low": "50",
      "priceA": "50 FCFA",
      "priceV": "2500 FCFA"
    },
    {
      "name": "Tomato",
      "description": "bla bal balla bla bla bla c'est une longue descritption",
      "categorie": "Fruit",
      "low": "50",
      "priceA": "50 FCFA",
      "priceV": "2500 FCFA"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produits")),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 4),
                      margin: const EdgeInsets.only(right: 8),
                      width: MediaQuery.of(context).size.width * 0.78,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: appGrey),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            hintText: "Chercher un produit",
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            iconColor: Colors.black),
                        onChanged: (value) {},
                      ),
                    ),
                    const Icon(MdiIcons.tuneVertical, size: 30)
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tous les produits", style: ts),
                      Text("Total: ${list.length}", style: ts),
                    ]),
              ),
              Expanded(
                flex: 9,
                child: GridView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    // print("index: ${index}");
                    // print("list: ${list}");
                    // print("element: ${list[index]}");
                    return customCard(list[index], context);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget customCard(Map<String, String> e, BuildContext context) {
  // print(e);
  return GestureDetector(
    onTap: () => showCustomDialog(context, e),
    child: Container(
      // margin: const EdgeInsets.symmetric(vertical: 7),
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Colors.grey, //New
              blurRadius: 20.0,
              offset: Offset(0, 12))
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(
            flex: 1,
            child: Center(
              child: Icon(
                LineIcons.adobe,
                size: 60,
                color: appBlue,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 12),
              decoration: const BoxDecoration(
                  color: appGrey,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(e["name"] ?? "Une erreur", style: ts),
                  Text(e["priceV"] ?? "Une erreur"),
                  const SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

void showCustomDialog(BuildContext context, Map<String, String> e) {
  showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) {
        return productDialogWidget(ctx, e);
      },
      animationType: DialogTransitionType.slideFromBottom,
      // animationType: DialogTransitionType.scale,
      // curve: Curves.linear,
      duration: const Duration(seconds: 1));
}
