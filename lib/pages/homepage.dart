import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart' hide Event;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vivi_bday_app/Setup/login.dart';
import 'package:vivi_bday_app/models/user.dart';
import 'package:vivi_bday_app/helpers/helper_functions.dart';
import 'package:vivi_bday_app/pages/termsofservice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:vivi_bday_app/services/auth_services.dart';

class Homepage extends StatefulWidget {
  final User user;

  const Homepage({Key key, this.user}): super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin<Homepage> {
  final List<String> tripList = [];
  final List<String> giftList = [];
  final List<String> dateList = [];
  final List<String> giftDescriptionList = [];
  final List<String> dateDescriptionList = [];
  final List<String> tripDescriptionList = [];
  File newProfilePic;
  String fileName, lastImageUrl = "", userFirstName, userLastName, userEmail, dateChosen;
  int fileNum = 0;
  TextEditingController giftTextController = new TextEditingController();
  TextEditingController dateTextController = new TextEditingController();
  TextEditingController giftDescController = new TextEditingController();
  TextEditingController tripTextController = new TextEditingController();
  TextEditingController tripDescController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  FirebaseUser currentUser;
  FirebaseDatabase database = new FirebaseDatabase();
  AuthServices auth = AuthServices();


  @override
  void initState() {

    super.initState();

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    // Get user list of trips, gifts, dates from firebase database at initial startup
    readTrips();
    readGifts();
    readDates();

    //tripList.clear();
    //tripDescriptionList.clear();
    //giftList.clear();
    //giftDescriptionList.clear();
    //dateList.clear();
    //dateDescriptionList.clear();

    // Build everything in the start
    build(this.context);
  }

  Future addTripIdea(BuildContext context) async {
    String _tripIdea, _date;

    showDialog(
        context: context,
        
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add Trip Idea', textAlign: TextAlign.center),
            backgroundColor: Colors.blue[100],
            contentPadding: EdgeInsets.all(10.0),
            children: <Widget>[
              TextFormField (
                controller: tripTextController,
                validator: (tripInput) {
                  if(tripInput.isEmpty) {
                    return 'Trip cannot be empty.';
                  }
                  else {
                    return null;          
                  }      
                },
                onSaved: (tripInput) => _tripIdea = tripInput,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
                  filled: true,
                  hintText: 'Trip',
                  hintStyle: TextStyle(fontSize: 20.0 , color: Colors.grey[700]),
                  fillColor: Colors.white70,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text('OK'), color: Colors.pink[50],
                    onPressed: () {
                      String trip = tripTextController.text;
                     
                      // Close the dialog box
                      Navigator.pop(context);
          
                      // Add date chosen to list and firebase db
                      showTripPicker(trip);                   
                    }
                  ),

                  FlatButton(
                    child: Text('Cancel'), color: Colors.pink[50],
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


  Future addGiftIdea(BuildContext context) async {
    String _giftIdea;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add Gift Idea', textAlign: TextAlign.center),
            backgroundColor: Colors.blue[100],
            contentPadding: EdgeInsets.all(10.0),
            children: <Widget>[
              // Gift idea text field
              TextFormField (
                controller: giftTextController,
                validator: (giftInput) {
                  if(giftInput.isEmpty) {
                    return 'Gift cannot be empty.';
                  }
                  else {
                    return null;          
                  }               
                },
                onSaved: (giftInput) => _giftIdea = giftInput,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
                  filled: true,
                  hintText: 'Gift',
                  hintStyle: TextStyle(fontSize: 20.0 , color: Colors.grey[700]),
                  fillColor: Colors.white70,
                )
              ),
              // Gift description text field
              TextFormField (
                controller: giftDescController,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
                  filled: true,
                  hintText: 'Description (optional)',
                  hintStyle: TextStyle(fontSize: 20.0 , color: Colors.grey[700]),
                  fillColor: Colors.white70,
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text('OK'), color: Colors.pink[50],
                    onPressed: () {
                      String gift = giftTextController.text;
                      String giftDesc = giftDescController.text;

                      // Add it to giftList to be read, also to firebase db
                      setState(() {
                        giftList.add(gift);
                        giftDescriptionList.add(giftDesc);
                        createGift(gift, giftDesc);
                      });

                      // Close the dialog box
                      Navigator.pop(context);
                    }
                  ),

                  FlatButton(
                    child: Text('Cancel'), color: Colors.pink[50],
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
            backgroundColor: Colors.blue[100],
            contentPadding: EdgeInsets.all(10.0),
            children: <Widget>[
              TextFormField (
                controller: dateTextController,
                validator: (dateInput) {
                  if(dateInput.isEmpty) {
                    return 'Date cannot be empty.';
                  }
                  else {
                    return null;          
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
                    child: Text('OK'), color: Colors.pink[50],
                    onPressed: () {
                      String date = dateTextController.text;

                      // Close the dialog box
                      Navigator.pop(context);
          
                      // Add date chosen to list and firebase db
                      showDatePicker(date);  
                    },
                  ),

                  FlatButton(
                    child: Text('Cancel'), color: Colors.pink[50],
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
          length: 3,
          child: Scaffold(
            drawer: Drawer(
                child: Container(
                  child: ListView(   
                    padding: const EdgeInsets.all(0.0),       
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        // Use variables gotten from firebase database to get user's name and email
                        accountName: new Text("${widget.user.firstName}" + " ${widget.user.lastName}", style: TextStyle(color: Colors.white),),
                        accountEmail: new Text("${widget.user.email}", style: TextStyle(color: Colors.white),),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/drawer_header_bgimg.jpg"), // background image to fit whole page
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Add trip idea tile
                      ListTile(
                        title: Text("Add Trip Idea"),
                        trailing: Icon(Icons.local_airport, color: Colors.grey),
                        onTap: () {
                          addTripIdea(context);
                        },
                      ),
                      // Add gift idea tile
                      ListTile(
                        title: Text("Add Gift Idea"),
                        trailing: Icon(Icons.card_giftcard, color: Colors.grey),
                        onTap: () {
                          addGiftIdea(context);
                        },
                      ),
                      // Add date idea tile
                      ListTile(
                        title: Text("Add Date Idea"),
                        trailing: Icon(Icons.restaurant, color: Colors.grey),
                        onTap: () {
                          addDateIdea(context);
                        },
                      ),
                      // Divider to divide app functions and app security
                      Divider(),
                      // Settings tile
                      ListTile(
                        title: Text("Change Password"),
                        trailing: Icon(Icons.lock, color: Colors.grey),
                        onTap: () {
                          showPasswordDialog();
                        },
                      ),
                      // Logout tile
                      ListTile(
                        title: Text("Logout"),
                        trailing: Icon(Icons.power_settings_new, color: Colors.grey),
                        onTap: () {
                          signOut();
                        },
                      ),
                      // Divider to divide app security with terms of security
                      Divider(),
                      ListTile(
                        title: Text("Terms of Security"),
                        trailing: Icon(Icons.security, color: Colors.grey),
                        onTap: () {
                          // Go to terms of services page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TermsOfServicePage())
                          );
                        },
                      ),
                    ],
                  ),
                )
            ),
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Trips', icon: Icon(Icons.local_airport)),
                  Tab(text: 'Gifts', icon: Icon(Icons.card_giftcard)),
                  Tab(text: 'Dates', icon: Icon(Icons.restaurant)),                  
                ],
              ),
              title: Text("Welcome, " + "${widget.user.firstName}" + '!', style: TextStyle(color: Colors.white)),
              centerTitle: true,
            ),
            body: TabBarView (
              children: [
                // For Adding Trip Ideas
                Scaffold(
                  body: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Expanded(child: buildTrips(context)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show dialog for changing password
  void showPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('New Password', textAlign: TextAlign.center),
          backgroundColor: Colors.blue[100],
          contentPadding: EdgeInsets.all(10.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextFormField (
                  controller: newPasswordController,
                  obscureText: true,
                  validator: (passwordInput) {
                    if(passwordInput.isEmpty) {
                      return 'Password cannot be empty.';
                    }
                    else {
                      return null;          
                    }      
                  },
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
                    filled: true,
                    hintText: 'Password',
                    hintStyle: TextStyle(fontSize: 20.0 , color: Colors.grey[700]),
                    fillColor: Colors.white70,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    updatePassword(newPasswordController.text);
                  },
                  child: Text('Submit'), color: Colors.pink[50],
                ),
              ],
            )
          ],
        );
      }
    );
  }

  // Update password function
  void updatePassword(String newPassword) async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      user.updatePassword(newPassword).then((_) async {
        // Password change was successful on toast
        Fluttertoast.showToast(
          msg: "Password changed! Please log in with new password",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );

        // Log out and make user login again
        signOut();
      }).catchError((error) {
        // Error message in a toast
        if(newPassword.isEmpty) {
          Fluttertoast.showToast(
            msg: "Password can not be empty.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }
        else if(newPassword.length < 6) {
          Fluttertoast.showToast(
            msg: "Password must be at least 6 characters.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }
      });
  }

  // Sign user out then go back to login page
  signOut() async {
    await auth.logout();

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage())
    );
  }

  Widget buildTrips(BuildContext context) {
    return _buildTripList(context);
  }

  ListView _buildTripList(context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: tripList.length,
      // A callback that will return a widget.
      itemBuilder: _buildTripItem,
    );
  }

  Widget _buildTripItem(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,10,0),
      height: 200,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Stack(
          children: <Widget>[
            /*
            Align(
              child: Image.asset(
                "your_image",
                width: 150,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),*/
            // Trip name text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(tripList[index], style: TextStyle(fontSize: 25)),
                  ),
                ),
                // Trip date text
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(tripDescriptionList[index]),
                  ),
                ),
              ],
            ),
            // 3 icons on the right side of the card
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Booking icon
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,15,0,0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.local_airport),
                        onPressed: () {
                          HelperFunctions.bookTrip(tripList[index]);
                        },
                      ),
                    )
                  ),
                  // Add to Calendar icon
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                      icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          HelperFunctions.addDateToCalendar(tripList[index]);
                        },
                      ),
                    )
                  ),
                  // Delete trip button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            var tripDeleted = tripList.elementAt(index);
                            var tripDescDeleted = tripDescriptionList.elementAt(index);

                            deleteTrip(tripDeleted, tripDescDeleted, index);
                          },
                        ),
                    )
                  ),
                ],
              )
            )
          ],
        ),
      ) 
    );
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

  Widget _buildGiftItem(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,10,0),
      height: 150,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Stack(
          children: <Widget>[
            /*
            Align(
              child: Image.asset(
                "your_image",
                width: 150,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),*/
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Gift name text
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(giftList[index], style: TextStyle(fontSize: 25)),
                  ),
                ),
                // Gift description text
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(giftDescriptionList[index]),
                  ),
                ),
              ],
            ),
            // 2 icons on the right side of the card
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Searching icon
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,15,0,0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          HelperFunctions.launchSearchGift(giftList[index]);
                        },
                      ),
                    )
                  ),
                  // Delete gift button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            var giftDeleted = giftList.elementAt(index);
                            var giftDescDeleted = giftDescriptionList.elementAt(index);

                            deleteGift(giftDeleted, giftDescDeleted, index);
                          },
                        ),
                    )
                  ),
                ],
              )
            )
          ],
        ),
      ) 
    );
  }

  Widget _buildDateItem(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,10,0),
      height: 200,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Stack(
          children: <Widget>[
            /*
            Align(
              child: Image.asset(
                "your_image",
                width: 150,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),*/
            // Trip name text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(dateList[index], style: TextStyle(fontSize: 25)),
                  ),
                ),
                // Trip date text
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(dateDescriptionList[index]),
                  ),
                ),
              ],
            ),
            // 3 icons on the right side of the card
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Searching at Yelp icon
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,15,0,0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          HelperFunctions.launchSearchDate(dateList[index]);
                        },
                      ),
                    )
                  ),
                  // Add to Calendar icon
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                      icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          HelperFunctions.addDateToCalendar(dateList[index]);
                        },
                      ),
                    )
                  ),
                  // Delete date button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            var dateDeleted = dateList.elementAt(index);
                            var dateDescDeleted = dateDescriptionList.elementAt(index);

                            deleteDate(dateDeleted, dateDescDeleted, index);
                          },
                        ),
                    )
                  ),
                ],
              )
            )
          ],
        ),
      ) 
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

  @override
  bool get wantKeepAlive => true;

  // Function that adds the trip idea the user entered and store it into realtime db
  void createTrip(String tripName, String tripDesc) async {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    FirebaseDatabase.instance.reference()
      .child(widget.user.uniqueID.toString())
      .child("trips")
      .child(newNum.toString())
      .set({
        'title': tripName,
        'description': tripDesc,
      });
  }

  // Function that adds the gift idea the user entered and store it into realtime db
  void createGift(String giftName, String giftDesc) async {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    FirebaseDatabase.instance.reference()
      .child(widget.user.uniqueID.toString())
      .child("gifts")
      .child(newNum.toString())
      .set({
        'title': giftName,
        'description': giftDesc,
      });
  }

  // Function that adds the date idea the user entered and store it into realtime db
  void createDate(String dateName, String dateDesc) async {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    FirebaseDatabase.instance.reference()
      .child(widget.user.uniqueID.toString())
      .child("dates")
      .child(newNum.toString())
      .set({
        'title': dateName,
        'description': dateDesc,
      });
  }

  // Reads trips in firebase db and displays them on screen
  void readTrips() {
     var db = FirebaseDatabase.instance.reference()
      .child(widget.user.uniqueID.toString())
      .child("trips");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> gifts = snapshot.value;
      gifts.forEach((key, value) {
        setState(() {
          tripList.add(value["title"]);
          tripDescriptionList.add(value["description"]);
        });
      });
    });
  }

  // Reads gifts in firebase db and displays them on screen
  void readGifts() {
    var db = FirebaseDatabase.instance.reference()
      .child(widget.user.uniqueID.toString())
      .child("gifts");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> gifts = snapshot.value;
      gifts.forEach((key, value) {
        setState(() {
          giftList.add(value["title"]);
          giftDescriptionList.add(value["description"]);
        });
      });
    });
  }

  // Reads dates in firebase db and displays them on screen
  void readDates() {
    var db = FirebaseDatabase.instance.reference()
      .child(widget.user.uniqueID.toString())
      .child("dates");
    db.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> dates = snapshot.value;
      dates.forEach((key, value) {
        setState(() {
          dateList.add(value["title"]);
          dateDescriptionList.add(value["description"]);
        });
      });
    });
  }

  // Function to delete trip from list and firebase db
  void deleteTrip(String tripToDelete, String tripDescToDelete, int index) {
    // Delete the gift from the list
    if(tripList.length == 1) {
      tripToDelete = tripList.last;
      tripDescToDelete = tripDescriptionList.last;

      setState(() {
        tripList.removeWhere((tripDelete) => tripDelete == tripToDelete);
        tripDescriptionList.removeWhere((tripDescDelete) => tripDescDelete == tripDescToDelete);
      });
    }
    else {
      tripToDelete = tripList.elementAt(index);
      tripDescToDelete = tripDescriptionList.elementAt(index);

      setState(() {
        tripList.removeWhere((tripDelete) => tripDelete == tripToDelete);
        tripDescriptionList.removeWhere((tripDescDelete) => tripDescDelete == tripDescToDelete);
      });
    }

    // Delete from firebase DB
    var db = FirebaseDatabase.instance.reference()
      .child(widget.user.uniqueID.toString())
      .child("trips");
    db.once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> trips = snapshot.value;
      trips.forEach((key, value) {

        // Check for value in DB to delete
        if(value["title"] == tripToDelete) {

          // Delete the node form Firebase DB
          FirebaseDatabase.instance.reference()
            .child(widget.user.uniqueID.toString())
            .child("trips")
            .child(key)
            .remove();
        }
      });
    });
  }

  // Function to delete gift from list and firebase db
  void deleteGift(String giftToDelete, String giftDescToDelete, int index) {
    // Delete the gift from the list
    if(giftList.length == 1) {
      giftToDelete = giftList.last;
      giftDescToDelete = giftDescriptionList.last;

      setState(() {
        giftList.removeWhere((giftDelete) => giftDelete == giftToDelete);
        giftDescriptionList.removeWhere((giftDescDelete) => giftDescDelete == giftDescToDelete);
      });
    }
    else {
      giftToDelete = giftList.elementAt(index);
      giftDescToDelete = giftDescriptionList.elementAt(index);

      setState(() {
        giftList.removeWhere((giftDelete) => giftDelete == giftToDelete);
        giftDescriptionList.removeWhere((giftDescDelete) => giftDescDelete == giftDescToDelete);
      });
    }

    // Delete from firebase DB
    var db = FirebaseDatabase.instance.reference()
      .child(widget.user.uniqueID.toString())
      .child("gifts");
    db.once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> gifts = snapshot.value;
      gifts.forEach((key, value) {

        // Check for value in DB to delete
        if(value["title"] == giftToDelete) {

          // Delete the node form Firebase DB
          FirebaseDatabase.instance.reference()
            .child(widget.user.uniqueID.toString())
            .child("gifts")
            .child(key)
            .remove();
        }
      });
    });
  }

  // Function to delete date from list and firebase db
  void deleteDate(String dateToDelete, String dateDescToDelete, int index) {
    // Delete the date from the list
    if(dateList.length == 1) {
      dateToDelete = dateList.last;
      dateDescToDelete = dateDescriptionList.last;

      setState(() {
        dateList.removeWhere((dateDelete) => dateDelete == dateToDelete);
        dateDescriptionList.removeWhere((dateDescDelete) => dateDescDelete == dateDescToDelete);
      });
    }
    else {
      dateToDelete = dateList.elementAt(index);
      dateDescToDelete = dateDescriptionList.elementAt(index);

      setState(() {
        dateList.removeWhere((dateDelete) => dateDelete == dateToDelete);
        dateDescriptionList.removeWhere((dateDescDelete) => dateDescDelete == dateDescToDelete);
      });
    }

    // Delete from firebase DB
    var db = FirebaseDatabase.instance.reference()
      .child(widget.user.uniqueID.toString())
      .child("dates");
    db.once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> dates = snapshot.value;
      dates.forEach((key, value) {

        // Check for value in DB to delete
        if(value["title"] == dateToDelete) {

          // Delete the node form Firebase DB
          FirebaseDatabase.instance.reference()
            .child(widget.user.uniqueID.toString())
            .child("dates")
            .child(key)
            .remove();
        }
      });
    });
  }

  // Function to let user to choose the date of the trip and
  // add it to the list and Firebase db
  void showTripPicker(String tripName)  {
    String _date;

    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      theme: DatePickerTheme(
        headerColor: Colors.orange[200],
        backgroundColor: Colors.blue[200],
        itemStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        doneStyle: TextStyle(color: Colors.white, fontSize: 16)
      ),
      minTime: DateTime.now(),
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        print('confirm $date');
        _date = '${date.month}/${date.day}/${date.year}';
        dateChosen = _date;

        // Add it to tripList to be read, also to firebase db
        setState(() {
          tripList.add(tripName);
          tripDescriptionList.add(dateChosen);
          createTrip(tripName, dateChosen);       
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  // Function to let user to choose the date of the date and
  // add it to the list and Firebase db
  void showDatePicker(String dateName)  {
    String _date;

    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      theme: DatePickerTheme(
        headerColor: Colors.orange[200],
        backgroundColor: Colors.blue[200],
        itemStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        doneStyle: TextStyle(color: Colors.white, fontSize: 16)
      ),
      minTime: DateTime.now(),
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        print('confirm $date');
        _date = '${date.month}/${date.day}/${date.year}';
        dateChosen = _date;

        // Add it to tripList to be read, also to firebase db
        setState(() {
          dateList.add(dateName);
          dateDescriptionList.add(dateChosen);
          createDate(dateName, dateChosen);       
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }
}