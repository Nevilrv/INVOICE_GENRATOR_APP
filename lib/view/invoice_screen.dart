import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/controller/add_customer_controller.dart';
import 'package:invoice_generator/controller/add_product_controller.dart';
import 'package:invoice_generator/view/select_invoice.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'generate_invoice.dart';

class ProductScreen extends StatefulWidget {
  final name;
  final price;
  final variation;
  final qty;
  final image;

  const ProductScreen(
      {Key? key, this.name, this.price, this.variation, this.qty, this.image})
      : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int total = 0;
  int _counter = 1;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final provider = Provider.of<AddProductController>(context, listen: false);
    final provider1 =
        Provider.of<AddCustomerController>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectInvoice(),
                  ),
                );
              },
              child: Container(
                height: 6.6.h,
                width: 17.5.h,
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Colors.orange.shade900,
                  //     Colors.orange.shade800,
                  //     Colors.orange.shade400
                  //   ],
                  // ),
                  color: kPrimarycolor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Add Manually',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenerateInvoice(),
                  ),
                );
                provider1.addInfo(_counter);
              },
              child: Container(
                height: 6.6.h,
                width: 19.5.h,
                decoration: BoxDecoration(
                  color: kPrimarycolor,
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Colors.orange.shade900,
                  //     Colors.orange.shade800,
                  //     Colors.orange.shade400
                  //   ],
                  // ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Generate Invoice',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
            titleSpacing: 26,
            backgroundColor: kPrimarycolor,
            toolbarHeight: screenSize.height * 0.077,
            title: const Text(
              "Invoice",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 1.h,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: provider.productName.length,
                itemBuilder: (context, index) {
                  return provider.productName[index] == null
                      ? SizedBox(
                          height: 0,
                          width: 0,
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),

                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(
                                "${provider.imageInfo[index]}",
                                height: 150,
                                width: 150,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${provider.productName[index]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 7.h,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Price:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        width: 1.h,
                                      ),
                                      Text(
                                        "${provider.priceInfo[index]}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Variation:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        width: 1.h,
                                      ),
                                      Text(
                                        "${provider.variationName[index]}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (_counter > 1) {
                                                  _counter--;
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              Icons.remove_circle_outline,
                                              size: 30,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              "$_counter",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _counter++;
                                              });
                                            },
                                            child: Icon(
                                              Icons.add_circle_outline,
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 6.h,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            provider.productName.remove(
                                                provider.productName[index]);
                                            provider.priceInfo.remove(
                                                provider.priceInfo[index]);
                                            provider.variationName.remove(
                                                provider.variationName[index]);
                                            provider.qtyItems.remove(
                                                provider.qtyItems[index]);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                }),
          ),
        ],
      ),
    );
  }
}

// class ItemCount extends StatefulWidget {
//   @override
//   State<ItemCount> createState() => _ItemCountState();
// }
//
// class _ItemCountState extends State<ItemCount> {
//   // int _counter = 1;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         InkWell(
//           onTap: () {
//             setState(() {
//               if (_counter > 1) {
//                 _counter--;
//               }
//             });
//           },
//           child: const Icon(
//             Icons.remove_circle_outline,
//             size: 30,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Text(
//             "$_counter",
//             style: const TextStyle(color: Colors.black, fontSize: 18),
//           ),
//         ),
//         InkWell(
//           onTap: () {
//             setState(() {
//               _counter++;
//             });
//           },
//           child: Icon(
//             Icons.add_circle_outline,
//             size: 30,
//           ),
//         ),
//       ],
//     );
//   }
// }
