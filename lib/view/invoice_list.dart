import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sizer/sizer.dart';
import '../common/textfield2.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class InvoiceList extends StatefulWidget {
  const InvoiceList({Key? key}) : super(key: key);

  @override
  _InvoiceListState createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  TextEditingController _searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        backgroundColor: kPrimarycolor,
        toolbarHeight: 65,
        title: Text(
          "Invoice History",
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
        actions: [],
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
                  .doc("${kFirebaseAuth.currentUser!.uid}")
                  .collection("invoice_list")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> _invoices = snapshot.data!.docs;
                  if (searchText.length > 0) {
                    _invoices = _invoices.where((element) {
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
                        itemCount: _invoices.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 7,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Invoice No: ${_invoices[index].get("invoice_no")}",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Date: ${_invoices[index].get("date")}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${_invoices[index].get("customer_name")}",
                                        style: TextStyle(
                                            color: Colors.black,
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
                                        "${_invoices[index].get("invoice_name")}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (_) => PDFViewerFromUrl(
                                                url:
                                                    "${_invoices[index].get("pdfUrl")}",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Chip(
                                          label: Text(
                                            "View",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: kPrimarycolor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Are you sure that you want to delete this Invoice"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("NO"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection("users")
                                                          .doc(
                                                              "${kFirebaseAuth.currentUser!.uid}")
                                                          .collection(
                                                              "invoice_list")
                                                          .doc(
                                                              "${_invoices[index].id}")
                                                          .delete()
                                                          .catchError((e) {
                                                        print(
                                                            "Delete error==>>$e");
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("YES"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Chip(
                                          label: Text(
                                            "Delete",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: kPrimarycolor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Share.share(
                                              "${_invoices[index].get("pdfUrl")}");
                                        },
                                        child: Chip(
                                          label: Text(
                                            "Share",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: kPrimarycolor,
                                        ),
                                      ),
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
        ],
      ),
    );
  }
}

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimarycolor,
        title: const Text('Invoice'),
      ),
      body: const PDF().fromUrl(
        url,
        placeholder: (double progress) => Center(
          child: Text('$progress %'),
        ),
        errorWidget: (dynamic error) => Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
    );
  }
}
