import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/sharedpreference_services/shared_prefs_service.dart';
import 'package:invoice_generator/view/privacy_policy.dart';
import 'package:invoice_generator/view/select_invoice.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'about_us.dart';
import 'analytics_screen.dart';
import 'choose_template.dart';
import 'customers_screen.dart';
import 'email_auth/login_screen.dart';
import 'invoice_list.dart';
import 'my_products.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _drawerKey = GlobalKey<ScaffoldState>();

  //To retrieve the string
  String? documentID;

  String? name;

  String? gstNumber;

  String? email;

  Future<String?> getEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString('name');
  }

  Future<String?> setEmail() async {
    String? username = await getEmail();

    setState(() {
      email = username;
    });
    log("token1====>>>$email");
    return null;
  }

  // void setToken() async {
  //   documentID = await getUserId();
  // }

  // getUserId() async {
  //   var collection = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(kFirebaseAuth.currentUser!.uid)
  //       .collection('business_info');
  //   var querySnapshots = await collection.get();
  //   for (var snapshot in querySnapshots.docs) {
  //     documentID = snapshot.id; // <-- Document ID
  //     print("ID===>>>$documentID");
  //   }
  // }

  // Future setUserId({String? userName}) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   sharedPreferences.setString('business', userName!);
  // }

  // Future<void> getGstNumber() async {
  //   final user = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc('${kFirebaseAuth.currentUser!.uid}')
  //       .collection("business_info")
  //       .doc("$documentID")
  //       .get();
  //   Map<String, dynamic>? getUserData = user.data();
  //   gstNumber = getUserData!['gst_number'];
  //   print("HIIIIII===>>>>>>>$documentID");
  // }

  @override
  void initState() {
    getEmail();
    setEmail();
    // getUserId();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Colors.white,
      drawer: Container(
        height: 100.h,
        width: 70.w,
        decoration: BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Container(
                height: screenSize.height * 0.15,
                width: 70.w,
                decoration: const BoxDecoration(color: kPrimarycolor),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            name == null
                                ? Text(
                                    "Welcome",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 23),
                                  )
                                : Text(
                                    "Hi, $name",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 23),
                                  ),
                            Spacer(),
                            InkResponse(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseTemplate(),
                  ),
                );
              },
              leading: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Choose Template",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.edit,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUs(),
                  ),
                );
              },
              leading: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "About Us",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.info_outline,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(
              height: 5,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPolicy(),
                  ),
                );
              },
              leading: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.privacy_tip_outlined,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                child: Text(
                  "Share",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.share,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                child: Text(
                  "Rate Us",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.star_rate_outlined,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),
            // SizedBox(
            //   height: 5,
            // ),
            // ListTile(
            //   leading: Padding(
            //     padding: const EdgeInsets.only(left: 7),
            //     child: TextButton(
            //       onPressed: () async {
            //         await getGstNumber();
            //         showDialog(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return AlertDialog(
            //               title: Column(
            //                 children: [
            //                   Text(
            //                     "Your GST Number :",
            //                     style: TextStyle(color: Colors.grey),
            //                   ),
            //                   SizedBox(
            //                     height: 20,
            //                   ),
            //                   Text("$gstNumber"),
            //                 ],
            //               ),
            //               actions: [
            //                 MaterialButton(
            //                   onPressed: () {
            //                     Navigator.pop(context);
            //                   },
            //                   child: Text("OK"),
            //                   color: kPrimarycolor,
            //                 ),
            //               ],
            //             );
            //           },
            //         );
            //       },
            //       child: Text(
            //         "Show GST Number",
            //         style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 18,
            //             fontWeight: FontWeight.w500),
            //       ),
            //     ),
            //   ),
            //   //trailing: gstNumber == null ? Text("") : Text(gstNumber!),
            // ),
            ListTile(
              onTap: () {
                SharedPrefManager.logOut().then(
                  (value) => ScaffoldMessenger.of(context)
                      .showSnackBar(
                        SnackBar(
                          content: Text("Logged Out"),
                          duration: Duration(milliseconds: 600),
                        ),
                      )
                      .closed
                      .then(
                        (value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        ),
                      ),
                );
              },
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.exit_to_app,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenSize.height * 0.079),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(25)),
          child: AppBar(
            titleSpacing: 10,
            backgroundColor: kPrimarycolor,
            toolbarHeight: screenSize.height * 0.079,
            leading: InkResponse(
              onTap: () {
                //getGstNumber();
                _drawerKey.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 30,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
                height: 65,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> _products =
                                snapshot.data!.docs;
                            log('${snapshot.connectionState}');

                            for (var element in _products) {
                              if (element['email'] == "$email") {
                                name = element['business_name'];
                                log('${element['business_name']}');
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 27),
                              child: Column(
                                children: [
                                  name == null
                                      ? Text(
                                          "Welcome",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 23),
                                        )
                                      : Text(
                                          "$name",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: InkWell(
              //       onTap: () {},
              //       child: SvgPicture.asset("assets/images/arrow.svg")),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: InkWell(
              //       onTap: () {},
              //       child: SvgPicture.asset("assets/images/notification.svg")),
              // ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenSize.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          //_showInterstitialAd();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyProducts(productId: documentID),
                            ),
                          );
                          print("Hiiiii");
                        },
                        child: Container(
                          height: 110.sp,
                          width: 128.sp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 3),
                                  blurRadius: 5)
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Image.asset(
                                "assets/images/products.png",
                                height: 80,
                                width: 80,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              const Text(
                                "Products",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SelectInvoice(productId: documentID),
                            ),
                          );
                        },
                        child: Container(
                          height: 110.sp,
                          width: 128.sp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 3),
                                  blurRadius: 5)
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Image.asset(
                                "assets/images/invoice.png",
                                height: 70,
                                width: 70,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              const Text(
                                "Invoicing",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomerScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 110.sp,
                          width: 128.sp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 3),
                                  blurRadius: 5)
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Image.asset(
                                "assets/images/customers.png",
                                height: 80,
                                width: 80,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              const Text(
                                "Customers",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InvoiceList(),
                            ),
                          );
                        },
                        child: Container(
                          height: 110.sp,
                          width: 128.sp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 3),
                                  blurRadius: 5)
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Image.asset(
                                "assets/images/invoice_list.png",
                                height: 80,
                                width: 80,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              const Text(
                                "Invoice List",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnalyticsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 20.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 3),
                              blurRadius: 5)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 4.h,
                          ),
                          const Text(
                            "Analytics",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 4.h,
                          ),
                          Image.asset(
                            "assets/images/analytics.png",
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.03,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
