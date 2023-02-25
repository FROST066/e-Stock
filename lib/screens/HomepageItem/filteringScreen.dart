import 'package:e_stock/widgets/CustomLoader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../other/styles.dart';
import '../../services/static.dart';

class FilteringDialog extends StatefulWidget {
  const FilteringDialog({super.key, required this.filter});
  final Future<void> Function(bool isLowStock, int categoryId) filter;
  @override
  State<FilteringDialog> createState() => _FilteringDialogState();
}

class _FilteringDialogState extends State<FilteringDialog> {
  int? selectedCategorie;
  bool _isFecthing = false, swithStatus = false;
  initialize() async {
    setState(() {
      _isFecthing = true;
    });
    if (StaticValues.getListCategories.isEmpty) {
      await StaticValues.loadCategoryList();
    }
    setState(() {
      _isFecthing = false;
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          height: 250,
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Filtrer les resultats",
                      style: GoogleFonts.oswald(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          decoration: TextDecoration.none,
                          color: Theme.of(context).textTheme.bodyText2!.color)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.cancel,
                      size: 35,
                      color: appGrey,
                    ),
                  )
                ],
              ),
              _isFecthing
                  ? customLoader()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 5),
                      child: DropdownButtonFormField<int>(
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            labelText: "Selectionner une categorie",
                            labelStyle: Theme.of(context)
                                .inputDecorationTheme
                                .labelStyle,
                            enabledBorder: Theme.of(context)
                                .inputDecorationTheme
                                .enabledBorder,
                            focusedBorder: Theme.of(context)
                                .inputDecorationTheme
                                .focusedBorder,
                            iconColor: Colors.black),
                        value: selectedCategorie,
                        items: StaticValues.getListCategories
                            .map((e) => DropdownMenuItem(
                                value: e.categoryId,
                                child: Text(
                                  e.name,
                                  style: const TextStyle(fontSize: 21),
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategorie = value ?? 0;
                          });
                        },
                        validator: (e) {
                          return (e == null)
                              ? "Ce champ est obligatoire"
                              : null;
                        },
                      ),
                    ),
              const Text("Produits en rupture:"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width * .2,
                  minHeight: 30,
                  // cornerRadius: 20,
                  activeBgColors: [
                    [Colors.green[800]!],
                    [Colors.red[800]!]
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: swithStatus ? 0 : 1,
                  totalSwitches: 2,
                  animate: true,
                  curve: Curves.fastLinearToSlowEaseIn,
                  labels: const ['OUI', 'NON'],
                  radiusStyle: true,
                  onToggle: (index) {
                    // 1 correspond a non et 0 a oui
                    setState(() {
                      swithStatus = index == 0;
                    });
                    print('switched to: $index');
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: defaultStyle(context),
                  onPressed: () {
                    widget.filter(swithStatus, selectedCategorie ?? 0);
                    Navigator.pop(context);
                  },
                  child: const Text("Appliquer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
