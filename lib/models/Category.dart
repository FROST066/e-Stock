// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    required this.categoryId,
    this.shopId,
    required this.name,
    required this.description,
  });

  int categoryId;
  int? shopId;
  String name;
  String description;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: int.parse(json["id"]),
        shopId: json["magasin"] == null ? null : int.parse(json["magasin"]),
        name: json["nom"],
        description: json["descriptions"],
      );

  Map<String, dynamic> toJson() => {
        "categoryID": categoryId,
        "shopID": shopId ?? 0,
        "name": name,
        "description": description,
      };
}

// {
//    "categoryID":1,
//    "shopID":1,
//    "name":"un nom",
//    "description":"leldodk"
// }

// {id: 1, nom: NOMM, magasin: 14, descriptions: Une description}