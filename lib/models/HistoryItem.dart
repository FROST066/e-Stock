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
    required this.heure,
    required this.date,
    required this.nbr,
    required this.prixApprovisionement,
  });

  Product product;
  String categoryName;
  int type, nbr;
  String heure, date;
  int? prixApprovisionement;

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
      product: Product.fromJson(json["product"]),
      categoryName: json["CategoryName"],
      type: json["type"],
      heure: json["heure"],
      date: json["date"],
      nbr: (json["nbr"]),
      prixApprovisionement: json["PrixApprovisionement"]);

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "CategoryName": categoryName,
        "type": type,
        "heure": heure,
        "date": date,
        "nbr": nbr,
        "PrixApprovisionement": prixApprovisionement,
      };

  @override
  String toString() =>
      "{ product: ${product.name}, categoryName: $categoryName, type: $type, heure: $heure, date: $date, nbr: $nbr, prixApprovisionement: $prixApprovisionement}";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryItem &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          categoryName == other.categoryName &&
          type == other.type &&
          heure == other.heure &&
          date == other.date &&
          nbr == other.nbr &&
          prixApprovisionement == other.prixApprovisionement;

  bool operator <(Object other) =>
      other is HistoryItem && date.compareTo(other.date) < 0;

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
