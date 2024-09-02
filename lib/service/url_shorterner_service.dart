import 'dart:convert';
import 'dart:io';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:url_shortener_flutter_client/constants.dart';
import 'package:http/http.dart' as http;
import 'package:url_shortener_flutter_client/model/url_request_model.dart';
import 'package:url_shortener_flutter_client/model/url_response_model.dart';
import 'package:url_shortener_flutter_client/model/url_response_page_model.dart';

class UrlShortenerService {

  Future<UrlResponsePageModel> getAllShortenedUrl (int page, int limit) async {
    try {
      SmartDialog.showLoading();
      final apiResponse =  await http.get(Uri.parse("${Constants.endPointUrl}?page=$page&limit=$limit"), headers: {
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      }).timeout(Duration(seconds: 60), onTimeout: () => throw Exception("Api response timeout"));

      SmartDialog.dismiss();
      if(apiResponse.statusCode == 200){
        var result = json.decode(apiResponse.body);
        return UrlResponsePageModel(result['next'], result['total'], result['records'].cast<Map<String, dynamic>>());
      } else {
        throw Exception("Api response exception");
      }
    } on Error catch (e) {
      e.stackTrace.toString();
      rethrow;
    }
  }

  Future<UrlResponseModel> shortenUrl (UrlRequestModel urlRequestModel) async {
    try {
      SmartDialog.showLoading();
      final apiResponse =  await http.post(Uri.parse(Constants.endPointUrl), 
      body: jsonEncode(urlRequestModel.toJson()),
      headers: {
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      }).timeout(Duration(seconds: 60), onTimeout: () => throw Exception("Api response timeout"));

      SmartDialog.dismiss();
      if(apiResponse.statusCode == 201){
        var result = json.decode(apiResponse.body);
        return UrlResponseModel(result['originalUrl'], result['shortenUrl']);
      } else {
        throw Exception("Api response exception");
      }
    } on Error catch (e) {
      e.stackTrace.toString();
      rethrow;
    }
  }
}