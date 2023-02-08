import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../models/Categorie.dart';
import '../../models/produit.dart';
import '../../other/styles.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Produit> listProduits = [
    Produit(
        "1",
        "Tomato",
        "bla bal balla bla bla bla c'est une longue descritption",
        "1",
        50,
        50,
        50),
    Produit(
        "2",
        "Carotte",
        "bla bal balla bla bla bla c'est une longue descritption",
        "1",
        20,
        250,
        5000),
    Produit(
        "3",
        "Avocat",
        "bla bal balla bla bla bla c'est une longue descritption",
        "3",
        10,
        100,
        150),
    Produit(
        "4",
        "Ananas",
        "bla bal balla bla bla bla c'est une longue descritption",
        "3",
        50,
        50,
        2500),
    Produit(
        "5",
        "Tomato",
        "bla bal balla bla bla bla c'est une longue descritption",
        "2",
        30,
        40,
        100),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(top: 60, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("    Type de transaction"),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: ToggleSwitch(
                        minWidth: MediaQuery.of(context).size.width * .4,
                        minHeight: 50,
                        // cornerRadius: 20,
                        activeBgColors: [
                          [Colors.green[800]!],
                          [Colors.red[800]!]
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: 1,
                        totalSwitches: 2,
                        animate: true,
                        curve: Curves.fastLinearToSlowEaseIn,
                        labels: const ['ENTREE', 'SORTIE'],
                        radiusStyle: true,
                        onToggle: (index) {
                          print('switched to: $index');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 5,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    TransactionItem(listProduits: listProduits),
                    TransactionItem(listProduits: listProduits),
                    TransactionItem(listProduits: listProduits),
                    TransactionItem(listProduits: listProduits),
                  ],
                ))),
            Center(
              heightFactor: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(
                    // bottom: 20, top: !isKeyboardVisible ? 30 : 250),
                    bottom: 20,
                    top: 30),
                child: ElevatedButton(
                  style: defaultStyle(context),
                  onPressed: () {},
                  child: const Text("Valider"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionItem extends StatefulWidget {
  const TransactionItem({super.key, required this.listProduits});
  final List<Produit> listProduits;
  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  String? selectedValue;
  TextEditingController quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 6,
            child: SearchChoices.single(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              items: widget.listProduits
                  .map((e) => DropdownMenuItem(
                      value: e.name,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(e.name),
                      )))
                  .toList(),
              value: selectedValue,
              hint: "  Produit",
              searchHint: "Selectionner un produit",
              fieldDecoration: BoxDecoration(
                color: appGrey,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: appGrey),
              ),
              searchInputDecoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 2)
                          .copyWith(right: 0),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: appDarkGrey,
                  iconColor: Colors.black),
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
              isExpanded: true,
            ),
          ),
          const Flexible(flex: 1, child: SizedBox()),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CustomTextFormField(
                hintText: "Quantité",
                controller: quantityController,
                // textInputType: TextInputType.number,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
