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
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  /**
  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: () async => false,
      child:Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/login_bg_gif.gif"),
            fit: BoxFit.cover,
          ),
        ),

        child: Scaffold (
          appBar: AppBar(
            title: Text('Login', style: TextStyle(color: Colors.yellow)),
          ),
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,

            // Login Form created here: Text fields and buttons
            child: Column(
              // Align text fields to center of page
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,

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
                    obscureText: true,
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
          )
        ),
      )
    );
  } // Widget */

   @override
  Widget build(BuildContext context) {
    
    final emailField = TextField(
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        enabledBorder: const OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: const BorderSide(color: Colors.grey, width: 2.0,),

          // circular border
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        border: const OutlineInputBorder(),
        labelStyle: new TextStyle(color: Colors.green),
        prefixIcon: Icon(Icons.email, color: Colors.pink[100]),
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white),
    ));
    
    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          enabledBorder: const OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: const BorderSide(color: Colors.grey, width: 2.0,),

            // circular border
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          prefixIcon: Icon(Icons.lock, color: Colors.pink[100]),
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.white),
    ));
    
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bgimg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 70.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
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