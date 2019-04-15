import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SendNotificationsPage extends StatefulWidget {
  @override
  _SendNotificationsPageState createState() => _SendNotificationsPageState();
}

class _SendNotificationsPageState extends State<SendNotificationsPage> {

  final FirebaseMessaging _messaging = FirebaseMessaging();
  String tokenValue = " ";

  @override
  void initState() {
    super.initState();

    notificationListeners();
  }

  void notificationListeners() {

    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    _messaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true,
      )
    );

    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });

    _messaging.getToken().then((token) {
      print(token);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/images/date_page_image.jpg"),
          fit: BoxFit.cover,
        ),
      ),

      child: Scaffold (
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  // Send push notification with random cute messages :)

                },
                child: Text('Cheer me up, please!'), color: Colors.deepPurple[100],
              ),
            ],
          ),
        ),
      ),
    );
  }

}



