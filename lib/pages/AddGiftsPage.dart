import 'package:flutter/material.dart';

class AddGiftsPage extends StatefulWidget {
  @override
  _AddGiftsPageState createState() => _AddGiftsPageState();
}

class _AddGiftsPageState extends State<AddGiftsPage> {
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
                child: Text('Add Gifts'), color: Theme.of(context).primaryColor,
              ),
            )
          ],


        ),
      ),

    );
  }
}
