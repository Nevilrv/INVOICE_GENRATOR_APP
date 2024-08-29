import 'package:flutter/material.dart';
import 'package:invoice_generator/constant/constant.dart';

class TextFieldWidget2 {
  static InputDecoration textFieldwidget = InputDecoration(
      //hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade300,
      counterText: "",
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: kPrimarycolor)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none));
}
