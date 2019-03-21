import 'package:flutter/material.dart';

class AddDatesPage extends StatefulWidget {
  @override
  _AddDatesPageState createState() => _AddDatesPageState();
}

class _AddDatesPageState extends State<AddDatesPage> {
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
                child: Text('Add Dates'), color: Theme.of(context).primaryColor,
              ),
            )
          ],


        ),
      ),

    );
  }
}
