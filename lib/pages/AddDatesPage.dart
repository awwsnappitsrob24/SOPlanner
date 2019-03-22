import 'package:flutter/material.dart';

class AddDatesPage extends StatefulWidget {
  @override
  _AddDatesPageState createState() => _AddDatesPageState();
}

class _AddDatesPageState extends State<AddDatesPage> {
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
                    child: Text('Add Date Idea'), color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            )



        ),
      ),

    );
  }
}
