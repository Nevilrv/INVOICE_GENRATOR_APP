import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../common/textfield2.dart';
import '../constant/constant.dart';
import 'generate_invoice.dart';

class ChooseCustomers extends StatefulWidget {
  const ChooseCustomers({Key? key}) : super(key: key);

  @override
  _ChooseCustomersState createState() => _ChooseCustomersState();
}

class _ChooseCustomersState extends State<ChooseCustomers> {
  final TextEditingController _searchController = TextEditingController();

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        backgroundColor: kPrimarycolor,
        toolbarHeight: 65,
        title: const Text(
          "Choose Customers",
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
                        radius: const Radius.circular(10),
                        thickness: MaterialStateProperty.all(5),
                        minThumbLength: 10,
                        thumbColor: MaterialStateProperty.all(kPrimarycolor),
                      ),
                    ),
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: _customers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenerateInvoice(
                                    customerName:
                                        "${_customers[index].get("customer_name")}",
                                    customerAddress:
                                        "${_customers[index].get("customer_address")}",
                                    contactNumber:
                                        "${_customers[index].get("customer_contact_no")}",
                                    gstNo:
                                        "${_customers[index].get("customer_gst_no")}",
                                    panNo:
                                        "${_customers[index].get("customer_pan_no")}",
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 7,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SelectableText(
                                          "${_customers[index].get("customer_name")}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "${_customers[index].get("customer_address")}",
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
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
                                          "${_customers[index].get("customer_contact_no")}",
                                          style: const TextStyle(
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
                                        const Text(
                                          "GST No: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "${_customers[index].get("customer_gst_no")}",
                                          style: const TextStyle(
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
                                            const Text(
                                              "PAN No: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "${_customers[index].get("customer_pan_no")}",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
}
