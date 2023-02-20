import 'dart:convert';
import 'package:e_stock/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../other/const.dart';
import '../../other/styles.dart';
import 'AddOrEditCategoryScreen.dart';
import 'package:search_choices/search_choices.dart';
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
  List<DropdownMenuItem> items = [];
  String? selectedValueSingleDialog;
  bool _isLoading = false;

  loadCategoryList() async {
    final prefs = await SharedPreferences.getInstance();
    final shopID = prefs.getInt(PrefKeys.SHOP_ID);
    setState(() {
      _isLoading = true;
    });
    final url = "$BASE_URL?magasin=$shopID&categories";
    print(url);
    try {
      print("---------------requesting $url for get all categories");
      http.Response response = await http.get(Uri.parse(url));
      // print(response.body);
      // print(response.statusCode);
      var jsonresponse = json.decode(response.body);
      print(jsonresponse);
      try {
        listCategories =
            (jsonresponse as List).map((e) => Category.fromJson(e)).toList();
        listCategorysToDisplay = listCategories;
        initDropDown();
      } catch (e) {
        print("-----1-------${e.toString()}");
      }
    } catch (e) {
      print("------2------${e.toString()}");
      // return false;
    } finally {
      setState(() {
        _isLoading = false;
        shopList;
      });
    }
  }

  @override
  void initState() {
    loadCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                      margin: const EdgeInsets.only(top: 90, bottom: 20),
                      width: MediaQuery.of(context).size.width * 0.93,
                      child: searchableSelect()),
                ),
                Flexible(
                  flex: 7,
                  child: SingleChildScrollView(
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

  Widget searchableSelect() {
    return SearchChoices.single(
      items: items,
      value: selectedValueSingleDialog,
      hint: "  Rechercher une catégorie",
      style: const TextStyle(color: Colors.black, fontSize: 17),
      searchHint: "Rechercher une catégorie",
      fieldDecoration: BoxDecoration(
        color: appGrey,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: appGrey),
      ),
      searchInputDecoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black),
          hintStyle: const TextStyle(color: Colors.black),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
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
          if (value == null) {
            listCategorysToDisplay = listCategories;
          } else {
            listCategorysToDisplay = listCategories
                .where((element) => element.name == selectedValueSingleDialog)
                .toList();
          }
        });
      },
      isExpanded: true,
    );
  }

  initDropDown() {
    items = listCategories
        .map((e) => DropdownMenuItem(
            value: e.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(e.name),
            )))
        .toList();
  }

  void removeCategory(Category category) {
    setState(() {
      listCategories.remove(category);
      listCategorysToDisplay.remove(category);
    });
  }
}

class AllCategoryListViewItem extends StatefulWidget {
  AllCategoryListViewItem({super.key, required this.e, this.removeFun});
  final Category e;
  void Function(Category)? removeFun;
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
          Flexible(
            flex: 1,
            child: Column(
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
      "deleteCategory": "1",
      "CategoryId": "${widget.e.categoryId}"
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
      print("------2------${e.toString()}");
      // return false;
    } finally {}
    setState(() {
      _isRemoving = false;
    });
  }
}
