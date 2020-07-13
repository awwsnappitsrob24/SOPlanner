import 'package:vivi_bday_app/models/user.dart';
import 'package:vivi_bday_app/models/trip.dart';
import 'package:vivi_bday_app/models/gift.dart';
import 'package:vivi_bday_app/models/date.dart';
import 'package:vivi_bday_app/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class DBServices {
  /// The following functions are create functions to add trips, gifts,
  /// and dates. These following models can be added to Firebase at the
  /// user's request.
  APIServices apiservice = APIServices();

  // Function to add trip ideas to Firebase
  void createTrip(Trip newTrip, int userID) async {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    FirebaseDatabase.instance
        .reference()
        .child(userID.toString())
        .child("trips")
        .child(newNum.toString())
        .set({
      'title': newTrip.tripName,
      'description': newTrip.tripDate,
      'imageUrl': newTrip.imageUrl
    });
  }

  // Function to add gift ideas to Firebase
  void createGift(Gift newGift, int userID) async {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    FirebaseDatabase.instance
        .reference()
        .child(userID.toString())
        .child("gifts")
        .child(newNum.toString())
        .set({
      'title': newGift.giftName,
      'description': newGift.giftDescription,
    });
  }

  // Function to add gift ideas to Firebase
  void createDate(Date newDate, int userID) async {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    FirebaseDatabase.instance
        .reference()
        .child(userID.toString())
        .child("dates")
        .child(newNum.toString())
        .set({
      'title': newDate.dateName,
      'description': newDate.dateDescription,
    });
  }

  /// The following functions are read functions to get trips, gifts,
  /// and dates from Firebase db. These objects are displayed
  /// at startup in a list of Cards.

  // Reads trips in firebase db and displays them on screen
  DatabaseReference readTrips(
      List<String> tripList, List<String> tripDescList, int userID) {
    return FirebaseDatabase.instance
        .reference()
        .child(userID.toString())
        .child("trips");
  }

  // Reads gifts in firebase db and displays them on screen
  DatabaseReference readGifts(
      List<String> giftList, List<String> giftDescList, int userID) {
    return FirebaseDatabase.instance
        .reference()
        .child(userID.toString())
        .child("gifts");
  }

  // Reads dates in firebase db and displays them on screen
  DatabaseReference readDates(
      List<String> dateList, List<String> dateDescList, int userID) {
    return FirebaseDatabase.instance
        .reference()
        .child(userID.toString())
        .child("dates");
  }

  /// The following functions are delete functions to remove trips, gifts,
  /// and dates from Firebase db. Duplicates are also removed, if any.

  // Function to delete a selected trip idea from the list from db
  void deleteTrip(Trip tripDelete, int userID) {
    var db = FirebaseDatabase.instance
        .reference()
        .child(userID.toString())
        .child("trips");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> trips = snapshot.value;
      trips.forEach((key, value) {
        // Check for value in DB to delete
        if (value["title"] == tripDelete.tripName &&
            value["imageUrl"] == tripDelete.imageUrl &&
            value["description"] == tripDelete.tripDate) {
          // Delete the node form Firebase DB
          FirebaseDatabase.instance
              .reference()
              .child(userID.toString())
              .child("trips")
              .child(key)
              .remove();
        }
      });
    });
  }

  // Function to delete a selected gift idea from the list from db
  void deleteGift(String giftName, int userID) {
    var db = FirebaseDatabase.instance
        .reference()
        .child(userID.toString())
        .child("gifts");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> gifts = snapshot.value;
      gifts.forEach((key, value) {
        // Check for value in DB to delete
        if (value["title"] == giftName) {
          // Delete the node form Firebase DB
          FirebaseDatabase.instance
              .reference()
              .child(userID.toString())
              .child("gifts")
              .child(key)
              .remove();
        }
      });
    });
  }

  // Function to delete a selected trip idea from the list from db
  void deleteDate(String dateName, int userID) {
    var db = FirebaseDatabase.instance
        .reference()
        .child(userID.toString())
        .child("dates");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> dates = snapshot.value;
      dates.forEach((key, value) {
        // Check for value in DB to delete
        if (value["title"] == dateName) {
          // Delete the node form Firebase DB
          FirebaseDatabase.instance
              .reference()
              .child(userID.toString())
              .child("dates")
              .child(key)
              .remove();
        }
      });
    });
  }
}
