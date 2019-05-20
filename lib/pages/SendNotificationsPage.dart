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
    var android = new AndroidInitializationSettings('@mipmap/launcher_icon');
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

    // Create a list of cute messages here
    // Add MORE!!
    List<String> cuteMessages = [];
    cuteMessages.add("I love you with all my heart!");
    cuteMessages.add("I adore you! You are an inspiration!");
    cuteMessages.add("You're the best!");
    cuteMessages.add("You are the light and love of my life!");
    cuteMessages.add("Life would have been empty without having you. Thank goodness for meeting you!");
    cuteMessages.add("My love for you is divine and endless. I’ll always love you! No matter what!");
    cuteMessages.add("You are my world and I love you more than my food! Unless YOU ARE my food 😘");
    cuteMessages.add("Just to reassure you of my love. I’ll always love you!");
    cuteMessages.add("Thank for always being there for me, even when sometimes I don’t deserve to be cared for. I promise you I will be here for you! ALWAYS!");
    cuteMessages.add("You bring out the best in me. Thank you for helping make me into what I am today");
    cuteMessages.add("Hey beautiful! I miss your cute face so much haha I just wanna squeeze it lol");
    cuteMessages.add("I'm so proud of everything you've accomplished at work honey! You're capable of A LOT more than you think! You're amazing!");
    cuteMessages.add("Whether you're reading this in the morning/afternoon/night, GOOD MORNING/AFTERNOON/NIGHT! Hope you have/had a wonderful day/night! 😘");
    cuteMessages.add("I was gonna put something clever here.... but can't think of anything... sooo just gonna say MAHAL KITA!!!");
    cuteMessages.add("Te quiero mucho!");
    cuteMessages.add("You are the absolute best thing that ever crossed my life. You make this journey worth it");
    cuteMessages.add("You manage to make me fall in love you over and over and over again. That shit never fails!");
    cuteMessages.add("Time really does fly when I'm with you. I remember when we were at Disney and we were waiting for the fireworks show and I got sad because 1) Your back was killing you and 2) Our day was almost over :( The saddest part of my day is the part when I leave you");
    cuteMessages.add("I wish I had a sunflower seed to plant everytime I catch myself falling deeper in love with you. We would have our own flower field lol");
    cuteMessages.add("Seeing you smile and being happy is the most beautiful sight in the world ");


    // Get a random index number to pick which message to send
    var rand = new Random();
    int randIndex = rand.nextInt(cuteMessages.length);
    print(randIndex);

    await flutterLocalNotificationsPlugin.show(
        0, 'Hi baby! :)', cuteMessages[randIndex] , platform, payload: cuteMessages[randIndex]);

  }
}



