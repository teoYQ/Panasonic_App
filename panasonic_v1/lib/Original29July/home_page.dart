import 'package:flutter/material.dart';
import 'package:panasonic_v1/login_page.dart';
import 'signup_page.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Flutter Firebase"),
        //actions: <Widget>[LogoutButton()],
      ),
      body: Container(
        padding: EdgeInsets.only(top:50),
        child:Column(
          
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Image.asset('assets/panasonic.png'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             RaisedButton(
              child: Text("Sign In"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            RaisedButton(
              child: Text("Sign Up"),
              onPressed: (){
                Navigator.push(context,
                MaterialPageRoute(builder:(context)=> SignUpPage()),);
              },)
          ],
        ),
        ],)

      ),
    );
  }
}
