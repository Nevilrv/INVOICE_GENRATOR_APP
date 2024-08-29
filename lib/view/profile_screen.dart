import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/common/textfield2.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();

  final _businessName = TextEditingController();

  final _userName = TextEditingController();

  final _phone = TextEditingController();

  final _passWord = TextEditingController();

  // String? documentID;
  // File? _image;

  // final picker = ImagePicker();
  //
  // Future getImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       imageCache!.clear();
  //     } else {
  //       print("no Image selected");
  //     }
  //   });
  // }
  //
  // Future<String?> uploadImageToFirebase(
  //     {required BuildContext context,
  //     required String fileName,
  //     required File file}) async {
  //   try {
  //     var response = await firebase_storage.FirebaseStorage.instance
  //         .ref('uploads/$fileName')
  //         .putFile(file);
  //     print("Response>>>>>>>>>>>>>>>>$response");
  //     return response.storage.ref('uploads/$fileName').getDownloadURL();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }

  void getUserData() async {
    final user = await userCollection.doc(kFirebaseAuth.currentUser!.uid).get();
    Map<String, dynamic>? getUserData = user.data();
    _email.text = getUserData!['email'];
    _userName.text = getUserData['name'];
    _businessName.text = getUserData['business_name'];
    _phone.text = getUserData['phone'];
    _passWord.text = getUserData['password'];
    log("--->>-->>---$getUserData");
  }

  // getUserId() async {
  //   var collection = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc("${kFirebaseAuth.currentUser!.uid}")
  //       .collection('business_info');
  //   var querySnapshots = await collection.get();
  //   for (var snapshot in querySnapshots.docs) {
  //     documentID = snapshot.id; // <-- Document ID
  //     print("ID===>>>$documentID");
  //   }
  // }
  //
  // void setToken() async {
  //   documentID = await getUserId();
  // }
  //
  // String? imageUrl;

  Future<void> updateUserData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(kFirebaseAuth.currentUser!.uid)
        .update({
          'business_name': _userName.text,
          'email': _email.text,
          'name': _userName.text,
          "password": _passWord.text,
          'phone': _phone.text,
        })
        .then(
          (value) => log('----Updated Successfully-----'),
        )
        .catchError((e) => log(e));
  }

  // Future<void> updateBusinessName() async {
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(kFirebaseAuth.currentUser!.uid)
  //       .update({
  //         'business_name': _businessName.text,
  //         'phone': _phone.text,
  //     ''
  //       })
  //       .then(
  //         (value) => log('---- BusinessName Updated Successfully-----'),
  //       )
  //       .catchError((e) => log(e));
  // }

  // clearImage() {
  //   setState(() {
  //     print("remove:$_image");
  //     _image = null;
  //   });
  // }

  @override
  void initState() {
    getUserData();
    // getUserId();
    // setToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenSize.height * 0.079),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(25)),
          child: AppBar(
            titleSpacing: 25,
            backgroundColor: kPrimarycolor,
            toolbarHeight: screenSize.height * 0.077,
            title: const Text(
              "Edit Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Business Name",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _businessName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "**business name can not be empty";
                    }
                  },
                  decoration: TextFieldWidget2.textFieldwidget
                      .copyWith(hintText: "Business Name"),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Email",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFormField(
                  controller: _email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Email can not be empty";
                    }
                  },
                  decoration: TextFieldWidget2.textFieldwidget
                      .copyWith(hintText: "Email"),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Username",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  controller: _userName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*username can not be empty";
                    }
                  },
                  decoration: TextFieldWidget2.textFieldwidget
                      .copyWith(hintText: "Username"),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Mobile No",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*mobile can not be empty";
                    } else if (value.length < 10) {
                      return "mobile number must be at least 10 digit ";
                    }
                  },
                  decoration: TextFieldWidget2.textFieldwidget
                      .copyWith(hintText: "Contact No", counterText: ''),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Password",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFormField(
                  controller: _passWord,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*password can not be empty";
                    } else if (value.length < 6) {
                      return "password number must be at least 10 digit ";
                    }
                  },
                  decoration: TextFieldWidget2.textFieldwidget
                      .copyWith(hintText: "Password"),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Center(
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateUserData().then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Updated Successfully"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          _userName.clear();
                          _businessName.clear();
                          _email.clear();
                          _phone.clear();
                          _passWord.clear();
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 17, horizontal: 50),
                      child: Text(
                        "Update",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    color: kPrimarycolor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
