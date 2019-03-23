import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:vivi_bday_app/helper_classes/ImageList.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin<Homepage> {

  String _imageUrl;
  final List<File> imageList = [];
  File uploadedImage;

  @override
  void initState() {
    super.initState();
    getImagesFromFirebaseStorage();
  }

  // ToDo: get images from firebase storage inside init state to start page off with all images that have been uploaded already.

  Future getImagesFromFirebaseStorage() async {
    final ref = FirebaseStorage.instance.ref().child('storage/');
    var url = await ref.getDownloadURL();
    Image.network(url);
    imageList.add(url);
  }

  Future uploadImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(tempImage != null) {
        imageList.add(tempImage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple[200],
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text("Viviana Ruiz"),
                  accountEmail: Text("viviruiz15@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor:
                    Theme.of(context).platform == TargetPlatform.android
                        ? Colors.orange[300]
                        : Colors.blue,
                    child: Text(
                      "V",
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Upload Pictures"),
                  trailing: Icon(Icons.image),
                  onTap: () {
                    uploadImage();
                  },
                ),
                ListTile(
                  title: Text("Add Gift Ideas"),
                  trailing: Icon(Icons.card_giftcard),
                ),
                ListTile(
                  title: Text("Add Date Ideas"),
                  trailing: Icon(Icons.restaurant),
                ),
              ],
            ),
          ),

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
              Scaffold(
                body: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Expanded(child: ImageList(imageList))
                      )
                    ],
                  ),
                ),
              ),

              // For Adding Gift Ideas
              Scaffold(

              ),

              // For Adding Date Ideas
              Scaffold(

              ),

              // For button to send notifications
              Scaffold(

              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}



