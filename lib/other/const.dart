import '../models/Shop.dart';

const String BASE_URL = "https://flutterapigk.000webhostapp.com";
// const String BASE_URL = "http://192.168.8.101/apiForFlutterProject/tp/";

class PrefKeys {
  static String USER_ID = "USER_ID";
  static String USER_NAME = "USER_NAME";
  static String SHOP_ID = "SHOP_ID";
  static String IS_LIGHT = "IS_LIGHT";
}

List<Shop> shopList = [
  Shop(id: 1, shopName: "Quincaillerie", isActive: true),
  Shop(id: 2, shopName: "Patisserie", isActive: false),
  Shop(id: 3, shopName: "Salon de coiffure", isActive: false),
];
