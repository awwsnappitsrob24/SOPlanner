import 'package:flutter/material.dart';

class SendNotificationsPage extends StatefulWidget {
  @override
  _SendNotificationsPageState createState() => _SendNotificationsPageState();
}

class _SendNotificationsPageState extends State<SendNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column (
          // Centralize button in the page
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Container(
              child: RaisedButton(
                onPressed: () {},
                child: Text('Cheer me up, please!'), color: Theme.of(context).primaryColor,
              ),
            )
          ],


        ),
      ),

    );
  }
}
