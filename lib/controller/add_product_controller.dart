import 'package:flutter/material.dart';

class AddProductController extends ChangeNotifier {
  List<String> productName = [];
  List<String> priceInfo = [];
  List<String> variationName = [];
  List<String> qtyItems = [];
  List<String> imageInfo = [];

  void addInfo(
      String name, String price, String variation, String qty, String image) {
    productName.add(name);
    priceInfo.add(price);
    variationName.add(variation);
    qtyItems.add(qty);
    imageInfo.add(image);
    notifyListeners();
  }
}
