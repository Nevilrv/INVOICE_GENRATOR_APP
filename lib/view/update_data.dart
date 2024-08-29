import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/controller/get_product_id_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'my_products.dart';

class UpdateData extends StatefulWidget {
  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  bool? switchButton = false;
  bool? switchButton1 = false;
  bool imageSelected = false;

  final _variationName = TextEditingController();
  final _productName = TextEditingController();
  final _metaDescription = TextEditingController();
  final _description = TextEditingController();
  final _purchasePrice = TextEditingController();
  final _sellPrice = TextEditingController();
  final _barcode = TextEditingController();
  final _sku = TextEditingController();
  final _quantity = TextEditingController();

  List<String> addVariation = [];

  File? _image;

  final picker = ImagePicker();

  String? token;
  String? token1;
  String? token2;

  Future<String?> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString('token');
  }

  Future<String?> setToken() async {
    String? uid = await getToken();

    setState(() {
      token1 = uid;
    });
    log("token1====>>>$token1");
  }

  Future<String?> getBusinessId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString('business');
  }

  Future<String?> setBusinessId() async {
    String? uid = await getBusinessId();

    setState(() {
      token2 = uid;
    });
    log("token====>>>$token2");
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageCache!.clear();
      } else {
        print("no Image selected");
      }
    });
  }

  clearImage() {
    setState(() {
      print("remove:$_image");
      _image = null;
    });
  }

  Future<String?> uploadImageToFirebase(
      {required BuildContext context,
      required String fileName,
      required File file}) async {
    try {
      var response = await firebase_storage.FirebaseStorage.instance
          .ref('uploads/$fileName')
          .putFile(file);
      print("Response>>>>>>>>>>>>>>>>>>$response");
      return response.storage.ref('uploads/$fileName').getDownloadURL();
    } catch (e) {
      print(e);
    }
  }

  bool isLoading = false;

  Future<void> updateData() async {
    final provider =
        Provider.of<GetProductIdController>(context, listen: false);
    log("TOKEN-----${provider.productId}");
    String? imageUrl = await uploadImageToFirebase(
        context: context,
        file: _image!,
        fileName: '${_productName}_product.jpg');
    FirebaseFirestore.instance
        .collection("users")
        .doc(kFirebaseAuth.currentUser?.uid)
        // .collection("business_info")
        // .doc("$token2")
        .collection("products")
        .doc("${provider.productId}")
        .update(
          {
            'product_name': _productName.text,
            'meta_description': _metaDescription.text,
            'description': _description.text,
            "variation_name": _variationName.text,
            "purchase_price": _purchasePrice.text,
            'sell_price': _sellPrice.text,
            'sku': _sku.text,
            'quantity': _quantity.text,
            'imageProfile': imageUrl,
          },
        )
        .catchError(
          // ignore: invalid_return_type_for_catch_error
          (e) => log(' Update Error ===========>>> $e'),
        )
        .then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        });
  }

  @override
  void initState() {
    getToken();
    setToken();
    getBusinessId();
    setBusinessId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc('$token1')
                      .collection("business_info")
                      .doc("$token2")
                      .collection("products")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    log('${snapshot.connectionState}');
                    if (snapshot.hasData) {
                      //log("${snapshot.data!.docs[0].id}");
                      //token = snapshot.data!.docs[0].id;
                      //log(" product===>>>$token");
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Size.height * 0.04,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.9.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Update Product Info',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.7.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.9.h),
                          child: Text(
                            'Update product images',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.8.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.9.h),
                          child: const Text(
                            'Add upto 5 images, first image will be your product’s cover image that will highlight everywhere',
                            style: TextStyle(
                              color: Color(0xff666565),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.9.h),
                          child: GestureDetector(
                            onTap: () {
                              getImage();
                              setState(() {
                                imageSelected = true;
                              });
                            },
                            child: imageSelected == true
                                ? Row(
                                    children: [
                                      Text(
                                        "Image Selected",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.done_all,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  )
                                : SvgPicture.asset(
                                    'assets/images/image_picker.svg'),
                          ),
                        ),
                        SizedBox(
                          height: 4.5.h,
                        ),
                        commonText('Product Name'),
                        SizedBox(
                          height: 1.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.9.h),
                          child: SizedBox(
                            height: 6.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: TextField(
                                controller: _productName,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Color(0xffE4E4E4),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.4.h,
                        ),
                        commonText('Product meta description'),
                        SizedBox(
                          height: 1.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.9.h),
                          child: SizedBox(
                            height: 6.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: TextField(
                                controller: _metaDescription,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Color(0xffE4E4E4),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.4.h,
                        ),
                        commonText('Product description'),
                        SizedBox(
                          height: 1.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.9.h),
                          child: SizedBox(
                            height: 6.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: TextField(
                                controller: _description,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Color(0xffE4E4E4),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            commonText('Update variation'),
                            SizedBox(
                              width: 25.w,
                            ),
                            CupertinoSwitch(
                              trackColor: Color(0xffB0BEC5),
                              value: switchButton!,
                              onChanged: (value) {
                                setState(() {
                                  switchButton = value;
                                });
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: switchButton! ? 1.h : 0,
                        ),
                        Visibility(
                          visible: switchButton!,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Container(
                                margin: EdgeInsets.only(left: 2.7.h),
                                height: 6.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: TextField(
                                    controller: _variationName,
                                    decoration: InputDecoration(
                                      hintText: "Enter variation name",
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Color(0xffE4E4E4),
                                    ),
                                  ),
                                ),
                              )),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    addVariation.add(_variationName.text);
                                  });
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 2.7.h),
                                  height: 4.6.h,
                                  width: 10.5.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xff3881D8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Add',
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
                        SizedBox(
                          height: switchButton! ? 1.h : 0,
                        ),
                        Visibility(
                          visible: switchButton!,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.7.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 6.h,
                                    margin: EdgeInsets.only(right: 2.7.h),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.h, vertical: 0.8.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xffE4E4E4),
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                            addVariation.length,
                                            (index) => Container(
                                                  height: 4.6.h,
                                                  margin: EdgeInsets.only(
                                                      right: 1.h),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 2.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Color(0xff2ECC71),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        addVariation[index],
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1.h,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (addVariation
                                                                .contains(
                                                                    _variationName
                                                                        .text)) {
                                                              print(
                                                                  "contain value");
                                                            }
                                                            addVariation.remove(
                                                                addVariation[
                                                                    index]);
                                                          });
                                                        },
                                                        child: SvgPicture.asset(
                                                          'assets/images/remove.svg',
                                                          height: 20,
                                                          width: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: switchButton! ? 3.h : 0,
                        ),
                        Visibility(
                            visible: switchButton!,
                            child: Column(
                              children: List.generate(
                                addVariation.length,
                                (index) => Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 2.7.h, vertical: 5),
                                  padding: EdgeInsets.all(1.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Color(0xff656565),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 4.6.h,
                                            margin: EdgeInsets.only(right: 1.h),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Color(0xff2ECC71),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  addVariation[index],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 1.h,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (addVariation.contains(
                                                          _variationName
                                                              .text)) {
                                                        print("contain value");
                                                      }
                                                      addVariation.remove(
                                                          addVariation[index]);
                                                    });
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/images/remove.svg',
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2.h,
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              height: 6.h,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: TextField(
                                                  controller: _purchasePrice,
                                                  decoration: InputDecoration(
                                                    hintText: " Purchase Price",
                                                    border: InputBorder.none,
                                                    filled: true,
                                                    fillColor:
                                                        Color(0xffE4E4E4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2.h,
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              height: 6.h,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: TextField(
                                                  controller: _sellPrice,
                                                  decoration: InputDecoration(
                                                    hintText: " Sell Price",
                                                    border: InputBorder.none,
                                                    filled: true,
                                                    fillColor:
                                                        Color(0xffE4E4E4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 100),
                                        child: SizedBox(
                                          height: 6.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: TextField(
                                              controller: _barcode,
                                              decoration: InputDecoration(
                                                hintText: "Enter Barcode",
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Color(0xffE4E4E4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 100),
                                        child: SizedBox(
                                          height: 6.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: TextField(
                                              controller: _sku,
                                              decoration: InputDecoration(
                                                hintText: "Enter SKU",
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Color(0xffE4E4E4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 100),
                                        child: SizedBox(
                                          height: 6.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _quantity,
                                              decoration: InputDecoration(
                                                hintText: "Quantity",
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Color(0xffE4E4E4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 3.h,
                        ),
                        Visibility(
                          visible: switchButton! ? false : true,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.7.h),
                            padding: EdgeInsets.all(1.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xff656565),
                                width: 0.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 6.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: TextField(
                                            controller: _purchasePrice,
                                            decoration: InputDecoration(
                                              hintText: " Purchase Price",
                                              border: InputBorder.none,
                                              filled: true,
                                              fillColor: Color(0xffE4E4E4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2.h,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 6.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: TextField(
                                            controller: _sellPrice,
                                            decoration: InputDecoration(
                                              hintText: " Sell Price",
                                              border: InputBorder.none,
                                              filled: true,
                                              fillColor: Color(0xffE4E4E4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                SizedBox(
                                  height: 6.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: TextField(
                                      controller: _barcode,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.scanner,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        hintText: " Enter Barcode",
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Color(0xffE4E4E4),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                SizedBox(
                                  height: 6.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: TextField(
                                      controller: _sku,
                                      decoration: InputDecoration(
                                        hintText: " Enter SKU",
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Color(0xffE4E4E4),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                SizedBox(
                                  height: 6.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: TextField(
                                      controller: _quantity,
                                      decoration: InputDecoration(
                                        hintText: " Quantity",
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Color(0xffE4E4E4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: switchButton! ? 0 : 3.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  log("token===>>>$token");
                                  log("token1===>>>$token1");
                                  log("token2===>>>$token2");
                                  setState(() {
                                    isLoading = true;
                                  });
                                  updateData();
                                },
                                child: Container(
                                  height: 6.6.h,
                                  width: 12.5.h,
                                  decoration: BoxDecoration(
                                    color: kPrimarycolor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                      child: Icon(
                                    Icons.arrow_forward,
                                    size: 35,
                                    color: Colors.white,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }

  Padding commonText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.9.h),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
