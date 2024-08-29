import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//const kPrimarycolor = Colors.deepOrange;

const kPrimarycolor = Color(0xff2A1f56);

///Color(0xff2ECC71);

///# Firebase Auth:
FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;

///# Firestore Database:
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

CollectionReference userCollection = firebaseFirestore.collection('users');
