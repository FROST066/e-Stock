import 'dart:io';

import 'package:e_stock/other/themes.dart';
import 'package:e_stock/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../../models/Categorie.dart';
import '../../other/styles.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({super.key, required this.ctx});
  BuildContext ctx;
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TextEditingController quantityController = TextEditingController();
  List<Categorie> listCategories = [
    Categorie("0019", "Technologies", "Une description"),
    Categorie("0019", "Electromenager", "Une description"),
    Categorie("0019", "Alimentation", "Une description"),
    Categorie("0019", "Bricolage", "Une description"),
  ];
  List<DropdownMenuItem> items = [];
  String? selectedValueSingleDialog;
  @override
  void initState() {
    items = listCategories
        .map((e) => DropdownMenuItem(
            value: e.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(e.name),
            )))
        .toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool keyBordOpen =
        !Platform.isLinux && MediaQuery.of(widget.ctx).viewInsets.bottom != 0;
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Center(
          child: SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 90, bottom: 10),
                child: SearchChoices.single(
                  items: items,
                  value: selectedValueSingleDialog,
                  hint: "  Selectionner un produit",
                  searchHint: "Selectionner un produit",
                  fieldDecoration: BoxDecoration(
                    color: appGrey,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: appGrey),
                  ),
                  searchInputDecoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 2),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: appGrey,
                      iconColor: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      selectedValueSingleDialog = value;
                    });
                  },
                  isExpanded: true,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("    Type de transaction"),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, top: 10, bottom: 30),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  hintText: "Quantité",
                  controller: quantityController,
                  // textInputType: TextInputType.number,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: 20, top: isKeyboardVisible ? 30 : 250),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: ElevatedButton(
                        style: defaultStyle,
                        onPressed: () => showMissing(),
                        child: const Text("Valider"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    });
  }

  showMissing() {}
}
