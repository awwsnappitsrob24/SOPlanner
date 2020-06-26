import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vivi_bday_app/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthServices {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login function to authenticate users using Firebase
  Future<void> login(String _email, String _password) async {
    await _auth.signInWithEmailAndPassword
      (email: _email, password: _password);
  }
}