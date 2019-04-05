import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GiftList extends StatelessWidget {
  // Builder methods rely on a set of data, such as a list.
  final List<String> gifts;
  GiftList(this.gifts);


  @override
  Widget build(BuildContext context) {
    return _buildImageList(context);
  }

  Widget _buildImageItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(gifts[index], textAlign: TextAlign.center),
            //trailing: Icon(Icons.card_giftcard),
            onTap: () {
              // something
            },
          ),
        ],
      ),
    );
  }


  ListView _buildImageList(context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: gifts.length,
      // A callback that will return a widget.
      itemBuilder: _buildImageItem,
    );
  }
}
