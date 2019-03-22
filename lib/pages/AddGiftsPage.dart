import 'package:flutter/material.dart';

class AddGiftsPage extends StatefulWidget {
  @override
  _AddGiftsPageState createState() => _AddGiftsPageState();
}

class _AddGiftsPageState extends State<AddGiftsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center (
          // Centralize button in the page
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.center,
            child: Column (
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text('Add Gift Idea'), color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            )



        ),
      ),

    );
  }
}
