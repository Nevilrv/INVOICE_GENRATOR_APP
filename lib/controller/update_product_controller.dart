import 'package:flutter/material.dart';

class UpdateProductController extends ChangeNotifier {
  List<String> productId = [];

  void getId(
    String id,
  ) {
    productId.add(id);
    notifyListeners();
  }
}
