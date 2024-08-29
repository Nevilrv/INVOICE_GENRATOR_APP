import 'package:flutter/material.dart';
import 'package:invoice_generator/common/button_widget.dart';
import 'package:invoice_generator/common/textfield_widget.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/repo/firebase_service.dart';
import 'package:invoice_generator/sharedpreference_services/shared_prefs_service.dart';
import 'package:invoice_generator/view/bottom_nav_bar.dart';
import 'package:invoice_generator/view/google_auth/google_sign_in_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../business_details.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscured = true;

  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _businessName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _passWord = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: isLoading == true
          ? Center(child: const CircularProgressIndicator())
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kPrimarycolor,
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   colors: [
                //     Colors.orange.shade900,
                //     Colors.orange.shade800,
                //     Colors.orange.shade400
                //   ],
                // ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.height * 0.08,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Create a new Account",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.022,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: screenSize.height * 0.05,
                                ),
                                TextFieldWidget(
                                  keyboardType: TextInputType.name,
                                  hintText: "Name",
                                  controller: _name,
                                  prefixIcon: const Icon(
                                    Icons.person_outlined,
                                    //color: Color(0xff2ECC71),
                                  ),
                                ),
                                SizedBox(
                                  height: screenSize.height * 0.03,
                                ),
                                TextFieldWidget(
                                  keyboardType: TextInputType.name,
                                  hintText: "Business name",
                                  controller: _businessName,
                                  prefixIcon: const Icon(
                                      Icons.business_center_outlined),
                                ),
                                SizedBox(
                                  height: screenSize.height * 0.03,
                                ),
                                TextFieldWidget(
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: "Email",
                                  controller: _email,
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                                SizedBox(
                                  height: screenSize.height * 0.03,
                                ),
                                TextFieldWidget(
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  hintText: "Phone",
                                  controller: _phone,
                                  prefixIcon: const Icon(Icons.phone),
                                ),
                                SizedBox(
                                  height: screenSize.height * 0.03,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*password can not be empty";
                                    } else if (value.length < 6) {
                                      return "password must be  at least 6 digit ";
                                    }
                                  },
                                  obscureText: _isObscured,
                                  controller: _passWord,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isObscured = !_isObscured;
                                        });
                                      },
                                      icon: _isObscured
                                          ? const Icon(Icons.visibility)
                                          : const Icon(
                                              Icons.visibility_off_rounded),
                                    ),
                                    prefixIcon:
                                        const Icon(Icons.lock_outline_rounded),
                                    hintText: "password",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimarycolor, width: 1),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenSize.height * 0.04,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: ButtonWidget(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        setState(() {
                                          isLoading = true;
                                        });
                                        FirebaseAuthRepo.signUp(_name.text,
                                                _email.text, _passWord.text)
                                            .then(
                                          (result) {
                                            if (result != null) {
                                              userCollection
                                                  .doc(kFirebaseAuth
                                                      .currentUser!.uid)
                                                  .set({
                                                "name": _name.text,
                                                "business_name":
                                                    _businessName.text,
                                                "email": _email.text,
                                                "phone": _phone.text,
                                                "password": _passWord.text
                                              });
                                              SharedPrefManager.setUserName(
                                                  userName: _email.text);
                                              prefs.setString(
                                                  'name', _email.text);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Successfully Registered"),
                                                  duration: Duration(
                                                      milliseconds: 700),
                                                ),
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BottomNavScreen(
                                                          index: 0),
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Registration Failed"),
                                                ),
                                              );
                                              print('SignUp Failed');
                                            }
                                          },
                                        );
                                      }
                                    },
                                    title: "Create Account",
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                const Text(
                                  "OR",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                InkWell(
                                  onTap: () {
                                    signInWithGoogle().then((value) {
                                      if (value.isNotEmpty) {
                                        SharedPrefManager.setUserName(
                                          userName: name.toString(),
                                        );
                                        userCollection
                                            .doc(kFirebaseAuth.currentUser!.uid)
                                            .set({
                                          "name": name.toString(),
                                          "email": email.toString(),
                                        }).catchError(
                                          (e) {
                                            print("Set error===>>$e");
                                          },
                                        ).then(
                                          (value) => Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const BottomNavScreen(
                                                      index: 0),
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Something went wrong!"),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    child: Container(
                                      height: screenSize.height * 0.07,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: kPrimarycolor, width: 1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/google.png",
                                            height: 35,
                                            width: 35,
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Text(
                                            "Continue with Google",
                                            style: TextStyle(
                                                color: kPrimarycolor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// extension EmailValidator on String {
//   bool isValidEmail() {
//     return RegExp(
//             r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
//         .hasMatch(this);
//   }
// }
