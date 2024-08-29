import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/common/textfield2.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/controller/add_product_controller.dart';
import 'package:invoice_generator/controller/update_product_controller.dart';
import 'package:invoice_generator/model/QrData.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'details_screen.dart';

class SelectInvoice extends StatefulWidget {
  final productId;

  const SelectInvoice({Key? key, this.productId}) : super(key: key);

  @override
  _SelectInvoiceState createState() => _SelectInvoiceState();
}

class _SelectInvoiceState extends State<SelectInvoice> {
  String? qrData = "";

  var valueMap;
  List<QrData> product = [];
  String noImageUrl =
      "https://previews.123rf.com/images/pavelstasevich/pavelstasevich1811/pavelstasevich181101027/112815900-no-image-available-icon-flat-vector.jpg";

  final TextEditingController _searchController = TextEditingController();

  String searchText = '';

  bool? switchButton = false;
  String? token;

  String? id;

  Future<String?> getId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString('business');
  }

  Future<String?> setId() async {
    String? username = await getId();

    setState(() {
      id = username;
    });
    log("Token1====>>>$id");
    return null;
  }

  @override
  void initState() {
    getId();
    setId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<UpdateProductController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        backgroundColor: kPrimarycolor,
        toolbarHeight: 65,
        title: const Text(
          "Select product",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        actions: const [

        ],
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
                  log("token======>$token");
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
                      return GestureDetector(
                        onTap: () {
                          provider.getId(_products[index].id);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  name:
                                      "${_products[index].get("product_name")}",
                                  price:
                                      "${_products[index].get("sell_price")}",
                                  image:
                                      "${_products[index].get("imageProfile")}",
                                  variation:
                                      "${_products[index].get("variation_name")}",
                                  qty: "${_products[index].get("quantity")}",
                                ),
                              ));
                        },
                        child: Container(
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
                                child: SizedBox(
                                  height: 15.h,
                                  width: 15.h,
                                  child: ProgressiveImage(
                                    placeholder: AssetImage(
                                        'assets/images/products.png'),
                                    // size: 1.87KB
                                    thumbnail: NetworkImage(
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
                                    children: [
                                      Text(
                                        "${_products[index].get("product_name")}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
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
                                        style: TextStyle(
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
                                            fontWeight: FontWeight.w400),
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
                                ],
                              ),
                            ],
                          ),
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
        ],
      ),
    );
  }

  addQrInfo() {
    final provider = Provider.of<AddProductController>(context, listen: false);
    QrData qrDataJson = QrData.fromJson(jsonDecode(qrData!));
    valueMap = qrDataJson.toJson();
    if (product.isNotEmpty) {
      for (var i = 0; i < product.length; i++) {
        if (product[i].productName == qrDataJson.productName) {
          provider.addInfo(
              qrDataJson.productName!,
              qrDataJson.sellPrice!,
              qrDataJson.variationName!,
              qrDataJson.quantity!,
              qrDataJson.imageProfile!.isEmpty
                  ? noImageUrl
                  : qrDataJson.imageProfile!);
          // } else {
          //   return showDialog(
          //     context: context,
          //     builder: (context) {
          //       return SimpleDialog(
          //         title: Text("Product Not Found"),
          //         children: [
          //           TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               child: Text("OK"))
          //         ],
          //       );
          //     },
          //   );
          // }
        }
      }
    }
  }
}
