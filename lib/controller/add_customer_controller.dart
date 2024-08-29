import 'package:flutter/material.dart';

class AddCustomerController extends ChangeNotifier {
  List<int> customerInfo = [];

  void addInfo(int qty) {
    customerInfo.add(qty);
    notifyListeners();
  }
}
