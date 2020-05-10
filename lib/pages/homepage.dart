import 'dart:io';
import 'dart:math';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:firebase_database/firebase_database.dart' hide Event;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vivi_bday_app/Setup/login.dart';
import 'package:vivi_bday_app/pages/termsofservice.dart';
import 'package:vivi_bday_app/pages/SendNotificationsPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Homepage extends StatefulWidget {
  final User user;

  const Homepage({Key key, this.user}): super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin<Homepage> {
  final List<String> giftList = [];
  final List<String> dateList = [];
  File uploadedImage;
  String fileName, lastImageUrl = "", userFirstName, userLastName, userEmail, _email;
  int userID, userUniqueID;
  int fileNum = 0;
  TextEditingController giftTextController = new TextEditingController();
  TextEditingController dateTextController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  FirebaseUser currentUser;
  FirebaseDatabase database = new FirebaseDatabase();
  Image currentPic = Image.asset('assets/images/default_picture.jpg');

  @override
  void initState() {

    super.initState();

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    // Get user list of gifts, dates from firebase database at initial startup
    readGifts();
    readDates();

    // Build everything in the start
    build(this.context);
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
                        currentAccountPicture: GestureDetector(
                          onTap: () {
                            // change profile picture to what user picks
                            print('Clicked');
                          },
                          child:  CircleAvatar(
                            // change currentPic to whatever user chose to upload
                            child: currentPic,
                          ), 
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/drawer_header_bgimg.jpg"), // background image to fit whole page
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Add gift idea tile
                      ListTile(
                        title: Text("Add Gift Ideas"),
                        trailing: Icon(Icons.card_giftcard, color: Colors.grey),
                        onTap: () {
                          addGiftIdea(context);
                        },
                      ),
                      // Add date idea tile
                      ListTile(
                        title: Text("Add Date Ideas"),
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
                          logout();
                        },
                      ),
                      // Divider to divide app security with terms of security
                      Divider(),
                      ListTile(
                        title: Text("Terms of Security"),
                        trailing: Icon(Icons.security, color: Colors.grey),
                        onTap: () {
                          viewTermsOfService();
                        },
                      ),
                    ],
                  ),
                )
            ),
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Gifts', icon: Icon(Icons.card_giftcard)),
                  Tab(text: 'Dates', icon: Icon(Icons.restaurant)),
                  Tab(text: 'Messages', icon: Icon(Icons.mood)),
                ],
              ),
              title: Text("Welcome, " + "${widget.user.firstName}" + '!', style: TextStyle(color: Colors.yellow)),
              centerTitle: true,
            ),
            body: TabBarView (
              children: [
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

  // Show dialog for changing password
  void showPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('New Password', textAlign: TextAlign.center),
          backgroundColor: Colors.yellow[200],
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
                RaisedButton(
                  onPressed: () {
                    updatePassword(newPasswordController.text);
                  },
                  child: Text('Submit'), color: Colors.deepPurple[100],
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

      user.updatePassword(newPassword).then((_) {
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage())
        );
      }).catchError((error) {
        // Error message in a toast
        if(newPassword.isEmpty) {
          Fluttertoast.showToast(
            msg: "Password cannot be empty.",
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

  // Go to Terms of Security page
  void viewTermsOfService() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsOfServicePage())
    );
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
              leading: Icon(Icons.card_giftcard),
              title: Text(giftList[index], textAlign: TextAlign.left),
              trailing: Icon(Icons.keyboard_arrow_right),
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
              leading: Icon(Icons.restaurant),
              title: Text(dateList[index], textAlign: TextAlign.left),
              trailing: Icon(Icons.keyboard_arrow_right),
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

  // USE USERID INSIDE CHILD TO CREATE EXTRA LEVEL!! UserId -> gift/date -> gift idea/date idea
  // widget.user.uniqueID.toString()??
  void createGift(String giftName) {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    FirebaseDatabase.instance.reference().child("gifts").child(newNum.toString())
        .set({
      'title': giftName,
    });
  }

  void createDate(String dateName) {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    FirebaseDatabase.instance.reference().child("dates").child(newNum.toString())
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
}