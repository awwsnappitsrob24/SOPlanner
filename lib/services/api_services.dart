import 'package:http/http.dart' as http;
import 'package:vivi_bday_app/models/bingimage.dart';
import 'dart:convert' as convert;
import 'package:vivi_bday_app/models/cardimage.dart';

class APIServices {
  // Method to call the Bing Web Search API to search
  // for images based on the user query
  Future<String> fetchImage() async {
    final response = await http.get(
      'https://api.cognitive.microsoft.com/bing/v7.0/search?q=bill gates&count=1&offset=0&mkt=en-us&safesearch=Moderate',
      headers: {
        "Ocp-Apim-Subscription-Key": "446a0739cfc94887b4ff068e5956789d"
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON and retrieve the contentUrl.
      Map<String, dynamic> map = convert.json.decode(response.body);
      List<dynamic> imageDetails = map["images"]["value"];
      BingImage bingImage = BingImage(
        id: map["images"]["id"],
        readLink: map["images"]["readLink"],
        webSearchUrl: map["images"]["webSearchUrl"],
        isFamilyFriendly: map["images"]["isFamilyFriendly"],
        imageDetails: imageDetails,
      );

      CardImage cardImage = CardImage(
          // populate variables from json output
          webSearchUrl: bingImage.imageDetails[0]["webSearchUrl"],
          thumbnailUrl: bingImage.imageDetails[0]["thumbnailUrl"],
          contentUrl: bingImage.imageDetails[0]["contentUrl"]);

      return cardImage.contentUrl;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load image');
    }
  }
}
