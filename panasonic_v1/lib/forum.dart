import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:panasonic_v1/DIYpage.dart';
import 'package:panasonic_v1/analyticspage.dart';
//import 'package:panasonic_v1/monitorpage.dart';
import 'package:panasonic_v1/shoppage.dart';
import 'package:panasonic_v1/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:panasonic_v1/toggle_buttons.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          elevation: 0.0,
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
            child: Stack( 
            children: <Widget>[
           
            WebView(
            initialUrl: 'https://www.facebook.com/groups/541659439845227',
            javascriptMode: JavascriptMode.unrestricted,
          ),
           Container(
              color: Colors.green[900],
              height: 1.0,
              width: 468,
            
          ),]));
        }));
  }
}
