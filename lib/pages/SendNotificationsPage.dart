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
    cuteMessages.add("You are truly a beautfiul human being. Inside and out babygirl :)");
    cuteMessages.add("You make me feel like I can do anything. Know that you can do anything too!");
    cuteMessages.add("I love seeing you happy and my biggest reward is seeing you smile :)");
    cuteMessages.add("You know, I’m ready to kiss the whole world, for what it gave you to me. I couldn’t dream of a more romantic, sensual, caring and sweet second half.");
    cuteMessages.add("I will always have this piece of my heart that smiles whenever I think about you");
    cuteMessages.add("Darling, I hope that this cute message will make you smile: I want you to know that things are changing in the world, but the only thing that will last forever is my love for you.");
    cuteMessages.add("In the next life, I will find you and ask you out. AGAIN. SORRY! You're stuck with me lol");
    cuteMessages.add("Sometimes I wonder if love is worth fighting for. Then I look at you. I’m ready for war.");
    cuteMessages.add("I love the way you love me. It's nothing like I've ever had. Thank you for that :)");
    cuteMessages.add("You are so good to me … what did I ever do to deserve you?");
    cuteMessages.add("Love makes no sense if it is not to the right person. I feel very lucky to be with you!");
    cuteMessages.add("I wish you two things: everything and nothing. Everything that makes you happy and nothing that makes you suffer. I love you!dmire you, I care for you, I love you, I respect you and I trust you. Unconditionally.");
    cuteMessages.add("I don’t want you to be perfect. I love your imperfections because they make my life as perfect as one can imagine.");
    cuteMessages.add("You are and always be the prettiest girl in the world. At least in my world. Because YOU are my world. And not only that: you are my whole universe!");
    cuteMessages.add("You are the most wonderful love I ever had. With you, I feel untouchable, invincible. You make me stronger, happier and wiser. Because not everybody knows what is love.");
    cuteMessages.add("The world is so small compared to my love for you…");
    cuteMessages.add("My favorite place is by your side");
    cuteMessages.add("You are amazing and perfect in every way. Damn, autocorrect. I mean good morning. KIDDING! I love you!");
    cuteMessages.add("You are amazing and perfect in every way. Damn, autocorrect. I mean good morning.");
    cuteMessages.add("My life has never been brighter ever since we met.");
    cuteMessages.add("This might be jumping teh gun... but.. I can’t wait to marry you someday. Frfr");
    cuteMessages.add("You are so beautiful. Never EVER doubt that!");
    cuteMessages.add("I love the way that you giggle whenever I say something stupid lol the cutest!");
    cuteMessages.add("I don’t know what my favorite thing about you is. I love every single part of you!");
    cuteMessages.add("You don’t need to get all dolled up around me. I love you just the way you are.");
    cuteMessages.add("I love that you challenge me. I feel I’m a better person ever since you came into my life.");
    cuteMessages.add("I love how strong and determined you are. Keep fighting! You are my inspiration! Being with you makes me a better man.");
    cuteMessages.add("If you're reading this and you've had a tough day... just know that tomorrow, the sun will rise and shine and it will be another day! Another day I get to be with the most wonderful human being that's ever graced this planet. I love you!");
    cuteMessages.add("You still give me butterflies! Especially when you walk out of your house and you walk to my car when I come pick you up lol");
    cuteMessages.add("Te amo más que nada en el mundo!");

    // Get a random index number to pick which message to send
    var rand = new Random();
    int randIndex = rand.nextInt(cuteMessages.length);
    print(randIndex);

    await flutterLocalNotificationsPlugin.show(
        0, 'Hi baby! :)', cuteMessages[randIndex] , platform, payload: cuteMessages[randIndex]);

  }
}



