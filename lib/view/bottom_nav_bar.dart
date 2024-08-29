import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/view/profile_screen.dart';
import 'package:sizer/sizer.dart';
import 'home_screen.dart';
import 'invoice_screen.dart';

class BottomNavScreen extends StatefulWidget {
  final int index;

  const BottomNavScreen({Key? key, required this.index}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int pageSelected = 0;
  int buttonPushed = 0;

  List<Widget> screens = [
    HomeScreen(),
    ProductScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      pageSelected = widget.index;
      buttonPushed = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: screens[pageSelected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageSelected,
        onTap: (value) {
          setState(() {
            pageSelected = value;
          });
        },
        // ignore: unrelated_type_equality_checks
        selectedItemColor: pageSelected == screens ? Colors.grey : Colors.white,
        unselectedItemColor:
            // ignore: unrelated_type_equality_checks
            pageSelected == screens ? Colors.white : Colors.grey,
        selectedFontSize: 2,
        unselectedFontSize: 2,
        //backgroundColor: Colors.white,
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        iconSize: 30.00,
        selectedIconTheme: const IconThemeData(size: 30),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Container(
                height: 43.sp,
                width: 43.sp,
                decoration: BoxDecoration(
                  color: pageSelected == 0 ? kPrimarycolor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.shade400,
                  //     blurRadius: 3,
                  //     spreadRadius: 3,
                  //     offset: const Offset(3, 3),
                  //   )
                  // ],
                ),
                child: const Icon(
                  Icons.home_outlined,
                  size: 30,
                ),
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Container(
                height: 43.sp,
                width: 43.sp,
                decoration: BoxDecoration(
                  color: pageSelected == 1 ? kPrimarycolor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.grid_view,
                  size: 30,
                ),
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Container(
                height: 43.sp,
                width: 43.sp,
                decoration: BoxDecoration(
                  color: pageSelected == 2 ? kPrimarycolor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 30,
                ),
              ),
              label: ""),
        ],
      ),
    );
  }
}
