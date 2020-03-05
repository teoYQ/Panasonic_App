import 'package:flutter/material.dart';
import 'package:panasonic_v1/activities.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Page Flutter "),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0), // <= NEW
                Text(
                  'Login Information',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20.0), // <= NEW
                TextFormField(
                    onSaved: (value) => _email = value,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email Address")),
                TextFormField(
                    onSaved: (value) => _password = value,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password")),
                SizedBox(height: 20.0), // <= NEW
                RaisedButton(
                    child: Text("LOGIN"),
                    onPressed: () {
                      final form = _formKey.currentState;
                      form.save();

                      // Validate will return true if is valid, or false if invalid.
                      if (form.validate()) {
                        print("$_email $_password");
                        Navigator.push(context,
                        MaterialPageRoute(builder:(context)=> ActivitiesPage()),);
                        
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
