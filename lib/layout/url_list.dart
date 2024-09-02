import 'package:flutter/material.dart';
import 'package:url_shortener_flutter_client/constants.dart';
import 'package:url_shortener_flutter_client/model/url_request_model.dart';
import 'package:url_shortener_flutter_client/model/url_response_page_model.dart';
import 'package:url_shortener_flutter_client/service/url_shorterner_service.dart';

class UrlList extends StatefulWidget {
  
  const UrlList({super.key});
  
  @override
  State<UrlList> createState() => UrlListState();
  
}

class UrlListState extends State<UrlList> with RestorationMixin {
  
  final RestorableInt _rowsPerPage = RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  UrlResponsePageModel urlResponsePageModel = UrlResponsePageModel.init();
  bool initialized = false;
  TextEditingController urlController = TextEditingController();
  final _formKeyUrl = GlobalKey<FormState>();
  
  @override
  String? get restorationId => "url_list_data_table";

  @override
  void initState() {
    UrlShortenerService().getAllShortenedUrl(0, 10).then((UrlResponsePageModel value) => {
      handle(value)
    });
    initialized = true;
    super.initState();
  }

  handle(UrlResponsePageModel responsePage){
    setState(() {
      urlResponsePageModel = responsePage;
    });
  }
  
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {

    if (!initialized) {
      UrlShortenerService().getAllShortenedUrl(0, 10).then((UrlResponsePageModel value) => {
        handle(value)
      });
      initialized = true;
    }

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      UrlShortenerService().getAllShortenedUrl(0, 10).then((UrlResponsePageModel value) => {
        handle(value)
      });
      initialized = true;
    }
  }

  @override
  void dispose() {
    _rowsPerPage.dispose();
    super.dispose();
  }

  Future<void> getDialogModal(BuildContext context){
    return showDialog<void>(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Shorten your url"),
          insetPadding: EdgeInsets.all(10),
          content: Container(
            height: 100,
            width: 300,
            child: Form(
              key: _formKeyUrl,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: urlController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Enter your url"
                    ),
                    validator: (value) {
                      if(null == value || value.isEmpty) return "Your url cannot be empty!";
                      return null;
                    },
                  )
                ], 
              )
              ),
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
            TextButton(
              child: Text("Shorten"),
              onPressed: () {
                if(_formKeyUrl.currentState!.validate()){
                  Navigator.of(context).pop(); 
                  shortenUrl(context, urlController.text);   
                }
              }
            )
          ],
        );
      }
    );
  }

  shortenUrl(BuildContext context, String url){
    var apiResponse = UrlShortenerService().shortenUrl(UrlRequestModel(url));
    apiResponse.then((value) {
      showDialog(
            context: context,
            builder: (_) => AlertDialog(
                title: Row(children: <Widget>[
                  Text(
                    "Information",
                    style: TextStyle(color: Colors.green),
                  )
                ]),
                content: Text(
                    "Your shorten url is ${Constants.apiBaseUrl}${value.shortenUrl}"),
                actions: <Widget>[
                  TextButton(
                    onPressed: ()  {
                      Navigator.of(context).pop();
                      initState();
                    }, 
                    child: Text("Close"))
                ],));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("List of shortened URLs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton.icon(
                label: Text("Shorten an Url"),
                icon: Icon(Icons.short_text, size: 18),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.blue
                  )
                ),
              onPressed: () => getDialogModal(context)
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: const Text('#'),
                      numeric: true
                    ),
                    DataColumn(
                      label: const Text('Original URL'),
                    ),
                    DataColumn(
                      label: const Text('Shorten URL'),
                    ),
                  ],
                  rows: List<DataRow>.generate(urlResponsePageModel.total,
                      (index) => urlResponsePageModel.getRow(index))),
              )
            )
          ],
        ),
      )
    );
  }
  
}