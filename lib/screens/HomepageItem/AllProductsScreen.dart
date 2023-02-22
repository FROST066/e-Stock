import 'package:e_stock/models/product.dart';
import 'package:e_stock/screens/HomepageItem/AddOrEditProductScreen.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
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
  List<Product> list = [
    Product(
      productId: 1,
      name: "Carotte",
      description: "bla bal balla bla bla bla c'est une longue descritption",
      categoryId: 1,
      low: 20,
      sellingPrice: 250,
      purchasePrice: 500,
    ),
    Product(
      productId: 2,
      name: "Tomate",
      description: "bla bal balla bla bla bla c'est une longue descritption",
      categoryId: 1,
      low: 30,
      sellingPrice: 350,
      purchasePrice: 500,
    ),
    Product(
      productId: 2,
      name: "Carotte",
      description: "bla bal balla bla bla bla c'est une longue descritption",
      categoryId: 1,
      low: 20,
      sellingPrice: 250,
      purchasePrice: 500,
    ),
    Product(
        productId: 3,
        name: "Pomme",
        description: "bla bal balla bla bla bla c'est une longue descritption",
        categoryId: 1,
        low: 10,
        sellingPrice: 100,
        purchasePrice: 300),
  ];
  List<Product> _filteredList = [];
  @override
  void initState() {
    _filteredList.addAll(list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => AddOrEditProductScreen())),
          child: const Icon(Icons.add)),
      appBar: AppBar(title: const Text("Produits")),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      flex: 7,
                      child: CustomTextFormField(
                        hintText: "Chercher un produit",
                        prefixIcon: Icons.search,
                        onChanged: (value) {
                          setState(() {
                            _filteredList.clear();
                            if (value.isEmpty) {
                              _filteredList.addAll(list);
                            } else {
                              for (Product item in list) {
                                if (item.name
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) {
                                  _filteredList.add(item);
                                }
                              }
                            }
                          });
                        },
                      )),
                  const Icon(MdiIcons.tuneVertical, size: 30)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tous les produits", style: ts),
                      Text("Total: ${_filteredList.length}", style: ts),
                    ]),
              ),
              Expanded(
                flex: 9,
                child: GridView.builder(
                  itemCount: _filteredList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      customCard(_filteredList[index], context),
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

Widget customCard(Product e, BuildContext context) {
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
          Flexible(
            flex: 1,
            child: Center(
              child: Icon(
                LineIcons.adobe,
                size: 60,
                color: Theme.of(context).primaryColor,
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
                  Text(e.name,
                      style: ts.copyWith(
                          color: ThemeData.dark().scaffoldBackgroundColor)),
                  Text(
                    "${e.sellingPrice} FCFA",
                    style: TextStyle(
                        color: ThemeData.dark().scaffoldBackgroundColor),
                  ),
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

void showCustomDialog(BuildContext context, Product e) {
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
