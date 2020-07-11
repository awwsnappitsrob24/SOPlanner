// Model class for a bing image result from API

class BingImage {

  String id, readLink, webSearchUrl;
  bool isFamilyFriendly;
  List<dynamic> imageDetails;

  BingImage({this.id, this.readLink, this.webSearchUrl, this.isFamilyFriendly, this.imageDetails});


  // Get all variables from the JSON result
  factory BingImage.fromJson(Map<String, dynamic> json) => BingImage(
    id: json["images"]["id"],
    readLink: json["images"]["readLink"],
    webSearchUrl: json["images"]["webSearchUrl"],
    isFamilyFriendly: json["images"]["isFamilyFriendly"],
    imageDetails: json["images"]["value"]
  );

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'readLink': readLink,
      'webSearchUrl': webSearchUrl,
      'isFamilyFriendly': isFamilyFriendly,
      'image': imageDetails
    };
}