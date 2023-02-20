// To parse this JSON data, do
//
//     final historyItem = historyItemFromJson(jsonString);

import 'dart:convert';

import 'product.dart';

HistoryItem historyItemFromJson(String str) =>
    HistoryItem.fromJson(json.decode(str));

String historyItemToJson(HistoryItem data) => json.encode(data.toJson());

class HistoryItem {
  HistoryItem({
    required this.product,
    required this.categoryName,
    required this.type,
    required this.hour,
    required this.date,
    required this.nbre,
  });

  Product product;
  String categoryName;
  int type;
  String hour;
  String date;
  String nbre;

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        product: Product.fromJson(json["product"]),
        categoryName: json["CategoryName"],
        type: json["type"],
        hour: json["hour"],
        date: json["date"],
        nbre: json["nbre"],
      );

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "CategoryName": categoryName,
        "type": type,
        "hour": hour,
        "date": date,
        "nbre": nbre,
      };
}

// {
//     "product":{"productID":3,"name":"Pomme","description":"bla bal balla bla bla bla c'est une longue descritption","purchasePrice":300,"sellingPrice":100,"low":10,"CategoryID":1},
//     "CategoryName": "Fruit",
//     "type": 0,
//     "hour": "10:34",
//     "date": "31-12-2022",
//     "nbre": "50"
// }