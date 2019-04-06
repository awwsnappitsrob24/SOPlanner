import 'package:flutter/material.dart';

class DateList extends StatelessWidget {
  // Builder methods rely on a set of data, such as a list.
  final List<String> dates;
  DateList(this.dates);


  @override
  Widget build(BuildContext context) {
    return _buildImageList(context);
  }

  Widget _buildImageItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(dates[index], textAlign: TextAlign.center),
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
      itemCount: dates.length,
      // A callback that will return a widget.
      itemBuilder: _buildImageItem,
    );
  }
}
