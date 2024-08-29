import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/model/QrData.dart';
import 'package:sizer/sizer.dart';
import 'my_products.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
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

  String? qrData = "";

  List<String> addVariation = [];

  File? _image;

  final picker = ImagePicker();

  String? token;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageCache.clear();
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
    return null;
  }

  bool isLoading = false;

  String? imageUrl;

  String noImageUrl =
      "https://previews.123rf.com/images/pavelstasevich/pavelstasevich1811/pavelstasevich181101027/112815900-no-image-available-icon-flat-vector.jpg";

  Future<void> addData() async {
    var valueMap;

    if (_image != null) {
      imageUrl = await uploadImageToFirebase(
          context: context,
          file: _image!,
          fileName: '${_productName.text}_product.jpg');
    }

    QrData qrDataJson = QrData(
        productName: _productName.text,
        description: _description.text,
        metaDescription: _metaDescription.text,
        variationName: _variationName.text,
        purchasePrice: _purchasePrice.text,
        sellPrice: _sellPrice.text,
        sku: _sku.text,
        quantity: _quantity.text,
        imageProfile: imageUrl ?? noImageUrl);
    valueMap = qrDataJson.toJson();

    FirebaseFirestore.instance
        .collection("users")
        .doc(kFirebaseAuth.currentUser!.uid)
        // .collection("business_info")
        // .doc("$token")
        .collection("products")
        .add(valueMap)
        .catchError(
          // ignore: invalid_return_type_for_catch_error
          (e) => print('Error ===========>>> $e'),
        )
        .then((value) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return const MyProducts();
      //     },
      //   ),
      // );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: isLoading
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenSize.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.9.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Add Product',
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
                        child: const Text(
                          'Add product images',
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
                                  children: const [
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
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimarycolor, width: 2),
                                    borderRadius: BorderRadius.circular(12)),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: const Color(0xffE4E4E4),
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
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimarycolor, width: 2),
                                    borderRadius: BorderRadius.circular(12)),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: const Color(0xffE4E4E4),
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
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimarycolor, width: 2),
                                    borderRadius: BorderRadius.circular(12)),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: const Color(0xffE4E4E4),
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
                          commonText('Create variation'),
                          SizedBox(
                            width: 25.w,
                          ),
                          CupertinoSwitch(
                            trackColor: const Color(0xffB0BEC5),
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
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimarycolor, width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: "Enter variation name",
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: const Color(0xffE4E4E4),
                                  ),
                                ),
                              ),
                            )),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  addVariation.add(_variationName.text);
                                  //_variationName.clear();
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 2.7.h),
                                height: 4.6.h,
                                width: 10.5.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xff3881D8),
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
                                    color: const Color(0xffE4E4E4),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                          addVariation.length,
                                          (index) => Container(
                                                height: 4.6.h,
                                                margin:
                                                    EdgeInsets.only(right: 1.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.h),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color:
                                                      const Color(0xff2ECC71),
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
                                    color: const Color(0xff656565),
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
                                            color: const Color(0xff2ECC71),
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
                                                        _variationName.text)) {
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
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: _purchasePrice,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  kPrimarycolor,
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                  hintText: " Purchase Price",
                                                  border: InputBorder.none,
                                                  filled: true,
                                                  fillColor:
                                                      const Color(0xffE4E4E4),
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
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  kPrimarycolor,
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                  hintText: " Sell Price",
                                                  border: InputBorder.none,
                                                  filled: true,
                                                  fillColor:
                                                      const Color(0xffE4E4E4),
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
                                      padding: const EdgeInsets.only(left: 100),
                                      child: SizedBox(
                                        height: 6.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: TextField(
                                            controller: _barcode,
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimarycolor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              hintText: "Enter Barcode",
                                              border: InputBorder.none,
                                              filled: true,
                                              fillColor:
                                                  const Color(0xffE4E4E4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.5.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 100),
                                      child: SizedBox(
                                        height: 6.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: TextField(
                                            controller: _sku,
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimarycolor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              hintText: "Enter SKU",
                                              border: InputBorder.none,
                                              filled: true,
                                              fillColor:
                                                  const Color(0xffE4E4E4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.5.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 100),
                                      child: SizedBox(
                                        height: 6.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: TextField(
                                            controller: _quantity,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimarycolor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              hintText: "Quantity",
                                              border: InputBorder.none,
                                              filled: true,
                                              fillColor:
                                                  const Color(0xffE4E4E4),
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
                              color: const Color(0xff656565),
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
                                        borderRadius: BorderRadius.circular(12),
                                        child: TextField(
                                          controller: _purchasePrice,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: kPrimarycolor,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            hintText: " Purchase Price",
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: const Color(0xffE4E4E4),
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
                                        borderRadius: BorderRadius.circular(12),
                                        child: TextField(
                                          controller: _sellPrice,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: kPrimarycolor,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            hintText: " Sell Price",
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: const Color(0xffE4E4E4),
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
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kPrimarycolor, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.scanner,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      hintText: " Enter Barcode",
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: const Color(0xffE4E4E4),
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
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kPrimarycolor, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      hintText: " Enter SKU",
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: const Color(0xffE4E4E4),
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
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kPrimarycolor, width: 2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      hintText: " Quantity",
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: const Color(0xffE4E4E4),
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
                                log("token===1>>>$token");
                                log("token1===>>>${kFirebaseAuth.currentUser!.uid}");
                                log("token1===>>>${kFirebaseAuth.currentUser!.uid}");
                                setState(() {
                                  isLoading = true;
                                });

                                addData();
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
                  ),
                )),
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
