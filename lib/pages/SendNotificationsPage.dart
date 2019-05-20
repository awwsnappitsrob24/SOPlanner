import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class SendNotificationsPage extends StatefulWidget {
  @override
  _SendNotificationsPageState createState() => _SendNotificationsPageState();
}

class _SendNotificationsPageState extends State<SendNotificationsPage> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String tokenValue = " ";

  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(
        initSettings, onSelectNotification: selectNotification );
  }

  // ignore: missing_return
  Future selectNotification(String payload){
    debugPrint('print payload : $payload');
    showDialog(context: context,builder: (_)=> AlertDialog(
      title: new Text('Hi baby!') ,
      content: new Text('$payload'),
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/images/notification_gif.gif"),
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
              new Container(
                margin: const EdgeInsets.only(top: 150.0),
                child: RaisedButton(
                  onPressed: showNotification,
                  child: Text('Press to cheer up! :)'), color: Colors.deepPurple[100],

                ),
              )

            ],
          ),
        ),
      ),
    );
  }


  showNotification() async{
    var android = new AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription"
        ,priority: Priority.High,importance: Importance.Max);
    var iOS = new IOSNotificationDetails();

    var platform = new NotificationDetails(android, iOS);

    // Create a list of cute messages here 😘
    // Add MORE!!
    List<String> cuteMessages = [];
    cuteMessages.add("I love you with all my heart!");
    cuteMessages.add("I adore you!");
    cuteMessages.add("You're the best!");
    cuteMessages.add("You are the light and love of my life");

    // Get a random index number to pick which message to send
    var rand = new Random();
    int randIndex = rand.nextInt(cuteMessages.length);
    print(randIndex);

    await flutterLocalNotificationsPlugin.show(
        0, 'Hi baby! :)', cuteMessages[randIndex] , platform, payload: cuteMessages[randIndex]);

  }
}



