import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/sharedpreference_services/shared_prefs_service.dart';
import 'package:invoice_generator/view/welcome_page.dart';
import 'package:sizer/sizer.dart';
import 'bottom_nav_bar.dart';
import 'email_auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userEmail;

  Future getUserEmail() async {
    String? user = await SharedPrefManager.getUserName();

    setState(() {
      userEmail = user;
    });
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    getUserEmail().whenComplete(() async {
      Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => userEmail == null
                  ? const WelcomePage()
                  : const BottomNavScreen(index: 0),
            )),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   colors: [
            //     //Colors.orange.shade900,
            //     //Colors.orange.shade800,
            //     //Colors.orange.shade400
            //     kPrimarycolor,
            //     kPrimarycolor
            //   ],
            // ),
            color: Colors.white),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   "assets/images/app_icon_1.svg",
              //   height: 200,
              //   width: 200,
              // ),
              Image.asset(
                "assets/images/splash_icon.png",
                height: 160.sp,
                width: 160.sp,
                //color: kPrimarycolor,
              ),
              const SizedBox(
                height: 60,
              ),
              Text(
                "Invoice Generator",
                style: TextStyle(
                    fontFamily: 'Raleway',
                    color: kPrimarycolor,
                    fontWeight: FontWeight.w900,
                    fontSize: 25.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
