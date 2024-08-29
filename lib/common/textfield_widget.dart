import 'package:flutter/material.dart';
import 'package:invoice_generator/constant/constant.dart';

class TextFieldWidget extends StatelessWidget {
  dynamic controller;
  Widget? prefixIcon;
  String? hintText;
  dynamic keyboardType;
  bool? obscureText;
  dynamic maxLength;
  FormFieldValidator? validator;

  TextFieldWidget(
      {this.controller,
      this.hintText,
      this.prefixIcon,
      this.keyboardType,
      this.obscureText,
      this.maxLength,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        counterText: "",
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimarycolor, width: 1),
        ),
      ),
    );
  }
}
