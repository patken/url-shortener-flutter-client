import 'package:flutter/material.dart';
import 'package:url_shortener_flutter_client/constants.dart';
import 'package:url_shortener_flutter_client/model/url_response_model.dart';

class UrlResponsePageModel extends DataTableSource {

  String next = "";
  int total = 0;
  List<Map<String, dynamic>> records = List.empty();

  UrlResponsePageModel.init() {
    next = "";
    total = 0;
    records = List.empty();
  }

  UrlResponsePageModel(this.next, this.total, this.records);
  
  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final urlResponseModel = UrlResponseModel.fromJson(records[index]);
    urlResponseModel.id = index + 1;
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(urlResponseModel.id.toString())),
        DataCell(Text(urlResponseModel.originalUrl)),
        DataCell(Text("${Constants.apiBaseUrl}${urlResponseModel.shortenUrl}"))
      ]);
  }
  
  @override
  bool get isRowCountApproximate => false;
  
  @override
  int get rowCount => records.length;
  
  @override
  int get selectedRowCount => throw UnimplementedError();
}