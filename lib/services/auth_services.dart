import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:vivi_bday_app/models/user.dart' as user;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  // Login function to authenticate users using Firebase
  Future<void> login(String _email, String _password) async {
    await _auth.signInWithEmailAndPassword(email: _email, password: _password);
  }

  // Function to log user out of the application and revoke authentication
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Function to register a user for the app and store their info to Firebase
  Future<void> register(
      user.User newUser, String _email, String _password) async {
    await _auth.createUserWithEmailAndPassword(
        email: _email, password: _password);

    await FirebaseFirestore.instance.collection("users").add({
      'firstName': newUser.firstName,
      'lastName': newUser.lastName,
      'email': newUser.email,
      'uniqueID': newUser.uniqueID,
    });
  }
}
