import 'package:e_stock/models/Categorie.dart';

// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
//ajouter le stock disponible
import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.low,
    required this.categoryId,
  });

  int productId;
  String name;
  String description;
  int purchasePrice;
  int sellingPrice;
  int low;
  int categoryId;
  // int stock = 0;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productID"],
        name: json["name"],
        description: json["description"],
        purchasePrice: json["purchasePrice"],
        sellingPrice: json["sellingPrice"],
        low: json["low"],
        categoryId: json["CategoryID"],
      );

  Map<String, dynamic> toJson() => {
        "productID": productId,
        "name": name,
        "description": description,
        "purchasePrice": purchasePrice,
        "sellingPrice": sellingPrice,
        "low": low,
        "CategoryID": categoryId,
      };
}
