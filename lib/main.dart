import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/view/splash_screen.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

import 'controller/add_customer_controller.dart';
import 'controller/add_product_controller.dart';
import 'controller/get_product_id_controller.dart';
import 'controller/update_product_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: kPrimarycolor));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AddProductController(),
          ),
          ChangeNotifierProvider(
            create: (context) => GetProductIdController(),
          ),
          ChangeNotifierProvider(
            create: (context) => UpdateProductController(),
          ),
          ChangeNotifierProvider(
            create: (context) => AddCustomerController(),
          ),
        ],
        child: GetMaterialApp(
          title: 'Invoice Generator',
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.indigo),
        ),
      );
    });
  }
}

///24BDPPV2782R1ZE
///24DVIPK1435H1ZQ
