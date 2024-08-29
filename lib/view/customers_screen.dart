import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:govt_documents_validator/govt_documents_validator.dart';
import 'package:invoice_generator/api/api_viewModel.dart';
import 'package:invoice_generator/common/textfield2.dart';
import 'package:invoice_generator/common/textfield_widget.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final _customerName = TextEditingController();
  final _customerAddress = TextEditingController();
  final _customerContactNo = TextEditingController();
  final _customerGstNo = TextEditingController();
  final _customerPanNo = TextEditingController();
  TextEditingController _searchController = TextEditingController();


  final _formKey = GlobalKey<FormState>();
  bool ?isAadharNum;
  bool ?isGSTNum;
  GSTValidator gstValidator =  GSTValidator();
  PANValidator panValidator =  PANValidator();

  String searchText = '';
  Map<String, dynamic>? jsonData;
  Map<String, dynamic>? jsonDatas;



  Future getData({required var gstNo}) async {
    var headers = {'Content-Type': 'application/json; charset=utf-8'};
    http.Response? response = await http.get(
        Uri.parse(
            'https://sheet.gstincheck.co.in/check/fa577b6448c25370013bdc0649eed53e/$gstNo'),
        headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        jsonData = json.decode(response.body);
      });
      print(jsonData!['message']);

      if (jsonData!['flag'] == true) {
        addCustomer();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${jsonData!['message']}')));
        Navigator.pop(context);
        _customerName.clear();
        _customerAddress.clear();
        _customerContactNo.clear();
        _customerGstNo.clear();
        _customerPanNo.clear();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${jsonData!['message']}')));
      }
      print('+++++++++++=response=+++++++++++++++${jsonData}');
      return jsonData;
    } else {
      return null;
    }
  }

  Future getDataForPan({required var panNo}) async {
    // var headers = {'Content-Type': 'application/json'};
    var body = {"api_key": "fa577b6448c25370013bdc0649eed53e", "pan": "$panNo"};
    http.Response? response = await http.post(
        Uri.parse('https://sheet.gstincheck.co.in/check/pan'),
       // headers: headers,
        body: body);
    if (response.statusCode == 200) {
      setState(() {
        jsonDatas = json.decode(response.body);
      });
      print(jsonDatas!['message']);

      if (jsonDatas!['flag'] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${jsonDatas!['message']}')));
        // Navigator.pop(context);
        _customerName.clear();
        _customerAddress.clear();
        _customerContactNo.clear();
        _customerGstNo.clear();
        _customerPanNo.clear();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${jsonDatas!['message']}')));
      }
      print('+++++++++++=response=+++++++++++++++${jsonDatas}');
      return jsonDatas;
    } else {
      return null;
    }
  }

  Future<void> addCustomer() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(kFirebaseAuth.currentUser!.uid)
        .collection("customers")
        .add({
      "customer_name": _customerName.text,
      "customer_address": _customerAddress.text,
      "customer_contact_no": _customerContactNo.text,
      "customer_gst_no": _customerGstNo.text,
      "customer_pan_no": _customerPanNo.text,
    });
  }

  GstVeriFicationController gstVeriFicationController =
      Get.put(GstVeriFicationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 8,
        backgroundColor: kPrimarycolor,
        toolbarHeight: 65,
        title: const Text(
          "Manage Customers",
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
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15),
              child: TextButton(
                child: Text(
                  "ADD NEW",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return GetBuilder<GstVeriFicationController>(
                        builder: (controller) {
                          return AlertDialog(scrollable: true,
                            title: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text("Add Customer"),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  TextFieldWidget(validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*field can not be empty";
                                    }
                                  },
                                    prefixIcon: Icon(Icons.person_outline),
                                    keyboardType: TextInputType.name,
                                    controller: _customerName,
                                    hintText: "Customer Name",
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  TextFieldWidget(validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*field can not be empty";
                                    }
                                  },
                                    prefixIcon: Icon(Icons.add_road),
                                    controller: _customerAddress,
                                    hintText: "Customer Address",
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  TextFieldWidget(validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*field can not be empty";
                                    }
                                  },
                                    maxLength: 10,
                                    prefixIcon: Icon(Icons.phone),
                                    keyboardType: TextInputType.number,
                                    controller: _customerContactNo,
                                    hintText: "Customer Contact No",
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  TextFieldWidget(
                                    validator: (value) {
                                      if (gstValidator.validate(value) == true) {
                                        return null;
                                      }
                                      return "Incorrect Gst Number";
                                    },
                                    prefixIcon: Icon(Icons.analytics_outlined),
                                    maxLength: 15,
                                    controller: _customerGstNo,
                                    hintText: "GST No",
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  TextFieldWidget(
                                    validator: (value) {
                                      if (panValidator.validate(value) == true) {
                                        return null;
                                      }
                                      return "Incorrect panCard Number";
                                    },
                                    prefixIcon:
                                        Icon(Icons.confirmation_num_outlined),
                                    maxLength: 10,
                                    controller: _customerPanNo,
                                    hintText: "PAN No",
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _customerName.clear();
                                  _customerAddress.clear();
                                  _customerContactNo.clear();
                                  _customerGstNo.clear();
                                  _customerPanNo.clear();
                                },
                                child: Text("Cancel"),
                                color: Colors.red,
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // await controller
                                    //     .gstVeriFicationController();
                                    //
                                    // if (controller
                                    //         .getNotificationListApiResponse
                                    //         .status ==
                                    //     Status.LOADING) {
                                    //   Center(
                                    //       child: CircularProgressIndicator());
                                    // }
                                    // if (controller
                                    //         .getNotificationListApiResponse
                                    //         .status ==
                                    //     Status.ERROR) {
                                    //   Center(child: Text('ERROR'));
                                    // }
                                    // GstVerificationModel response = controller
                                    //     .getNotificationListApiResponse.data;
                                    // if (controller
                                    //         .getNotificationListApiResponse
                                    //         .status ==
                                    //     Status.COMPLETE) {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(SnackBar(
                                    //           content:
                                    //               Text(response.data.sts)));
                                    // }
                                    // await getData(gstNo: _customerGstNo.text);
                                    // await getDataForPan(
                                    //     panNo: _customerPanNo.text);
                                    addCustomer();
                                    _customerName.clear();
                                    _customerAddress.clear();
                                    _customerContactNo.clear();
                                    _customerGstNo.clear();
                                    _customerPanNo.clear();
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text("Add"),
                                color: Colors.green,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              )),
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
                  prefixIcon: Icon(Icons.search),
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
                  .collection("customers")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> _customers = snapshot.data!.docs;
                  if (searchText.isNotEmpty) {
                    _customers = _customers.where((element) {
                      return element
                          .get('customer_name')
                          .toString()
                          .toLowerCase()
                          .contains(searchText.toLowerCase());
                    }).toList();
                  }

                  return Theme(
                    data: Theme.of(context).copyWith(
                      scrollbarTheme: ScrollbarThemeData(
                        radius: Radius.circular(10),
                        thickness: MaterialStateProperty.all(5),
                        minThumbLength: 10,
                        thumbColor: MaterialStateProperty.all(kPrimarycolor),
                      ),
                    ),
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: _customers.length,
                        itemBuilder: (context, index) {



                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 7,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    SelectableText(
                                    "${_customers[index].get("customer_name")}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    "${_customers[index].get("customer_address")}",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${_customers[index].get("customer_contact_no")}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "GST No: ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "${_customers[index].get("customer_gst_no")}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "PAN No: ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "${_customers[index].get("customer_pan_no")}",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                              "Update Customer"),
                                                          SizedBox(
                                                            height: 2.h,
                                                          ),
                                                          TextFieldWidget(
                                                            prefixIcon: Icon(Icons
                                                                .person_outline),
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            controller:
                                                                _customerName,
                                                            hintText:
                                                                "Customer Name",
                                                          ),
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          TextFieldWidget(
                                                            prefixIcon: Icon(
                                                                Icons.add_road),
                                                            controller:
                                                                _customerAddress,
                                                            hintText:
                                                                "Customer Address",
                                                          ),
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          TextFieldWidget(
                                                            maxLength: 10,
                                                            prefixIcon: Icon(
                                                                Icons.phone),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            controller:
                                                                _customerContactNo,
                                                            hintText:
                                                                "Customer Contact No",
                                                          ),
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          TextFieldWidget(
                                                            prefixIcon: Icon(Icons
                                                                .analytics_outlined),
                                                            maxLength: 15,
                                                            controller:
                                                                _customerGstNo,
                                                            hintText: "GST No",
                                                          ),
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          TextFieldWidget(
                                                            prefixIcon: Icon(Icons
                                                                .confirmation_num_outlined),
                                                            maxLength: 10,
                                                            controller:
                                                                _customerPanNo,
                                                            hintText: "PAN No",
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      MaterialButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          _customerName.clear();
                                                          _customerAddress
                                                              .clear();
                                                          _customerContactNo
                                                              .clear();
                                                          _customerGstNo
                                                              .clear();
                                                          _customerPanNo
                                                              .clear();
                                                        },
                                                        child: Text("Cancel"),
                                                        color: Colors.red,
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "users")
                                                                .doc(
                                                                    "${kFirebaseAuth.currentUser!.uid}")
                                                                .collection(
                                                                    "customers")
                                                                .doc(
                                                                    "${_customers[index].id}")
                                                                .update({
                                                              "customer_name":
                                                                  _customerName
                                                                      .text,
                                                              "customer_address":
                                                                  _customerAddress
                                                                      .text,
                                                              "customer_contact_no":
                                                                  _customerContactNo
                                                                      .text,
                                                              "customer_gst_no":
                                                                  _customerGstNo
                                                                      .text,
                                                              "customer_pan_no":
                                                                  _customerPanNo
                                                                      .text,
                                                            });
                                                            _customerName
                                                                .clear();
                                                            _customerAddress
                                                                .clear();
                                                            _customerContactNo
                                                                .clear();
                                                            _customerGstNo
                                                                .clear();
                                                            _customerPanNo
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                        child: Text("Update"),
                                                        color: Colors.green,
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Do you want to delete this customer?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("NO"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "users")
                                                                .doc(
                                                                    "${kFirebaseAuth.currentUser!.uid}")
                                                                .collection(
                                                                    "customers")
                                                                .doc(
                                                                    "${_customers[index].id}")
                                                                .delete();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("YES"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.grey,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          // Card(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   elevation: 10,
          //   margin: EdgeInsets.all(20),
          //   child: Padding(
          //     padding: const EdgeInsets.all(15),
          //     child: Column(
          //       children: [
          //         Row(
          //           children: [
          //             Text(
          //               "Maulik Patel",
          //               style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold),
          //             ),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 1.h,
          //         ),
          //         Column(
          //           children: [
          //             Text(
          //               "1127, Sargam Society, Varacha, Punagam, Surat,Pin- 395010",
          //               style: TextStyle(
          //                   color: Colors.grey,
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.bold),
          //             ),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 1.h,
          //         ),
          //         Row(
          //           children: [
          //             Text(
          //               "7041857767",
          //               style: TextStyle(
          //                   color: Colors.grey,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold),
          //             ),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 1.h,
          //         ),
          //         Row(
          //           children: [
          //             Text(
          //               "GST No: ",
          //               style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w500),
          //             ),
          //             Text(
          //               "87987867876776",
          //               style: TextStyle(
          //                   color: Colors.grey,
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w500),
          //             ),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 1.h,
          //         ),
          //         Row(
          //           children: [
          //             Text(
          //               "PAN No: ",
          //               style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w500),
          //             ),
          //             Text(
          //               "AGMNOQ8MN6",
          //               style: TextStyle(
          //                   color: Colors.grey,
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w500),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
