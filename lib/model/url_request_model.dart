class UrlRequestModel{
  String url;
  
  UrlRequestModel(this.url);

  Map<String, dynamic> toJson() => 
  {
    "url": url
  };
}