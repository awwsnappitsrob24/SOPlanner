// Model class for a card image
class CardImage {
  String webSearchUrl, thumbnailUrl, contentUrl;

  CardImage({this.webSearchUrl, this.thumbnailUrl, this.contentUrl});

  // Get all variables from the JSON result
  factory CardImage.fromJson(Map<String, dynamic> json) => CardImage(
    webSearchUrl: json["webSearchUrl"],
    thumbnailUrl: json["thumbnailUrl"],
    contentUrl: json["contentUrl"],
  );

  Map<String, dynamic> toJson() =>
    {
      'webSearchUrl' : webSearchUrl,
      'thumbnailUrl' : thumbnailUrl,
      'contentUrl' : contentUrl
    };
}