
class UrlResponseModel {
  
  late int id;
  String originalUrl;
  String shortenUrl;
  
  UrlResponseModel(this.originalUrl, this.shortenUrl);

  factory UrlResponseModel.fromJson(Map<String, dynamic> json) {
    return UrlResponseModel(json['originalUrl'], json['shortenUrl']);
  }

}