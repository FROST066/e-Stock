// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.orderId,
    required this.type,
    required this.shopId,
    required this.list,
  });

  int orderId;
  int type;
  int shopId;
  List<OrderItem> list;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderID"],
        type: json["type"],
        shopId: json["shopID"],
        list: List<OrderItem>.from(
            json["list"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "type": type,
        "shopID": shopId,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class OrderItem {
  OrderItem({
    required this.quantity,
    required this.productId,
  });

  int quantity;
  int productId;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        quantity: json["quantity"],
        productId: json["productID"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "productID": productId,
      };
}
