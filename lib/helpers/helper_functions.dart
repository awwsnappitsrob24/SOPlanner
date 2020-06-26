import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperFunctions {

  static String query;

  static bookTrip(query) async {
    var url = " ";

    // Open using Expedia as the main search 
    // Split query if more than one word
    List<String> splitString = [];
    splitString = query.split(" ");

    // Expedia test
    if(splitString.length < 2) {
      url = 'https://www.expedia.com/Hotel-Search?destination=' + splitString[0];
    }
    else {
      int lengthOfString = splitString.length;
      url = 'https://www.expedia.com/Hotel-Search?destination=';
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

  static void launchSearchGift(query) async {
    var url = " ";

    // Open using Amazon as the main search 
    // Split query if more than one word
    List<String> splitString = [];
    splitString = query.split(" ");

    // Amazon test
    if(splitString.length < 2) {
      url = 'https://www.amazon.com/s?k=' + splitString[0];
    }
    else {
      int lengthOfString = splitString.length;
      url = 'https://www.amazon.com/s?k=';
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

  static addDateToCalendar(query) {
    final Event dateEvent = Event(
      title: query,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );

    Add2Calendar.addEvent2Cal(dateEvent);
  }


  static launchSearchDate(query) async {
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
}