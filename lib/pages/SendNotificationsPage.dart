import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class SendNotificationsPage extends StatefulWidget {
  @override
  _SendNotificationsPageState createState() => _SendNotificationsPageState();
}

class _SendNotificationsPageState extends State<SendNotificationsPage> {

  final FirebaseMessaging _messaging = FirebaseMessaging();
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

    //showGoodMorningNotification();
    //showGoodNightgNotification();
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
                onPressed: showNotification,
                child: Text('Press for a notification now! :)'), color: Colors.deepPurple[100],
              ),
              RaisedButton(
                onPressed: cancelNotifications,
                child: Text('Cancel all notifications'), color: Colors.deepPurple[100],
              ),
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

  cancelNotifications() async{
    await flutterLocalNotificationsPlugin.cancelAll();

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('All incoming notifications cancelled!'),
      duration: Duration(seconds: 3),
    ));
  }

  Future showNotificationEveryMinute() async {
    var android = new AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription"
        ,priority: Priority.High,importance: Importance.Max);
    var iOS = new IOSNotificationDetails();

    var platform = new NotificationDetails(android, iOS);

    // Create a list of cute messages here
    List<String> cuteMessages = [];
    cuteMessages.add("I love you with all my heart!");
    cuteMessages.add("I adore you!");
    cuteMessages.add("You're the best!");
    cuteMessages.add("You are the light and love of my life");

    // Get a random index number to pick which message to send
    var rand = new Random();
    int randIndex = rand.nextInt(cuteMessages.length);

    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Hi baby! :)',
        cuteMessages[randIndex],
        RepeatInterval.EveryMinute,
        platform,
        payload: cuteMessages[randIndex]
    );
  }


  /**
  Future showGoodMorningNotification() async {
    var time = new Time(7, 0, 0);
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics);
  }*/
}



