import 'package:flutter/material.dart';
import 'package:vivi_bday_app/models/user.dart';
import 'package:vivi_bday_app/models/trip.dart';
import 'package:vivi_bday_app/models/gift.dart';
import 'package:vivi_bday_app/models/date.dart';
import 'package:vivi_bday_app/helpers/helper_functions.dart';
import 'package:vivi_bday_app/services/auth_services.dart';
import 'package:vivi_bday_app/services/db_services.dart';
import 'package:vivi_bday_app/services/api_services.dart';
import 'package:vivi_bday_app/pages/login.dart';
import 'package:vivi_bday_app/pages/termsofservice.dart';
import 'package:firebase_database/firebase_database.dart' hide Event;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Homepage extends StatefulWidget {
  final User user;

  const Homepage({Key key, this.user}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin<Homepage> {
  // Declare/Initialize all needed variables
  List<String> tripList = [],
      giftList = [],
      dateList = [],
      giftDescriptionList = [],
      dateDescriptionList = [],
      tripDescriptionList = [],
      tripImageUrlList = [],
      giftImageUrlList = [],
      dateImageUrlList = [];
  String userFirstName, userLastName, userEmail, dateChosen;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<String> imageContentUrl;
  TextEditingController giftTextController,
      dateTextController = new TextEditingController(),
      giftDescController = new TextEditingController(),
      tripTextController = new TextEditingController(),
      tripDescController = new TextEditingController(),
      newPasswordController = new TextEditingController();
  FirebaseDatabase database = new FirebaseDatabase();
  AuthServices auth = AuthServices();
  DBServices dbservice = DBServices();
  APIServices apiservice = APIServices();
  Trip myTrip = Trip();
  Gift myGift = Gift();
  Date myDate = Date();

  @override
  void initState() {
    super.initState();

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    // Get user list of trips, gifts, dates from firebase database at initial startup
    getTripsAtStartup();
    getGiftsAtStartup();
    getDatesAtStartup();

    // Build everything in the start
    build(this.context);
  }

  Future addTripIdea(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SimpleDialog(
                title: Text('Add Trip Idea', textAlign: TextAlign.center),
                backgroundColor: Colors.blue[100],
                contentPadding: EdgeInsets.all(10.0),
                children: <Widget>[
                  TextFormField(
                    controller: tripTextController,
                    validator: (tripInput) {
                      if (tripInput.isEmpty) {
                        return 'Trip cannot be empty.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 13.0, horizontal: 10.0),
                      filled: true,
                      hintText: 'Trip',
                      hintStyle:
                          TextStyle(fontSize: 20.0, color: Colors.grey[700]),
                      fillColor: Colors.white70,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                          child: Text('OK'),
                          color: Colors.pink[50],
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              // Set trip attributes
                              myTrip.tripName = tripTextController.text;
                              myTrip.imageUrl =
                                  await apiservice.fetchImage(myTrip.tripName);

                              // Close the dialog box
                              Navigator.pop(context);

                              // Add date chosen to list and firebase db
                              showTripPicker(myTrip);
                            }
                          }),
                      FlatButton(
                        child: Text('Cancel'),
                        color: Colors.pink[50],
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future addGiftIdea(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SimpleDialog(
                title: Text('Add Gift Idea', textAlign: TextAlign.center),
                backgroundColor: Colors.blue[100],
                contentPadding: EdgeInsets.all(10.0),
                children: <Widget>[
                  // Gift idea text field
                  TextFormField(
                      controller: giftTextController,
                      validator: (giftInput) {
                        if (giftInput.isEmpty) {
                          return 'Gift cannot be empty.';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 10.0),
                        filled: true,
                        hintText: 'Gift',
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.grey[700]),
                        fillColor: Colors.white70,
                      )),
                  // Gift description text field
                  TextFormField(
                      controller: giftDescController,
                      validator: (giftDescInput) {
                        if (giftDescInput.isEmpty) {
                          return 'Description cannot be empty.';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 10.0),
                        filled: true,
                        hintText: 'Description',
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.grey[700]),
                        fillColor: Colors.white70,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                          child: Text('OK'),
                          color: Colors.pink[50],
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              // Set gift attributes
                              myGift.giftName = giftTextController.text;
                              myGift.giftDescription = giftDescController.text;
                              myGift.imageUrl =
                                  await apiservice.fetchImage(myGift.giftName);

                              // Add it to giftList to be read, also to firebase db
                              setState(() {
                                giftList.add(myGift.giftName);
                                giftDescriptionList.add(myGift.giftDescription);
                                giftImageUrlList.add(myGift.imageUrl);
                                dbservice.createGift(
                                    myGift, widget.user.uniqueID);
                              });

                              // Close the dialog box
                              Navigator.pop(context);
                            }
                          }),
                      FlatButton(
                        child: Text('Cancel'),
                        color: Colors.pink[50],
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future addDateIdea(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SimpleDialog(
                title: Text('Add Date Idea', textAlign: TextAlign.center),
                backgroundColor: Colors.blue[100],
                contentPadding: EdgeInsets.all(10.0),
                children: <Widget>[
                  TextFormField(
                    controller: dateTextController,
                    validator: (dateInput) {
                      if (dateInput.isEmpty) {
                        return 'Date cannot be empty.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 13.0, horizontal: 10.0),
                      filled: true,
                      hintText: 'Date',
                      hintStyle:
                          TextStyle(fontSize: 20.0, color: Colors.grey[700]),
                      fillColor: Colors.white70,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        color: Colors.pink[50],
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            // Set date attributes
                            myDate.dateName = dateTextController.text;
                            myDate.imageUrl =
                                await apiservice.fetchImage(myDate.dateName);

                            // Close the dialog box
                            Navigator.pop(context);

                            // Add date chosen to list and firebase db
                            showDatePicker(myDate);
                          }
                        },
                      ),
                      FlatButton(
                        child: Text('Cancel'),
                        color: Colors.pink[50],
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  // ignore: must_call_super
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
                    accountName: new Text(
                      "${widget.user.firstName}" + " ${widget.user.lastName}",
                      style: TextStyle(color: Colors.white),
                    ),
                    accountEmail: new Text(
                      "${widget.user.email}",
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/drawer_header_bgimg.jpg"), // background image to fit whole page
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
                    trailing:
                        Icon(Icons.power_settings_new, color: Colors.grey),
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
                          MaterialPageRoute(
                              builder: (context) => TermsOfServicePage()));
                    },
                  ),
                ],
              ),
            )),
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Trips', icon: Icon(Icons.local_airport)),
                  Tab(text: 'Gifts', icon: Icon(Icons.card_giftcard)),
                  Tab(text: 'Dates', icon: Icon(Icons.restaurant)),
                ],
              ),
              title: Text("Welcome, " + "${widget.user.firstName}" + '!',
                  style: TextStyle(color: Colors.white)),
              centerTitle: true,
            ),
            body: TabBarView(
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
          return SingleChildScrollView(
            child: SimpleDialog(
              title: Text('New Password', textAlign: TextAlign.center),
              backgroundColor: Colors.blue[100],
              contentPadding: EdgeInsets.all(10.0),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: true,
                      validator: (passwordInput) {
                        if (passwordInput.isEmpty) {
                          return 'Password cannot be empty.';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 10.0),
                        filled: true,
                        hintText: 'Password',
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.grey[700]),
                        fillColor: Colors.white70,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          updatePassword(newPasswordController.text);
                        }
                      },
                      child: Text('Submit'),
                      color: Colors.pink[50],
                    ),
                  ],
                )
              ],
            ),
          );
        });
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
          fontSize: 16.0);

      // Log out and make user login again
      signOut();
    }).catchError((error) {
      // Error message in a toast
      if (newPassword.isEmpty) {
        Fluttertoast.showToast(
            msg: "Password can not be empty.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (newPassword.length < 6) {
        Fluttertoast.showToast(
            msg: "Password must be at least 6 characters.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  // Sign user out then go back to login page
  signOut() async {
    await auth.logout();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
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
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 250,
        width: double.maxFinite,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Stack(
            children: <Widget>[
              Align(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(tripImageUrlList[index]),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              // Trip name text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(tripList[index],
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                  // Trip date text
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(tripDescriptionList[index],
                          style: TextStyle(color: Colors.white)),
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
                      padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.local_airport),
                          color: Colors.green[200],
                          onPressed: () {
                            HelperFunctions.bookTrip(tripList[index]);
                          },
                        ),
                      )),
                  // Add to Calendar icon
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.calendar_today),
                          color: Colors.blue[200],
                          onPressed: () {
                            HelperFunctions.addDateToCalendar(tripList[index]);
                          },
                        ),
                      )),
                  // Delete trip button
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(Icons.delete_forever),
                          color: Colors.red[200],
                          onPressed: () {
                            Trip tripObjToDelete = Trip(
                                tripName: tripList.elementAt(index),
                                tripDate: tripDescriptionList.elementAt(index),
                                imageUrl: tripImageUrlList.elementAt(index));
                            removeTrip(tripObjToDelete, index);
                          },
                        ),
                      )),
                ],
              ))
            ],
          ),
        ));
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
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 200,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(giftImageUrlList[index])),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Gift name text
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(giftList[index],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
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
                      padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.green[200],
                          onPressed: () {
                            HelperFunctions.launchSearchGift(giftList[index]);
                          },
                        ),
                      )),
                  // Delete gift button
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(Icons.delete_forever),
                          color: Colors.red[200],
                          onPressed: () {
                            Gift giftObjToDelete = Gift(
                                giftName: giftList.elementAt(index),
                                giftDescription:
                                    giftDescriptionList.elementAt(index),
                                imageUrl: giftImageUrlList.elementAt(index));
                            removeGift(giftObjToDelete, index);
                          },
                        ),
                      )),
                ],
              ))
            ],
          ),
        ));
  }

  Widget _buildDateItem(BuildContext context, int index) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 250,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(dateImageUrlList[index]),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              // Date name text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(dateList[index],
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ),
                  // Date description text
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        dateDescriptionList[index],
                        style: TextStyle(color: Colors.white),
                      ),
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
                      padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.green[200],
                          onPressed: () {
                            HelperFunctions.launchSearchDate(dateList[index]);
                          },
                        ),
                      )),
                  // Add to Calendar icon
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.calendar_today),
                          color: Colors.blue[200],
                          onPressed: () {
                            HelperFunctions.addDateToCalendar(dateList[index]);
                          },
                        ),
                      )),
                  // Delete date button
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(Icons.delete_forever),
                          color: Colors.red[200],
                          onPressed: () {
                            Date dateObjToDelete = Date(
                                dateName: dateList.elementAt(index),
                                dateDescription:
                                    dateDescriptionList.elementAt(index),
                                imageUrl: dateImageUrlList.elementAt(index));
                            removeDate(dateObjToDelete, index);
                          },
                        ),
                      )),
                ],
              ))
            ],
          ),
        ));
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

  // Reads trips in firebase db and displays them on screen
  void getTripsAtStartup() {
    dbservice
        .readTrips(tripList, tripDescriptionList, widget.user.uniqueID)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> trips = snapshot.value;
      trips.forEach((key, value) {
        setState(() {
          tripList.add(value["title"]);
          tripDescriptionList.add(value["description"]);
          tripImageUrlList.add(value["imageUrl"]);
        });
      });
    });
  }

  // Reads gifts in firebase db and displays them on screen
  void getGiftsAtStartup() {
    dbservice
        .readGifts(giftList, giftDescriptionList, widget.user.uniqueID)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> gifts = snapshot.value;
      gifts.forEach((key, value) {
        setState(() {
          giftList.add(value["title"]);
          giftDescriptionList.add(value["description"]);
          giftImageUrlList.add(value["imageUrl"]);
        });
      });
    });
  }

  // Reads dates in firebase db and displays them on screen
  void getDatesAtStartup() {
    dbservice
        .readDates(dateList, dateDescriptionList, widget.user.uniqueID)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> dates = snapshot.value;
      dates.forEach((key, value) {
        setState(() {
          dateList.add(value["title"]);
          dateDescriptionList.add(value["description"]);
          dateImageUrlList.add(value["imageUrl"]);
        });
      });
    });
  }

  // Function to delete trip from list and firebase db
  void removeTrip(Trip tripDelete, int index) {
    // Delete the gift from the list
    setState(() {
      tripList.removeAt(index);
      tripDescriptionList.removeAt(index);
      tripImageUrlList.removeAt(index);
    });

    // Delete from firebase DB
    dbservice.deleteTrip(tripDelete, widget.user.uniqueID);
  }

  // Function to delete gift from list and firebase db
  void removeGift(Gift giftDelete, int index) {
    // Delete the gift and its details from all the lists
    setState(() {
      giftList.removeAt(index);
      giftDescriptionList.removeAt(index);
      giftImageUrlList.removeAt(index);
    });

    // Delete from firebase DB
    dbservice.deleteGift(giftDelete, widget.user.uniqueID);
  }

  // Function to delete date from list and firebase db
  void removeDate(Date dateDelete, int index) {
    // Delete the date attributes from all lists
    setState(() {
      dateList.removeAt(index);
      dateDescriptionList.removeAt(index);
      dateImageUrlList.removeAt(index);
    });

    // Delete from firebase DB
    dbservice.deleteDate(dateDelete, widget.user.uniqueID);
  }

  // Function to let user to choose the date of the trip and
  // add it to the list and Firebase db
  void showTripPicker(Trip trip) {
    String _date;

    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      theme: DatePickerTheme(
          headerColor: Colors.orange[200],
          backgroundColor: Colors.blue[200],
          itemStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
      minTime: DateTime.now(),
      onChanged: (date) {},
      onConfirm: (date) {
        _date = '${date.month}/${date.day}/${date.year}';
        trip.tripDate = _date;

        // Add it to tripList to be read, also to firebase db
        setState(() {
          tripList.add(trip.tripName);
          tripDescriptionList.add(trip.tripDate);
          tripImageUrlList.add(trip.imageUrl);
          dbservice.createTrip(trip, widget.user.uniqueID);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  // Function to let user to choose the date of the date and
  // add it to the list and Firebase db
  void showDatePicker(Date _date) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      theme: DatePickerTheme(
          headerColor: Colors.orange[200],
          backgroundColor: Colors.blue[200],
          itemStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
      minTime: DateTime.now(),
      onChanged: (date) {},
      onConfirm: (date) {
        _date.dateDescription = '${date.month}/${date.day}/${date.year}';

        // Add it to dateList to be read, also to firebase db
        setState(() {
          dateList.add(_date.dateName);
          dateDescriptionList.add(_date.dateDescription);
          dateImageUrlList.add(_date.imageUrl);
          dbservice.createDate(_date, widget.user.uniqueID);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }
}
