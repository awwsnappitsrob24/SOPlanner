import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:vivi_bday_app/helper_classes/ImageList.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin<Homepage> {
  final List<File> imageList = [];
  File uploadedImage;
  String uploadedImageFilename;

  @override
  void initState() {
    super.initState();
    getImagesFromFirebaseStorage();
  }

  // ToDo: get images from firebase storage inside init state to start page off with all images that have been uploaded already.

  Future getImagesFromFirebaseStorage() async {

  }

  Future uploadImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(tempImage != null) {
        uploadedImage = tempImage;
        imageList.add(tempImage);

        // Get basename of path of image
        uploadedImageFilename = basename(tempImage.path);
      }
    });
  }

  Future addGiftIdea(BuildContext context) async {
    String _giftIdea;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add Gift Idea', textAlign: TextAlign.center),
            backgroundColor: Colors.yellow[200],
            contentPadding: EdgeInsets.all(10.0),
            children: <Widget>[
              TextFormField (
                validator: (giftInput) {
                  if(giftInput.isEmpty) {
                    return 'Gift cannot be empty.';
                  }
                },
                onSaved: (giftInput) => _giftIdea = giftInput,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
                  filled: true,
                  hintText: 'Gift',
                  hintStyle: TextStyle(fontSize: 20.0 , color: Colors.grey[700]),
                  fillColor: Colors.white70,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: new Text("OK"),
                    //Method to build the listview.builder of gifts and upload to firebase storage
                    onPressed: () {},
                  ),

                  FlatButton(
                    child: new Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )

            ],
          );
        }
    );
  }

  Future addDateIdea(BuildContext context) async {
    String _dateIdea;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add Date Idea', textAlign: TextAlign.center),
            backgroundColor: Colors.yellow[200],
            contentPadding: EdgeInsets.all(10.0),
            children: <Widget>[
              TextFormField (
                validator: (dateInput) {
                  if(dateInput.isEmpty) {
                    return 'Date cannot be empty.';
                  }
                },
                onSaved: (dateInput) => _dateIdea = dateInput,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
                  filled: true,
                  hintText: 'Date',
                  hintStyle: TextStyle(fontSize: 20.0 , color: Colors.grey[700]),
                  fillColor: Colors.white70,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: new Text("OK"),
                    //Method to build the listview.builder of dates and upload to firebase storage
                    onPressed: () {},
                  ),

                  FlatButton(
                    child: new Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )

            ],
          );
        }
    );
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
            child: Container(
              color: Colors.deepPurple[100],
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    //accountName: Text("Viviana Ruiz"),
                    accountName: new Text("Viviana Ruiz", style: TextStyle(color: Colors.white),),
                    accountEmail: new Text("viviruiz15@gmail.com", style: TextStyle(color: Colors.white),),
                    currentAccountPicture: CircleAvatar(
                      child: Image.asset('assets/images/profile_picture.jpg'),
                    ),
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/images/account_drawer_bgimage.jpg"),
                        fit: BoxFit.cover,
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
                    onTap: () {
                      addGiftIdea(context);
                    },
                  ),
                  ListTile(
                    title: Text("Add Date Ideas"),
                    trailing: Icon(Icons.restaurant),
                    onTap: () {
                      addDateIdea(context);
                    },
                  ),
                ],
              ),
            )
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
                        //child: uploadedImage == null ? Image.asset("")
                        //    :Expanded(child: Image.file(uploadedImage, fit: BoxFit.cover)),
                      ),

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



