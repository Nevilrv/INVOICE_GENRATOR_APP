import 'package:firebase_auth/firebase_auth.dart';
import 'package:invoice_generator/constant/constant.dart';

class FirebaseAuthRepo {
  static Future<User?> signUp(
      String name, String email, String password) async {
    try {
      User? user = (await kFirebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        print('SignUp Successful');
        user.updateProfile(displayName: name);
        return user;
      } else {
        print('SignUp Failed');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> logIn(String email, String password) async {
    try {
      User? user = (await kFirebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        print('logIn Successful');

        return user;
      } else {
        print('LogIn Failed');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future currentUser() async {
    print('user id===>>>${kFirebaseAuth.currentUser!.uid}');
    print('email id===>>>${kFirebaseAuth.currentUser!.email}');
  }

  static Future logOut() async {
    await kFirebaseAuth.signOut();
  }
}
