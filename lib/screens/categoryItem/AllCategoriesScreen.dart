import 'dart:convert';
import 'package:e_stock/models/Category.dart';
import 'package:e_stock/widgets/CustomLoader.dart';
import 'package:flutter/material.dart';
import '../../other/const.dart';
import '../../other/styles.dart';
import '../../services/static.dart';
import '../../widgets/CustomTextFormField.dart';
import '../../widgets/customFlutterToast.dart';
import 'AddOrEditCategoryScreen.dart';
import 'package:http/http.dart' as http;

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  // List<Category> listCategories = [
  //   Category(categoryId: 1, name: 'Technologies', description: 'Une description')];
  List<Category> listCategories = [];
  List<Category> listCategorysToDisplay = [];
  bool _isLoading = false;

  initialize() async {
    setState(() {
      _isLoading = true;
    });
    await StaticValues.loadCategoryList();
    listCategories.addAll(StaticValues.getListCategories);
    listCategorysToDisplay.addAll(StaticValues.getListCategories);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? customLoader(color: Theme.of(context).primaryColor)
          : Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 90, bottom: 5),
                    width: MediaQuery.of(context).size.width * 0.93,
                    child: CustomTextFormField(
                      hintText: "Chercher une categorie",
                      prefixIcon: Icons.search,
                      onChanged: (value) {
                        setState(() {
                          listCategorysToDisplay.clear();
                          if (value.isEmpty) {
                            listCategorysToDisplay.addAll(listCategories);
                          } else {
                            for (Category item in listCategories) {
                              if (item.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                                listCategorysToDisplay.add(item);
                              }
                            }
                          }
                        });
                      },
                    )),
                Expanded(
                  flex: 7,
                  child: listCategorysToDisplay.isEmpty
                      ? const Center(
                          child: Text(
                            "Aucunes catétogies",
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                              children: listCategorysToDisplay
                                  .map((e) => AllCategoryListViewItem(
                                      e: e, removeFun: removeCategory))
                                  .toList()),
                        ),
                )
              ],
            ),
    );
  }

  void removeCategory(Category category) {
    setState(() {
      listCategories.remove(category);
      listCategorysToDisplay.remove(category);
    });
    StaticValues.loadCategoryList();
  }
}

class AllCategoryListViewItem extends StatefulWidget {
  const AllCategoryListViewItem({super.key, required this.e, this.removeFun});
  final Category e;
  final void Function(Category)? removeFun;
  @override
  State<AllCategoryListViewItem> createState() =>
      _AllCategoryListViewItemState();
}

class _AllCategoryListViewItemState extends State<AllCategoryListViewItem> {
  bool _isRemoving = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 7),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: appGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.e.name,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              Text(widget.e.description,
                  style: const TextStyle(color: Colors.black)),
            ],
          ),
          _isRemoving
              ? const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(color: Colors.red),
                )
              : Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddOrEditCategoryScreen(
                                    category: widget.e))),
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                        )),
                    IconButton(
                        onPressed: () => removeCategory(),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                ),
        ],
      ),
    );
  }

  removeCategory() async {
    setState(() {
      _isRemoving = true;
    });

    final formData = {
      "deleteCategorie": "1",
      "categorieId": "${widget.e.categoryId}"
    };
    try {
      print("---------------requesting $BASE_URL  for remove category");
      http.Response response =
          await http.post(Uri.parse(BASE_URL), body: formData);
      // print(response.statusCode);
      // print(response.body);
      var jsonresponse = json.decode(response.body);
      widget.removeFun!(widget.e);
      print(jsonresponse);
    } catch (e) {
      // print("------2------${e.toString()}");
      customFlutterToast(msg: "Erreur: ----2----${e.toString()}");
      // return false;
    } finally {}
    setState(() {
      _isRemoving = false;
    });
  }
}
