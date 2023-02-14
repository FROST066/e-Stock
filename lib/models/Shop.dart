import 'dart:convert';

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

class Shop {
  int id;
  String shopName;
  bool? isActive;
  Shop(this.id, this.shopName, {this.isActive});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      int.parse(json['id']),
      json['nom'].toString(),
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'nom': shopName};
}
