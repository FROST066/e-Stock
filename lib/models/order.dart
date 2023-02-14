// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'package:e_stock/models/product.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.orderId,
    required this.shopId,
    required this.list,
  });

  int orderId;
  int shopId;
  List<OrderItem> list;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderID"],
        shopId: json["shopID"],
        list: List<OrderItem>.from(
            json["list"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "shopID": shopId,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

OrderItem orderItemFromJson(String str) => OrderItem.fromJson(json.decode(str));

String orderItemToJson(OrderItem data) => json.encode(data.toJson());

class OrderItem {
  OrderItem({
    this.quantity = 0,
    this.product,
  });

  int quantity;
  Product? product;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        quantity: json["quantity"] ?? 0,
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "product": product != null ? product!.toJson() : {},
      };
}
