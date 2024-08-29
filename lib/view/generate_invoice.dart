import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/controller/add_customer_controller.dart';
import 'package:invoice_generator/controller/add_product_controller.dart';
import 'package:invoice_generator/model/customer.dart';
import 'package:invoice_generator/model/invoice.dart';
import 'package:invoice_generator/model/supplier.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../constant/constant.dart';
import '../pdf_services/pdf_template_1.dart';
import '../pdf_services/pdf_services.dart';
import 'choose_customers.dart';

class GenerateInvoice extends StatefulWidget {
  final qty;
  final customerName;
  final customerAddress;
  final contactNumber;
  final gstNo;
  final panNo;

  const GenerateInvoice(
      {Key? key,
      this.qty,
      this.customerName,
      this.customerAddress,
      this.contactNumber,
      this.gstNo,
      this.panNo})
      : super(key: key);
  @override
  _GenerateInvoiceState createState() => _GenerateInvoiceState();
}

class _GenerateInvoiceState extends State<GenerateInvoice> {
  String? quantity;
  final _formKey = GlobalKey<FormState>();

  final _supplierName = TextEditingController();
  final _supplierAddress = TextEditingController();
  final _paymentInfo = TextEditingController();
  // final _customerName = TextEditingController();
  // final _customerAddress = TextEditingController();
  final _vatTax = TextEditingController();

  String? downloadUrl;

  String? pdfUrl;

  String noImageUrl =
      "https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101027/112815900-no-image-available-icon-flat-vector.jpg?ver=6";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddProductController>(context, listen: false);
    final provider1 =
        Provider.of<AddCustomerController>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final date = DateTime.now();
          final dueDate = date.add(
            const Duration(days: 7),
          );
          final invoice = Invoice(
            supplier: Supplier(
              name: _supplierName.text,
              address: _supplierAddress.text,
              paymentInfo: _paymentInfo.text,
            ),
            customer: Customer(
              name: widget.customerName,
              address: widget.customerAddress,
            ),
            info: InvoiceInfo(
              date: date,
              dueDate: dueDate,
              description: 'My description...',
              number: '${DateTime.now().second}',
            ),
            items: List.generate(
              provider1.customerInfo.isNotEmpty
                  ? provider1.customerInfo.length
                  : provider.productName.length,
              (index) => InvoiceItem(
                description: "Hii",
                date: DateTime.now(),
                quantity: provider1.customerInfo[index],
                vat: double.parse(_vatTax.text) / 100,
                unitPrice: double.parse(provider.priceInfo[index]),
              ),
            ),
          );
          final pdfFile = await PdfTemplate1.generate(invoice);
          PdfServices.openFile(pdfFile);

          Future<String?> uploadPdfToFirebase(
              {required BuildContext context,
              required String fileName,
              required File file}) async {
            try {
              print('-----file path-------${file.path}');

              var response = await firebase_storage.FirebaseStorage.instance
                  .ref('Invoices/${DateTime.now().microsecondsSinceEpoch}')
                  .putFile(file);
              print("Response>>>>>>>>>>>>>>>>>>$response");

              downloadUrl = await response.ref.getDownloadURL();

              return downloadUrl;
            } catch (e) {
              print(e);
            }
            return null;
          }

          if (pdfFile != null) {
            pdfUrl = await uploadPdfToFirebase(
                context: context,
                file: pdfFile,
                fileName: '${kFirebaseAuth.currentUser!.email}_invoice.pdf');
          }

          FirebaseFirestore.instance
              .collection("users")
              .doc(kFirebaseAuth.currentUser!.uid)
              .collection("invoice_list")
              .add({
            'invoice_no': "${Random().nextInt(1000)}",
            "date":
                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
            "customer_name": "${widget.customerName}",
            "invoice_name":
                "${widget.customerName}${Random().nextInt(1000000)}.pdf",
            'pdfUrl': downloadUrl ?? noImageUrl,
          }).catchError(
            // ignore: invalid_return_type_for_catch_error
            (e) => print('Error ===========>>> $e'),
          );

          print("Download Url===>>>$downloadUrl");
        },
        backgroundColor: kPrimarycolor,
        child: const Icon(
          Icons.arrow_forward,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Supplier Information",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    height: 6.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: TextField(
                        controller: _supplierName,
                        decoration: const InputDecoration(
                          hintText: "Supplier name",
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
                        controller: _supplierAddress,
                        decoration: const InputDecoration(
                          hintText: "Supplier address",
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
                        controller: _paymentInfo,
                        decoration: const InputDecoration(
                          hintText: "Payment Method",
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
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter tax percentage ";
                          }
                        },
                        controller: _vatTax,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Tax %",
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffE4E4E4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Customer Information",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  if (widget.customerName == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChooseCustomers(),
                              ),
                            );
                          },
                          color: kPrimarycolor,
                          child: const Text(
                            "Choose Customer",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  else
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.customerName ?? "no data",
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
                                  widget.customerAddress ?? "no data",
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
                                  widget.contactNumber ?? "no data",
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
                                  widget.gstNo ?? "no data",
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
                              children: [
                                Text(
                                  "PAN No: ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  widget.panNo ?? "no data",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 2.h,
                  ),

                  SizedBox(
                    height: 2.h,
                  ),
                  // SizedBox(
                  //   height: 6.h,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(12),
                  //     child: TextField(
                  //       controller: _customerName,
                  //       decoration: InputDecoration(
                  //         hintText: "Customer name",
                  //         border: InputBorder.none,
                  //         filled: true,
                  //         fillColor: Color(0xffE4E4E4),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 1.5.h,
                  // ),
                  // SizedBox(
                  //   height: 6.h,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(12),
                  //     child: TextField(
                  //       controller: _customerAddress,
                  //       decoration: InputDecoration(
                  //         hintText: "Customer address",
                  //         border: InputBorder.none,
                  //         filled: true,
                  //         fillColor: Color(0xffE4E4E4),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),

                  // Page //
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
