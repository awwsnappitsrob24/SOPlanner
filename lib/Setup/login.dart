import 'package:flutter/material.dart';
import 'package:vivi_bday_app/models/user.dart';
import 'package:vivi_bday_app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vivi_bday_app/pages/homepage.dart';
import 'package:vivi_bday_app/pages/register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {  
  int userID;

  LoginPage({Key key, this.userID}): super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password, userFName, userLName, userEmail;
  int userID;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthServices auth = AuthServices();
  final currentUser = User();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);


   @override
  Widget build(BuildContext context) {
    
    /// Email TextField
    /// - Cannot be empty
    /// - Rounded border
    /// - Pink prefix icon
    /// - White text and hint text
    final emailField = TextFormField(
      key: Key('emailtextformfield'),
      validator: (input) {
        if(input.isEmpty) {
          return 'Email cannot be empty.'; // empty check
        }
      },
      onSaved: (input) {
        setState(() {
          _email = input;
        });
      }, // save user input into variable for authentication
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(
          // border features
          borderSide: BorderSide(color: Colors.grey, width: 2.0,),

          // circular border
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        filled: true,
        prefixIcon: Icon(Icons.email, color: Colors.pink[100]),
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white),
    ));
    

    /// Password TextField
    /// - Cannot be empty
    /// - Rounded border
    /// - Pink prefix icon
    /// - White text and hint text
    final passwordField = TextFormField(
      key: Key('passwordtextformfield'),
      validator: (input) {
        if(input.isEmpty) {
          return 'Password cannot be empty.'; // empty check
        }
      },
      onSaved: (input) {
        setState(() {
          _password = input;
        });
      }, // save user input into variable for authentication
      style: style,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(
          // border features
          borderSide: BorderSide(color: Colors.grey, width: 2.0,),

          // circular border
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.pink[100]),
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.white),
    ));
  
    
    /// Login Button
    /// - Filled in blue
    /// - White text
    /// - Triggers "login" function when tapped
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        // trigger login function here
        onPressed: () {
          signIn();
        },

        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: ModalProgressHUD(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bgimg.jpg"), // background image to fit whole page
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Center (
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(36.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 155.0,
                        child: Image.asset(
                          "assets/images/logo.png", // logo of the app
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(height: 70.0), // use these sizedboxes to represent spaces between widgets
                      emailField, // email textfield that was built earlier

                      SizedBox(height: 25.0),
                      passwordField, // password textfield that was built earlier

                      SizedBox(
                        height: 35.0,
                      ),
                      loginButton, // login button that was built earlier

                      SizedBox(
                        height: 15.0,
                      ),
                      InkWell(
                        child: Text(
                          "Don't have an account? Register here",
                          style: TextStyle(color: Colors.blue[200]),
                        ),
                        onTap: () {
                          gotoRegisterPage();
                        },
                      )
                    ],
                  ),
                )
              )
            ),
          )
        ),
      inAsyncCall: _isLoading),
    );
  }

  signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        setState(() {
          _isLoading = true;
        });

        await auth.login(_email, _password);

        setState(() {
          _isLoading = false;
        });

        populateUserInfo(currentUser);
      } catch(e) {
        setState(() {
          _isLoading = false;
        });

        Fluttertoast.showToast(
          msg: "Email and/or password are incorrect.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }     
    }
  }
  
  /// Create function here to get the user's information (userID) to pass on to the homepage
  /// where the email is equal to the user's
  void populateUserInfo(currentUser) {
    Firestore.instance
    .collection('users')
    .where("email", isEqualTo: _email)
    .snapshots()
    .listen((data) => 
        data.documents.forEach((doc) {
          currentUser.email = doc['email'];
          currentUser.firstName = doc['firstName'];
          currentUser.lastName = doc['lastName'];
          currentUser.uniqueID = doc['uniqueID'];

          Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(user: currentUser)));
        }));
  }

  /// Function to go to Register page
  void gotoRegisterPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }
}