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
    return Dismissible(
      key: Key(gifts[index]),
      background: Container(
        alignment: AlignmentDirectional.center,
        color: Colors.red,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        // Delete the gift from the list
        var giftDeleted = gifts.elementAt(index);
        gifts.removeAt(index);

        // Delete from firebase DB
        // How to read data more than once??
        var db = FirebaseDatabase.instance.reference().child("gifts");
        db.once().then((DataSnapshot snapshot){
          Map<dynamic,dynamic> gifts = snapshot.value;
          gifts.forEach((key, value) {
            if(value["title"] == giftDeleted) {
              print(key);

              // Delete the node form Firebase DB
              FirebaseDatabase.instance.reference().child("gifts")
                  .child(key).remove();
            }
          });
        });


        /**
        FirebaseDatabase.instance.reference().child("gifts").onValue.
          listen((Event event) {
          DataSnapshot mySnapshot = event.snapshot;
          Map<dynamic,dynamic> gifts = mySnapshot.value;
          gifts.forEach((key, value) {
            if(value["title"] == giftDeleted) {
              print(key);

              // Delete the node form Firebase DB
              //FirebaseDatabase.instance.reference().child("gifts")
              //    .child(key).remove();
            }
          });
        });
            */
        /**
        db.once().then((DataSnapshot snapshot){
          Map<dynamic,dynamic> gifts = snapshot.value;
          gifts.forEach((key, value) {
            if(value["title"] == giftDeleted) {
              print(key);

              // Delete the node form Firebase DB
              FirebaseDatabase.instance.reference().child("gifts")
                  .child(key).remove();
            }
          });
        });
        */

      },
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(gifts[index], textAlign: TextAlign.center),
              onTap: () {
                // something
              },
            ),
          ],
        ),
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
