import 'package:vivi_bday_app/models/user.dart';
import 'package:vivi_bday_app/models/trip.dart';
import 'package:vivi_bday_app/models/gift.dart';
import 'package:vivi_bday_app/models/date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class DBServices {

  /// The following functions are create functions to add trips, gifts, 
  /// and dates. These following models can be added to Firebase at the
  /// user's request.
  
  // Function to add trip ideas to Firebase
  void createTrip(Trip newTrip, int userID) async {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    FirebaseDatabase.instance.reference()
      .child(userID.toString())
      .child("trips")
      .child(newNum.toString())
      .set({
        'title': newTrip.tripName,
        'description': newTrip.tripDate,
      });
  }

  // Function to add gift ideas to Firebase
  void createGift(Gift newGift, int userID) async {
    var randomNum = new Random();
    var newNum = randomNum.nextInt(1000000);
    FirebaseDatabase.instance.reference()
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
    FirebaseDatabase.instance.reference()
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

  DatabaseReference readTrips(List<String> tripList, List<String> tripDescList, int userID) {
    return FirebaseDatabase.instance.reference()
      .child(userID.toString())
      .child("trips");
  }

  // Reads gifts in firebase db and displays them on screen
  DatabaseReference readGifts(List<String> giftList, List<String> giftDescList, int userID) {
    return FirebaseDatabase.instance.reference()
      .child(userID.toString())
      .child("gifts");
  }

  // Reads dates in firebase db and displays them on screen
  DatabaseReference readDates(List<String> dateList, List<String> dateDescList, int userID) {
    return FirebaseDatabase.instance.reference()
      .child(userID.toString())
      .child("dates");
  }
}