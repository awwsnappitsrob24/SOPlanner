import 'package:http/http.dart' as http;
import 'package:vivi_bday_app/models/bingimage.dart';
import 'dart:convert' as convert;
import 'package:vivi_bday_app/models/cardimage.dart';

class APIServices {
  // Method to call the Bing Web Search API to search
  // for images based on the user query
  Future<String> fetchImage(String query) async {
    /**
     * Todo: Functionalities are done, just refactor some code and it's a wrap for this branch
     */
    final response = await http.get(
      Uri.parse(
          'https://api.cognitive.microsoft.com/bing/v7.0/search?q=$query&count=1&offset=0&mkt=en-us&safesearch=Moderate'),
      headers: {"Ocp-Apim-Subscription-Key": "your-key-here"},
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON and retrieve the contentUrl.
      Map<String, dynamic> map = convert.json.decode(response.body);
      List<dynamic> imageDetails;

      // For some searches, the "images" result is empty, so this value may be null
      // If it is, look in the entities->value->image->thumbnailUrl
      // If neither is present, return the url for a no image avilable image
      String contentUrl = " ";
      if (map.containsKey("images")) {
        imageDetails = map["images"]["value"];
      } else if (map.containsKey("entities")) {
        imageDetails = map["entities"]["value"];
        contentUrl = imageDetails[0]["image"]["hostPageUrl"];
        return contentUrl;
      } else {
        return "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png";
      }

      // For searches with the "images" result in it, create a BingImage
      // and CardImage object to extract the contentUrl from the JSON output
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

      return cardImage.thumbnailUrl;
    } else {
      // If the server did not return a 200 OK response,
      // then return a String that will search a no available image.
      return "No image available";
    }
  }
}
