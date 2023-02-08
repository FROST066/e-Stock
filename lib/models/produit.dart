import 'package:e_stock/models/Categorie.dart';

class Produit {
  String idProduit, name, description, idCategorie;
  int low, priceA, priceV;
  Produit(this.idProduit, this.name, this.description, this.idCategorie,
      this.low, this.priceA, this.priceV);
}
