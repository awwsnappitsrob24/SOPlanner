import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// HOW DO I MAKE THIS STATFEUL...????

// ignore: must_be_immutable
class GiftList extends StatefulWidget {

  GiftList(List<String> giftList);

  @override
  _GiftListState createState() => _GiftListState();
}

class _GiftListState extends State<GiftList> with AutomaticKeepAliveClientMixin<GiftList> {

  List<String> gifts = [];
  // ignore: non_constant_identifier_names
  GiftList(List<String> giftList) {
    this.gifts = giftList;
  }

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
        var giftDeleted = " ";

        // Delete the gift from the list
        // Not deleting right...
        if(gifts.length == 1) {
          giftDeleted = gifts.last;
          //gifts.removeLast();
          //print(giftDeleted);
          gifts.removeWhere((giftDelete) => giftDelete == giftDeleted);
          for(int i = 0; i < gifts.length; i++) {
            print(gifts[i]);
          }
        }
        else {
          giftDeleted = gifts.elementAt(index);
          //gifts.removeAt(index);
          //print(giftDeleted);
          gifts.removeWhere((giftDelete) => giftDelete == giftDeleted);
          for(int i = 0; i < gifts.length; i++) {
            print(gifts[i]);
          }
        }

        // Delete from firebase DB
        // How to read data more than once??
        var db = FirebaseDatabase.instance.reference().child("gifts");
        db.once().then((DataSnapshot snapshot){
          Map<dynamic,dynamic> gifts = snapshot.value;
          gifts.forEach((key, value) {

            //if(value["title"] == giftDeleted) {
            //  print(key);

            // Delete the node form Firebase DB
            //FirebaseDatabase.instance.reference().child("gifts")
            //    .child(key).remove();
            //}
          });
        });
        /**
            db.onValue.listen((e) {
            DataSnapshot myDataSnapshot = e.snapshot;
            Map<dynamic,dynamic> gifts = myDataSnapshot.value;
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

  @override
  bool get wantKeepAlive => true;
}

