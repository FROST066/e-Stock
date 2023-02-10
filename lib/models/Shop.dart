class Shop {
  int? id;
  String? shopName;
  bool? isActive;
  Shop({this.id, this.shopName, this.isActive});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      shopName: json['nom'].toString(),
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'nom': shopName};
}
