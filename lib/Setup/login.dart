import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vivi_bday_app/pages/homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login', style: TextStyle(color: Colors.white)),
        ),

        body: Form (
          key: _formKey,
            // Align text fields to center of page
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.center,

          // Login Form created here: Text fields and buttons
          child: Column(
            children: <Widget>[
              // TextFormField for Email
              TextFormField (
                validator: (input) {
                  if(input.isEmpty) {
                    return 'Email cannot be empty.';
                  }
                },
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                   borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0)
                   ),
                  ),
                  contentPadding: new EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
                  filled: true,
                  hintText: 'Email',
                  hintStyle: TextStyle(fontSize: 20.0 , color: Colors.grey[700]),
                  fillColor: Colors.white70,
                ),
              ),

              TextFormField (
                validator: (input) {
                  if(input.isEmpty) {
                    return 'Password cannot be empty.';
                  }
                },
                onSaved: (input) => _password = input,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0)
                    ),
                  ),
                  contentPadding: new EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
                  filled: true,
                  hintText: 'Password',
                  hintStyle: TextStyle(fontSize: 20.0 , color: Colors.grey[700]),
                  fillColor: Colors.white70,
                ),
              ),

              // Log in Button
              RaisedButton(
                onPressed: login,
                child: Text('Log In'), color: Colors.deepPurple[100],
              ),

            ]
          )
        ),
      );
  }

  Future<void> login() async {
    // Validate fields
    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        // Create user
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword
          (email: _email, password: _password);

        // If login is successful, go to homepage
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
      } catch(e) {
        // Error message
        print(e.message);
      }

    }
  }
}