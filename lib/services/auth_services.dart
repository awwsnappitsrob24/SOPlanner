import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vivi_bday_app/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthServices {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login function to authenticate users using Firebase
  Future<void> login(String _email, String _password) async {
    await _auth.signInWithEmailAndPassword
      (email: _email, password: _password);
  }

  // Function to log user out of the application and revoke authentication
  Future<void> logout() async {
    await _auth.signOut();
  }

  // To do: register, update password
}