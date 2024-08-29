import 'package:flutter/material.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/view/email_auth/login_screen.dart';
import 'package:invoice_generator/view/home_screen.dart';
import 'package:sizer/sizer.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(50),
            ),
            child: Image.asset(
              'assets/images/header.png',
              height: 50.h,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            "Generate All Types",
            style: TextStyle(
                color: kPrimarycolor,
                fontWeight: FontWeight.bold,
                fontSize: 23.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            "Of Invoices",
            style: TextStyle(
                color: kPrimarycolor,
                fontWeight: FontWeight.bold,
                fontSize: 23.sp),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            "Various Invoice Formats with",
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp),
          ),
          Text(
            "GST details and business logo",
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp),
          ),
          SizedBox(
            height: 4.h,
          ),
          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            height: 43.sp,
            minWidth: 135.sp,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: kPrimarycolor,
            child: Text(
              "Get Started",
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          )
        ],
      ),
    );
  }
}
