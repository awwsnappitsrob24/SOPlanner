import 'package:flutter/material.dart';

class SendNotificationsPage extends StatefulWidget {
  @override
  _SendNotificationsPageState createState() => _SendNotificationsPageState();
}

class _SendNotificationsPageState extends State<SendNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    /**
    return MaterialApp(
      home: Scaffold(
        body: Center (
          child: Column (
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/date_page_image.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: RaisedButton(
                  onPressed: () {
                    // Send push notification with random cute messages :)
                  },
                  child: Text('Cheer me up, please!'), color: Theme.of(context).primaryColor,
                ),
              )
            ],
          )
        ),
      ),

    );
        */

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
