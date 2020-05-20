import 'package:flutter/material.dart';
// import 'package:panasonicv1/authservice.dart'
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:panasonic_v1/activities.dart';
import 'package:panasonic_v1/signup_page.dart';
import 'package:panasonic_v1/authentication.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.auth, this.userId, this.loginCallback})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final String userId;

  @override
  _LoginPageState createState() => _LoginPageState();
}
final FirebaseAuth _auth = FirebaseAuth.instance;

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;
  String _errorMessage;
  bool _isLoginForm;
  bool _isLoading;
  static FirebaseDatabase database = FirebaseDatabase.instance;
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }
  // void findName() async {
  //   String username = "";
  //   try{
  //     username = await database.reference().child('Users').orderByValue().equalTo("$_email").once();
  //   }catch (e) {
  //       print('Error: $e');
  //       setState(() {
  //         _isLoading = false;
  //         _errorMessage = e.message;
  //         _formKey.currentState.reset();
  //       });
  //     }
  //   return username;
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.green[900],
          Colors.green[800],
          Colors.green[400]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),

                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.green[100],
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  onSaved: (value) => _email = value,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      hintText: "Email or Phone number",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  onSaved: (value) => _password = value,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        //FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Colors.grey),)),
                        FlatButton(
                            onPressed: () {
                              final form = _formKey.currentState;
                              if (validateAndSave()) {
                                // print("$_email $_password");
                                widget.auth.signIn("$_email", "$_password");
                                // database.reference().child("Users").equalTo("$_email");
                                var _name = widget.auth.getName("$_email",database);
                                print('DIS MAH NAME $_name'); 
                                print("SENDING");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActivitiesPage(auth: widget.auth, email : "$_email", name : "$_name")),
                                );
                              }
                              /*form.save();

                              // Validate will return true if is valid, or false if invalid.
                              if (form.validate()) {
                                print("$_email $_password");
                                _auth.signInWithEmailAndPassword(
                                    email: "$_email", password: "$_password");
                                print('login successful');
                                FirebaseDatabase database =
                                    FirebaseDatabase.instance;
                                DatabaseReference myRef = database.reference();
                                DateTime current_time = DateTime.now();
                                myRef.set(
                                    "user $_email with password $_password logged it at $current_time");
                                print('write successful');
                                _auth.signOut();
                                print('logout successful');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActivitiesPage()),
                                );
                              }*/
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => ActivitiesPage()),
                              // );
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.green[900]),
                              child: Center(
                                child: Text(
                                  "Log In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),

                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage(auth: widget.auth)),
                              );
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.green[900]),
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
