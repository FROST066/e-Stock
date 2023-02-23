// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

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
    this.categoryId,
    this.url,
  });

  int productId;
  String name;
  String description;
  int purchasePrice;
  int sellingPrice;
  int low;
  int? categoryId;
  String? url;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productID"],
        name: json["name"],
        description: json["description"],
        purchasePrice: json["purchasePrice"],
        sellingPrice: json["sellingPrice"],
        low: json["low"],
        categoryId: json["CategoryID"],
        url: json["url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "productID": productId,
        "name": name,
        "description": description,
        "purchasePrice": purchasePrice,
        "sellingPrice": sellingPrice,
        "low": low,
        "CategoryID": categoryId,
        "url": url,
      };
}


// {"productID": 1, "name": "Carotte", "description": "bla bal balla bla bla bla c'est une longue descritption", "purchasePrice": 500, "sellingPrice": 250, "low": 20, "CategoryID": 1,
//     "url":""
// }