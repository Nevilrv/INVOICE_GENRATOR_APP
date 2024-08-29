// import 'dart:developer';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:country_state_city_picker/country_state_city_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:invoice_generator/common/textfield_widget.dart';
// import 'package:invoice_generator/constant/constant.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'bottom_nav_bar.dart';
//
// class BusinessDetails extends StatefulWidget {
//   @override
//   _BusinessDetailsState createState() => _BusinessDetailsState();
// }
//
// class _BusinessDetailsState extends State<BusinessDetails> {
//   String? _dropDownValue;
//
//   String? countryValue;
//   String? stateValue;
//   String? cityValue;
//
//   final _house = TextEditingController();
//   final _street = TextEditingController();
//   final _pinCode = TextEditingController();
//   final _gstNumber = TextEditingController();
//   File? _image;
//   File? _image1;
//
//   final picker = ImagePicker();
//
//   /// getImage Function
//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         imageCache!.clear();
//       } else {
//         print("no Image selected");
//       }
//     });
//   }
//
//   Future getImage1() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image1 = File(pickedFile.path);
//         imageCache!.clear();
//       } else {
//         print("no Image selected");
//       }
//     });
//   }
//
//   clearImage() {
//     setState(() {
//       print("remove:$_image");
//       _image = null;
//     });
//   }
//
//   Future<String?> uploadImageToFirebase(
//       {required BuildContext context,
//       required String fileName,
//       required File file}) async {
//     try {
//       var response = await firebase_storage.FirebaseStorage.instance
//           .ref('uploads/$fileName')
//           .putFile(file);
//       print("Response>>>>>>>>>>>>>>>>>>$response");
//       return response.storage.ref('uploads/$fileName').getDownloadURL();
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   String? imageUrl;
//   String noImageUrl =
//       "https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101027/112815900-no-image-available-icon-flat-vector.jpg?ver=6";
//
//   bool isLoading = false;
//
//   Future<void> addData() async {
//     if (_image != null) {
//       imageUrl = await uploadImageToFirebase(
//           context: context,
//           file: _image!,
//           fileName: '${kFirebaseAuth.currentUser!.email}_profile.jpg');
//     }
//
//     FirebaseFirestore.instance
//         .collection("users")
//         .doc(kFirebaseAuth.currentUser!.uid)
//         .collection("business_info")
//         .add({
//           'house': _house.text,
//           'street': _street.text,
//           'pincode': _pinCode.text,
//           "country": countryValue,
//           "state": stateValue,
//           'city': cityValue,
//           'category': _dropDownValue,
//           "gst_number": _gstNumber.text,
//           'imageProfile': imageUrl == null ? noImageUrl : imageUrl,
//         })
//         .catchError(
//           // ignore: invalid_return_type_for_catch_error
//           (e) => log('Error ===========>>> $e'),
//         )
//         .then((value) {
//           setState(() {
//             isLoading = false;
//           });
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) {
//                 return BottomNavScreen(
//                   index: 0,
//                 );
//               },
//             ),
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade300,
//         body: isLoading
//             ? Container(
//                 child: Center(child: CircularProgressIndicator()),
//               )
//             : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Container(
//                       height: screenSize.height * 0.25,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                       ),
//                       child: _image == null
//                           ? Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   height: screenSize.height * 0.07,
//                                 ),
//                                 const Text(
//                                   "Add cover image",
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                                 SizedBox(
//                                   height: screenSize.height * 0.08,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 20),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           getImage();
//                                         },
//                                         child: CircleAvatar(
//                                           radius: 23,
//                                           backgroundColor: Colors.black54,
//                                           child: Center(
//                                             child: SvgPicture.asset(
//                                               "assets/images/camera.svg",
//                                               height: 23,
//                                               width: 23,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Image.file(
//                               _image!,
//                               fit: BoxFit.cover,
//                             ),
//                     ),
//                     Stack(
//                       overflow: Overflow.visible,
//                       children: [
//                         Container(
//                           alignment: Alignment.bottomCenter,
//                           height: screenSize.height * 0.711,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(30),
//                               topRight: Radius.circular(30),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 36, right: 36, top: 80),
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Business Details",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 23,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.02,
//                                   ),
//                                   Container(
//                                     height: screenSize.height * 0.07,
//                                     width: double.infinity,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey.shade300,
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Center(
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 20),
//                                         child: DropdownButton(
//                                           hint: _dropDownValue == null
//                                               ? Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(10),
//                                                   child:
//                                                       Text('Choose category'),
//                                                 )
//                                               : Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(10),
//                                                   child: Text(
//                                                     _dropDownValue!,
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 17),
//                                                   ),
//                                                 ),
//                                           underline: SizedBox(),
//                                           isExpanded: true,
//                                           iconSize: 30,
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 16),
//                                           items: [
//                                             "Fashion",
//                                             "Food",
//                                             "Grocery",
//                                             "Electronics",
//                                             "Appliances",
//                                             "Sports",
//                                             "Home decor",
//                                             "Furniture",
//                                             "Personal care",
//                                             "Fruits and Vegetables",
//                                             "Meat, fish and egg",
//                                             "Plants and gardening tools"
//                                           ].map(
//                                             (val) {
//                                               return DropdownMenuItem<String>(
//                                                 value: val,
//                                                 child: Text(val),
//                                               );
//                                             },
//                                           ).toList(),
//                                           onChanged: (val) {
//                                             setState(
//                                               () {
//                                                 _dropDownValue = val as String?;
//                                                 print(_dropDownValue);
//                                               },
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.03,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Business Address",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 23,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.02,
//                                   ),
//                                   SelectState(
//                                     dropdownColor: Colors.grey.shade300,
//                                     onCountryChanged: (value) {
//                                       setState(() {
//                                         countryValue = value;
//                                       });
//                                     },
//                                     onStateChanged: (value) {
//                                       setState(() {
//                                         stateValue = value;
//                                       });
//                                     },
//                                     onCityChanged: (value) {
//                                       setState(() {
//                                         cityValue = value;
//                                       });
//                                     },
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.02,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "GST Details",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 23,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.03,
//                                   ),
//                                   TextFieldWidget(
//                                     keyboardType: TextInputType.number,
//                                     maxLength: 15,
//                                     hintText: "GST Number",
//                                     controller: _gstNumber,
//                                     prefixIcon: Icon(Icons.analytics_outlined),
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.03,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Pickup Address",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 23,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.03,
//                                   ),
//                                   TextFieldWidget(
//                                     keyboardType: TextInputType.name,
//                                     hintText: "House / Building Name",
//                                     controller: _house,
//                                     prefixIcon: Icon(Icons.home_outlined),
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.03,
//                                   ),
//                                   TextFieldWidget(
//                                     keyboardType: TextInputType.name,
//                                     hintText: "Street",
//                                     controller: _street,
//                                     prefixIcon: Icon(Icons.edit_road),
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.03,
//                                   ),
//                                   TextFieldWidget(
//                                     keyboardType: TextInputType.number,
//                                     hintText: "Pincode / Zipcode",
//                                     controller: _pinCode,
//                                     prefixIcon:
//                                         Icon(Icons.location_on_outlined),
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.03,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             isLoading = true;
//                                           });
//                                           addData();
//                                         },
//                                         child: CircleAvatar(
//                                           radius: 30,
//                                           backgroundColor: kPrimarycolor,
//                                           child: Icon(
//                                             Icons.arrow_forward,
//                                             color: Colors.white,
//                                             size: 40,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: screenSize.height * 0.02,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: -80,
//                           left: 40,
//                           child: Container(
//                             height: screenSize.height * 0.16,
//                             width: screenSize.height * 0.16,
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade300,
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(color: Colors.white, width: 2),
//                             ),
//                             child: _image1 == null
//                                 ? Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 15, vertical: 23),
//                                         child: Text(
//                                           "Add profile Image/Logo",
//                                           style: TextStyle(fontSize: 16),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : ClipRRect(
//                                     borderRadius: BorderRadius.circular(20),
//                                     child: Image.file(
//                                       _image1!,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         Positioned(
//                           left: 140,
//                           top: 13,
//                           child: GestureDetector(
//                             onTap: () {
//                               getImage1();
//                             },
//                             child: CircleAvatar(
//                               radius: 23,
//                               backgroundColor: Colors.black54,
//                               child: Center(
//                                 child: SvgPicture.asset(
//                                   "assets/images/camera.svg",
//                                   height: 23,
//                                   width: 23,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
