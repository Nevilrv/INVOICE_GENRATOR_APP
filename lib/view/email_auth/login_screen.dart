import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoice_generator/common/button_widget.dart';
import 'package:invoice_generator/common/textfield_widget.dart';
import 'package:invoice_generator/constant/constant.dart';
import 'package:invoice_generator/repo/firebase_service.dart';
import 'package:invoice_generator/sharedpreference_services/shared_prefs_service.dart';
import 'package:invoice_generator/view/email_auth/register_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _passWord = TextEditingController();

  bool isLoading = false;
  bool _isObscured = true;

  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading == true
          ? Container(
              child: const Center(child: CircularProgressIndicator()),
            )
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
                      children: <Widget>[
                        Text(
                          "Sign in",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Welcome Back",
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
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: screenSize.height * 0.05,
                              ),
                              TextFieldWidget(
                                keyboardType: TextInputType.emailAddress,
                                hintText: "Email",
                                controller: _email,
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              SizedBox(
                                height: screenSize.height * 0.03,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "*password can not be empty";
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
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off_rounded),
                                  ),
                                  prefixIcon: Icon(Icons.lock_outline_rounded),
                                  hintText: "password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimarycolor, width: 1),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenSize.height * 0.08,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    FirebaseAuthRepo.logIn(
                                            _email.text, _passWord.text)
                                        .then((result) async {
                                      if (result != null) {
                                        SharedPrefManager.setUserName(
                                            userName: _email.text);
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();

                                        log("=====>>>>${kFirebaseAuth.currentUser!.uid}");

                                        prefs.setString('name', _email.text);
                                        setState(() {
                                          isLoading = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text("Successfully SignIn"),
                                            ),
                                          );
                                        });
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BottomNavScreen(
                                              index: 0,
                                            ),
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
                                                "'Login Failed', 'Invalid email or password'"),
                                          ),
                                        );

                                        print('LogIn Failed');
                                      }
                                    });
                                  }
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
                                    child: Center(
                                        child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: kPrimarycolor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: ButtonWidget(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ),
                                    );
                                  },
                                  title: "Create Account ",
                                ),
                              ),
                            ],
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
