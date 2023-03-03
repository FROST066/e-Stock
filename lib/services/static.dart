import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/Category.dart';
import '../other/const.dart';
import '../widgets/customFlutterToast.dart';

class StaticValues {
  static bool? _isLightMode;
  static bool? get getIsLightMode => _isLightMode;
  static set setIsLightMode(bool newValue) {
    _isLightMode = newValue;
  }

  static List<Category> _listCategories = [];
  static List<Category> get getListCategories => _listCategories;
  static set setListCategories(List<Category> listCategories) {
    _listCategories.clear();
    _listCategories.addAll(listCategories);
  }

  static printListCategories() {
    print("----printListCategories----");
    for (var item in _listCategories) {
      print(item.toString());
    }
  }

  static loadCategoryList() async {
    final prefs = await SharedPreferences.getInstance();
    final shopID = prefs.getInt(PrefKeys.SHOP_ID);
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
        _listCategories =
            (jsonresponse as List).map((e) => Category.fromJson(e)).toList();

        for (var item in _listCategories) {
          print(item.name);
        }
      } catch (e) {
        _listCategories.clear();
        customFlutterToast(msg: "Erreur: ----1----${e.toString()}");
      }
    } catch (e) {
      _listCategories.clear();
      customFlutterToast(msg: "Erreur: ----2----${e.toString()}");
    } finally {
      printListCategories();
    }
  }

  static getCategoryNameByID(int id) async {
    if (_listCategories.isEmpty) await loadCategoryList();
    for (var item in _listCategories) {
      if (item.categoryId == id) {
        return item.name;
      }
    }
    return "Inconnu";
  }
}
