// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.productID,
    required this.name,
    required this.description,
    required this.sellingPrice,
    required this.quantiteDisponible,
    required this.categoryID,
    required this.url,
    required this.stockMin,
  });

  int productID;
  String name;
  String description;
  int sellingPrice, quantiteDisponible, categoryID, stockMin;
  String? url;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productID: int.parse(json["id"] ?? "0"),
        name: json["nom"] ?? "",
        description: json["descriptions"] ?? "",
        sellingPrice: int.parse(json["prixUnitaire"] ?? "0"),
        quantiteDisponible: int.parse(json["quantiteDisponible"] ?? "0"),
        categoryID: int.parse(json["categorie"] ?? "0"),
        url: json["urlPhoto"],
        stockMin: int.parse(json["stockMin"] ?? "5"),
      );

  Map<String, dynamic> toJson() => {
        "id": productID,
        "nom": name,
        "descriptions": description,
        "prixUnitaire": sellingPrice,
        "quantiteDisponible": quantiteDisponible,
        "categorie": categoryID,
        "urlPhoto": url,
        "stockMin": stockMin,
      };
}


// {"productID": 1, "name": "Carotte", "description": "bla bal balla bla bla bla c'est une longue descritption", "purchasePrice": 500, "sellingPrice": 250, "low": 20, "CategoryID": 1,
//     "url":""
// }