import 'package:flutter/material.dart';

class GetProductIdController extends ChangeNotifier {
  String? productId;

  void getId(String id) {
    productId = id;
    notifyListeners();
  }
}
