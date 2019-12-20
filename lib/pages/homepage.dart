import 'dart:io';
import 'dart:math';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:firebase_database/firebase_database.dart' hide Event;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:vivi_bday_app/Setup/login.dart';
import 'package:vivi_bday_app/helper_classes/ImageList.dart';
import 'package:vivi_bday_app/pages/SendNotificationsPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  final User user;

  const Homepage({Key key, this.user}): super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin<Homepage> {
  final List<File> imageList = [];
  final List<String> giftList = [];
  final List<String> dateList = [];
  File uploadedImage;
  User myUser;
  String fileName, lastImageUrl = "", userFirstName, userLastName, userEmail;
  int fileNum = 0;
  TextEditingController giftTextController = new TextEditingController();
  TextEditingController dateTextController = new TextEditingController();
  FirebaseDatabase database = new FirebaseDatabase();
  Image currentPic = Image.asset('assets/images/default_picture.jpg');

  @override
  void initState() {

    super.initState();

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    // Get list of gifts, dates, and images from firebase database at initial startup
    readImages();
    readGifts();
    readDates();

    // Gets user information for the navigation drawer
    getUserInfo();
    //userFirstName = myUser.firstName;
    //userLastName = myUser.lastName;
    //userEmail = myUser.email;

    // Build everything in the start
    build(this.context);
  }

  Future uploadImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(tempImage != null) {
        uploadedImage = tempImage;
      }
    });

    final File file = new File(uploadedImage.path);

    // Add to list to be displayed
    imageList.add(file);

    // Send filename to DB soit can be read at startup
    createImage(file);
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
                controller: giftTextController,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        //Method to build the list of gifts and upload to firebase DB
                        String gift = giftTextController.text;
                        giftList.add(gift);
                        createGift(gift);

                        // Close the dialog box
                        Navigator.pop(context);
                      }
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
                controller: dateTextController,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      //Method to build the list of gifts and upload to firebase DB
                      String date = dateTextController.text;
                      dateList.add(date);
                      createDate(date);

                      // Close the dialog box
                      Navigator.pop(context);
                    },
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
    return new WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            drawer: Drawer(
                child: Container(
                  color: Colors.deepPurple[100],
                  child: ListView(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        // Use variables gotten from firebase database to get user's name and email
                        accountName: new Text('$userFirstName' + ' $userLastName', style: TextStyle(color: Colors.white),),
                        accountEmail: new Text('$userEmail', style: TextStyle(color: Colors.white),),
                        currentAccountPicture: CircleAvatar(
                          // Let the user upload their own picture
                          child: currentPic,
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
                      ListTile(
                        title: Text("Logout"),
                        trailing: Icon(Icons.power_settings_new),
                        onTap: () {
                          logout();
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
                  body: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Expanded(child: buildGifts(context)),
                        )
                      ],
                    ),
                  ),
                ),

                // For Adding Date Ideas
                Scaffold(
                  body: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Expanded(child: buildDates(context)),
                        ),
                      ],
                    ),
                  ),
                ),

                // Go to SendNotifications page
                SendNotificationsPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Read user's data from cloud firestore and display data in navigation drawer

  void getUserInfo() {
    // Store user's data in firestore for later retrieval
    Firestore.instance
    .collection('users')
    .where("email", isEqualTo: widget.user.email)
    .snapshots()
    .listen((data) => 
        data.documents.forEach((doc) {
          userFirstName = doc['firstName'];
          userLastName = doc['lastName'];
          userEmail = doc['email'];
        }));
  }

  // Go back to login page
  logout() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage())
    );
  }

  Widget _buildGiftItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(giftList[index]),
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
        if(giftList.length == 1) {
          giftDeleted = giftList.last;

          setState(() {
            giftList.removeWhere((giftDelete) => giftDelete == giftDeleted);
          });

          for(int i = 0; i < giftList.length; i++) {
            print(giftList[i]);
          }
        }
        else {
          giftDeleted = giftList.elementAt(index);

          setState(() {
            giftList.removeWhere((giftDelete) => giftDelete == giftDeleted);
          });

          for(int i = 0; i < giftList.length; i++) {
            print(giftList[i]);
          }
        }

        // Delete from firebase DB
        // How to read data more than once??
        var db = FirebaseDatabase.instance.reference().child("gifts");
        db.once().then((DataSnapshot snapshot){
          Map<dynamic,dynamic> gifts = snapshot.value;
          gifts.forEach((key, value) {

            // Check for value in DB to delete
            if(value["title"] == giftDeleted) {

              // Delete the node form Firebase DB
              FirebaseDatabase.instance.reference().child("gifts")
                  .child(key).remove();
            }
          });
        });

      },
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(giftList[index], textAlign: TextAlign.center),
              onTap: () {
                // Search for gifts in google search (Etsy?)

                // Get the value from the list to pass on as a query to Yelp or Google
                var query = giftList[index];
                _launchSearchGift(query);
              },
            ),
          ],
        ),
      ),
    );
  }

  _launchSearchGift(String query) async {

    // Get all available apps that are installed;
    List<Map<String, String>> availableApps = await AppAvailability.getInstalledApps();
    for(int i = 0; i < availableApps.length; i++) {
      print(availableApps[i]["app_name"]);
    }

    var url = " ";

    // Open in Etsy, Amazon, Ebay, Wish if they can
    // Split query if more than one word
    List<String> splitString = [];
    splitString = query.split(" ");

    // Etsy test
    if(splitString.length < 2) {
      url = 'https://www.etsy.com/search?q=' + splitString[0];
    }
    else {
      int lengthOfString = splitString.length;
      url = 'https://www.etsy.com/search?q=';
      for(int i = 0; i < lengthOfString; i++) {
        url += splitString[i] + "+";
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Widget buildGifts(BuildContext context) {
    return _buildGiftList(context);
  }

  ListView _buildGiftList(context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: giftList.length,
      // A callback that will return a widget.
      itemBuilder: _buildGiftItem,
    );
  }

  Widget _buildDateItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(dateList[index]),
      background: Container(
        alignment: AlignmentDirectional.center,
        color: Colors.red,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        var dateDeleted = " ";

        // Delete the gift from the list
        if(dateList.length == 1) {
          dateDeleted = dateList.last;

          setState(() {
            dateList.removeWhere((dateDelete) => dateDelete == dateDeleted);
          });

          for(int i = 0; i < dateList.length; i++) {
            print(dateList[i]);
          }
        }
        else {
          dateDeleted = dateList.elementAt(index);

          setState(() {
            dateList.removeWhere((dateDelete) => dateDelete == dateDeleted);
          });

          for(int i = 0; i < dateList.length; i++) {
            print(dateList[i]);
          }
        }

        // Delete from firebase DB
        var db = FirebaseDatabase.instance.reference().child("dates");
        db.once().then((DataSnapshot snapshot){
          Map<dynamic,dynamic> dates = snapshot.value;
          dates.forEach((key, value) {

            // Check for value in DB to delete
            if(value["title"] == dateDeleted) {

              // Delete the node form Firebase DB
              FirebaseDatabase.instance.reference().child("dates")
                  .child(key).remove();
            }
          });
        });
      },

      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(dateList[index], textAlign: TextAlign.center),
              onTap: () {
                // Search for dates in Yelp or just google search

                // Get the value from the list to pass on as a query to Yelp or Google
                var query = dateList[index];

                // Create dialog box to either search for it on Yelp, or
                // add a date to the calendar.
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text('Date Add/Search', textAlign: TextAlign.center),
                        backgroundColor: Colors.yellow[200],
                        contentPadding: EdgeInsets.all(10.0),
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  _launchSearchDate(query);
                                },

                                child: Text('Search for Date Idea'), color: Colors.deepPurple[100],
                              ),
                              RaisedButton(
                                onPressed: () {
                                  _addDateToCalendar(query);
                                },
                                child: Text('Add Date to Calendar'), color: Colors.deepPurple[100],
                              ),
                            ],
                          )

                        ],
                      );
                    }
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDates(BuildContext context) {
    return _buildDateList(context);
  }

  ListView _buildDateList(context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: dateList.length,
      // A callback that will return a widget.
      itemBuilder: _buildDateItem,
    );
  }

  _addDateToCalendar(String dateTitle) {
    final Event dateEvent = Event(
      title: dateTitle,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );

    Add2Calendar.addEvent2Cal(dateEvent);
  }


  _launchSearchDate(String query) async {
    var url = " ";

    // Open in Yelp if they can
    // Split query if more than one word
    List<String> splitString = [];
    splitString = query.split(" ");

    if(splitString.length < 2) {
      url = 'https://www.yelp.com/search?find_desc=' + splitString[0];
    }
    else {
      int lengthOfString = splitString.length;
      url = 'https://www.yelp.com/search?find_desc=';
      for(int i = 0; i < lengthOfString; i++) {
        url += splitString[i] + "+";
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  bool get wantKeepAlive => true;

  void createGift(String giftName) {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    var db = FirebaseDatabase.instance.reference().child("gifts").child(newNum.toString())
        .set({
      'title': giftName,
    });
  }

  void createImage(File file) {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    var db = FirebaseDatabase.instance.reference().child("images").child(newNum.toString())
        .set({
      'title': file.path,
    });
  }

  void createDate(String dateName) {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    var db = FirebaseDatabase.instance.reference().child("dates").child(newNum.toString())
        .set({
      'title': dateName,
    });
  }

  void readGifts() {
    var db = FirebaseDatabase.instance.reference().child("gifts");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> gifts = snapshot.value;
      gifts.forEach((key, value) {
        setState(() {
          giftList.add(value["title"]);
        });
      });
    });
  }

  void readDates() {
    var db = FirebaseDatabase.instance.reference().child("dates");
    db.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> dates = snapshot.value;
      dates.forEach((key, value) {
        setState(() {
          dateList.add(value["title"]);
        });
      });
    });
  }

  void readImages() {
    var db = FirebaseDatabase.instance.reference().child("images");
    db.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> images = snapshot.value;
      images.forEach((key, value) {
        setState(() {
          File savedFile = new File(value["title"]);
          imageList.add(savedFile);
        });
      });
    });
  }
}