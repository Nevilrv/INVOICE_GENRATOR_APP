import 'package:flutter/material.dart';
import 'package:invoice_generator/constant/constant.dart';

class ButtonWidget extends StatelessWidget {
  String? title;
  dynamic onTap;

  ButtonWidget({Key? key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: screenSize.height * 0.07,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kPrimarycolor,
          borderRadius: BorderRadius.circular(30),
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     Colors.orange.shade900,
          //     Colors.orange.shade800,
          //     Colors.orange.shade400
          //   ],
          // ),
        ),
        child: Center(
            child: Text(
          title!,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
