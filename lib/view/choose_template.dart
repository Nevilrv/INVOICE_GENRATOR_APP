import 'package:flutter/material.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:sizer/sizer.dart';

class ChooseTemplate extends StatefulWidget {
  const ChooseTemplate({Key? key}) : super(key: key);

  @override
  State<ChooseTemplate> createState() => _ChooseTemplateState();
}

class _ChooseTemplateState extends State<ChooseTemplate>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  int styleSelected = 0;

  List<String> items = ['Template', 'Logo Style', 'Fonts', 'Color', 'Settings'];

  List<Map<String, dynamic>> styleList = [
    {'name': 'Style 1', 'image': ''},
    {'name': 'Style 2', 'image': ''},
    {'name': 'Style 3', 'image': ''},
    {'name': 'Style 4', 'image': ''},
    {'name': 'Style 5', 'image': ''},
    {'name': 'Style 6', 'image': ''},
  ];

  List<String> invoiceImageList = [
    'assets/images/invoice_sample.jpg',
    'assets/images/analytics.png',
    'assets/images/invoice_sample.jpg',
    'assets/images/invoice_sample.jpg',
    'assets/images/invoice_sample.jpg',
    'assets/images/invoice_sample.jpg',
  ];
  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimarycolor),
        centerTitle: true,
        title: const Text(
          "Choose Template",
          style: TextStyle(color: kPrimarycolor),
        ),
        backgroundColor: Colors.white,
        //elevation: 5,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(invoiceImageList[styleSelected]),
                ),
              ),
            ),
          ),
          Container(
            height: 33.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300, blurRadius: 2, spreadRadius: 2)
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                TabBar(
                  isScrollable: true,
                  //padding: EdgeInsets.zero,
                  labelPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  controller: tabController,
                  tabs: List.generate(
                    items.length,
                    (index) => Text(
                      items[index],
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ),
                // Divider(
                //   thickness: 1.5,
                //   color: Colors.grey,
                // ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(
                              6,
                              (index) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        styleSelected = index;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      height: 10.h,
                                      width: 10.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: styleSelected == index
                                                  ? kPrimarycolor
                                                  : Colors.grey.shade300,
                                              width: 1.5)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          styleSelected == index
                                              ? const Align(
                                                  alignment: Alignment.topRight,
                                                  child: Icon(
                                                    Icons.check_circle_outline,
                                                    size: 12,
                                                    color: kPrimarycolor,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          SizedBox(
                                            height: styleSelected == index
                                                ? 12.sp
                                                : 20.sp,
                                          ),
                                          Text(styleList[index]['name'])
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                      Text('Logo'),
                      Text('Fonts'),
                      Text('Color'),
                      Text('Settings'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: MaterialButton(
                    height: 50,
                    color: kPrimarycolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: 20.h,
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     border: Border.symmetric(
      //       vertical: BorderSide(color: Colors.grey, width: 1),
      //     ),
      //   ),
      // ),
    );
  }
}
