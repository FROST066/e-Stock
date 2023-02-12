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
  Shop(1, "Quincaillerie", isActive: true),
  Shop(2, "Patisserie", isActive: false),
  Shop(3, "Salon de coiffure", isActive: false),
];
