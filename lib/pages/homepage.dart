import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:vivi_bday_app/pages/AddDatesPage.dart';
import 'package:vivi_bday_app/pages/AddGiftsPage.dart';
import 'package:vivi_bday_app/pages/SendNotificationsPage.dart';
import 'package:vivi_bday_app/pages/UploadImagesPage.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  //File sampleImage;

  //Future uploadImage() async {
  //  var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

  //  setState(() {
  //    sampleImage = tempImage;
  //  });
  //}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurple[200],
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Pictures', icon: Icon(Icons.image)),
                Tab(text: 'Gifts', icon: Icon(Icons.card_giftcard)),
                Tab(text: 'Dates', icon: Icon(Icons.restaurant)),
                Tab(text: 'Messages', icon: Icon(Icons.mood)),
              ],
            ),
            title: Text('Welcome, Vivi!', style: TextStyle(color: Colors.yellow)),
            centerTitle: true,
          ),
          body: TabBarView (
            children: [
              new UploadImagesPage(),
              new AddGiftsPage(),
              new AddDatesPage(),
              new SendNotificationsPage(),
            ],


          ),
        ),
      ),
    );
  }
}



