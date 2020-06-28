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
}