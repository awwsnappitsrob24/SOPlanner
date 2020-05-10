import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vivi_bday_app/Setup/login.dart';
import 'package:vivi_bday_app/pages/termsofservice.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {  

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool darkMode = false;
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController newEmailController = new TextEditingController();
  FirebaseUser currentUser;

  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ), 
        body: Material(
          child: SettingsList(
            sections: [
              SettingsSection(
                title: 'Common',
                tiles: [
                  SettingsTile(
                    title: 'Language',
                    subtitle: 'English',
                    leading: Icon(Icons.language),
                    onTap: () {},
                  ),
                  SettingsTile.switchTile(
                    title: 'Dark Mode',
                    leading: Icon(Icons.lightbulb_outline),
                    switchValue: darkMode,
                    onToggle: (bool darkMode) {}
                  ),
                ],
              ),
              SettingsSection(
                title: 'Account Security',
                tiles: [
                  SettingsTile(
                    title: 'Change Password',
                    leading: Icon(Icons.lock),
                    onTap: () {
                      showPasswordDialog();
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Misc',
                tiles: [
                  SettingsTile(
                    title: 'Terms of Service',
                    leading: Icon(Icons.email),
                    onTap: () {
                      viewTermsOfService();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('New Password', textAlign: TextAlign.center),
          backgroundColor: Colors.yellow[200],
          contentPadding: EdgeInsets.all(10.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextFormField (
                  controller: newPasswordController,
                  obscureText: true,
                  validator: (passwordInput) {
                    if(passwordInput.isEmpty) {
                      return 'Password cannot be empty.';
                    }
                    else {
                      return null;          
                    }      
                  },
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
                    filled: true,
                    hintText: 'Password',
                    hintStyle: TextStyle(fontSize: 20.0 , color: Colors.grey[700]),
                    fillColor: Colors.white70,
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    updatePassword(newPasswordController.text);
                  },
                  child: Text('Submit'), color: Colors.deepPurple[100],
                ),
              ],
            )
          ],
        );
      }
    );
  }

  void updatePassword(String newPassword) async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      user.updatePassword(newPassword).then((_) {
        // Password change was successful on toast
        Fluttertoast.showToast(
          msg: "Password changed! Please log in with new password",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );

        // Log out and make user login again
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage())
        );
      }).catchError((error) {
        // Error message in a toast
        if(newPassword.isEmpty) {
          Fluttertoast.showToast(
            msg: "Password cannot be empty.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }
        else if(newPassword.length < 6) {
          Fluttertoast.showToast(
            msg: "Password must be at least 6 characters.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }
      });
  }

  void viewTermsOfService() {
    // Go to Terms Of Service page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsOfServicePage())
    );
  }
}