import 'package:flutter/material.dart';
import 'package:panasonic_v1/login_page.dart';
import 'home_page.dart';
import 'package:panasonic_v1/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "LGC"
      ),
      // home: HomePage(),
      home: LoginPage(auth : new Auth()),
    );
  }
}