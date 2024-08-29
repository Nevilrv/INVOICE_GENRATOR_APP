import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/common/textfield2.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/controller/get_product_id_controller.dart';
import 'package:invoice_generator/view/update_data.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'add_product_screen.dart';

class MyProducts extends StatefulWidget {
  final productId;

  const MyProducts({Key? key, this.productId}) : super(key: key);
  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  bool? switchButton = false;
  int totalPrice = 0;

  // String? id;
  //
  // Future<String?> getId() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   return sharedPreferences.getString('business');
  // }
  //
  // Future<String?> setId() async {
  //   String? username = await getId();
  //
  //   setState(() {
  //     id = username;
  //   });
  //   log("Token1====>>>$id");
  //   return null;
  // }

  @override
  void initState() {
    // getId();
    // setId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<GetProductIdController>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimarycolor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 45,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
        },
      ),
      appBar: AppBar(
        titleSpacing: 8,
        backgroundColor: kPrimarycolor,
        toolbarHeight: 65,
        title: const Text(
          "My Products",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),

      ),
      body: Column(
        children: [
          SizedBox(
            height: 1.5.h,
          ),
          SizedBox(
            height: 7.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: TextFieldWidget2.textFieldwidget.copyWith(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(kFirebaseAuth.currentUser!.uid)
                  // .collection("business_info")
                  // .doc("${widget.productId ?? id}")
                  .collection("products")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> _products = snapshot.data!.docs;
                  log("token1======>${_products.length}");
                  if (searchText.isNotEmpty) {
                    _products = _products.where((element) {
                      return element
                          .get('product_name')
                          .toString()
                          .toLowerCase()
                          .contains(searchText.toLowerCase());
                    }).toList();
                  }
                  return ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        height: 25.h,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              child: Container(
                                height: 15.h,
                                width: 15.h,
                                child: ProgressiveImage(
                                  placeholder:
                                      const AssetImage('assets/images/products.png'),
                                  // size: 1.87KB
                                  thumbnail: const NetworkImage(
                                      'https://i.imgur.com/7XL923M.jpg'),
                                  // size: 1.29MB
                                  image: NetworkImage(
                                      "${_products[index].get("imageProfile")}"),
                                  height: 15.h,
                                  width: 15.h,
                                  fit: BoxFit.cover,
                                ),
                                // decoration: BoxDecoration(
                                //     image: DecorationImage(
                                //         image: NetworkImage(
                                //             "${_products[index].get("imageProfile")}"),
                                //         fit: BoxFit.cover)),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 3.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${_products[index].get("product_name")}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 4.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        provider.getId(
                                            snapshot.data!.docs[index].id);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateData(),
                                            ));
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                Row(
                                  children: [
                                    const Text(
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
                                      "\$${_products[index].get("sell_price")}",
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.2.h,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Variation:",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,),
                                    ),
                                    SizedBox(
                                      width: 1.h,
                                    ),
                                    Text(
                                      "${_products[index].get("variation_name")}",
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.2.h,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Qty",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      width: 1.h,
                                    ),

                                    Text(
                                      "${_products[index].get("quantity")}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 15.5.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              content: const Text(
                                                "Are you sure that you want to delete this product ?",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(kFirebaseAuth
                                                            .currentUser!.uid)
                                                        // .collection(
                                                        //     "business_info")
                                                        // .doc(
                                                        //     "${widget.productId}")
                                                        .collection("products")
                                                        .doc(
                                                            _products[index].id)
                                                        .delete()
                                                        .catchError((e) {
                                                      log('delete error==>> $e');
                                                    });

                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                  child: const Text("No"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }
}

