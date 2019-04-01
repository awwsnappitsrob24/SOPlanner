import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivi_bday_app/helper_classes/ImageList.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}



class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin<Homepage> {
  final List<File> imageList = [];
  File uploadedImage;
  String fileName, lastImageUrl = "";
  int fileNum = 0, _listSize = 0;


  saveListSizePreference(int size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("listsize", size);
  }

  getListSizePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _listSize = prefs.getInt("listsize");
    });
  }

  // ToDo: bottom code works! Use shared preferences to get the fileNum and loop through list.
  @override
  void initState() {
    Directory myTempDir = Directory.systemTemp;
    String sampleFileName = '1.jpg';
    File myFile = File('${myTempDir.path}/$sampleFileName');
    imageList.add(myFile);

    //getListSizePreference();

    //print(_listSize);
    //for(int i = 0; i < listSize; i++) {
    //  print(listSize);
    //}

    build(this.context);

    super.initState();
  }

  Future uploadImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(tempImage != null) {
        uploadedImage = tempImage;
      }
    });

    // Save this integer!
    // Get this on login to determine the size of the image list
    // Loop through image list this many times and get the file names (int.jpg)
    // Add them to the list and expand them
    fileNum++;

    final ByteData bytes = await rootBundle.load(uploadedImage.path);
    final Directory tempDir = Directory.systemTemp;

    // Rename file for simpler retrieval
    // ignore: unnecessary_brace_in_string_interps
    final String fileName = "${fileNum}.jpg";

    final File file = File('${tempDir.path}/$fileName');
    file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

    imageList.add(file);

    //saveListSizePreference(fileNum);
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



