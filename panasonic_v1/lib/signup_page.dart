import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panasonic_v1/login_page.dart';
import 'dart:async';
import 'dart:io';
import 'package:panasonic_v1/authentication.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.auth, this.loginCallback})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback loginCallback;
  // final String userId;
  @override
  _SignUpPageState createState() => _SignUpPageState(auth);
}

class _SignUpPageState extends State<SignUpPage> {
  static FirebaseDatabase database = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  BaseAuth auth;
  _SignUpPageState(this.auth);
  String _password;
  String _email;
  String _name;
  File _image;
  String _errorMessage;
  bool _isSignUpForm;
  bool _isLoading;
  int _curIndex = 0;
  Future getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  File _pickedImage =File("assets/shoppingcart.png") ;

  Future _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));
    if (imageSource != null) {
      final file = await ImagePicker.pickImage(
          source: imageSource, maxHeight: 100, maxWidth: 100);
      if (file != null) {
        setState(() => _pickedImage = file
        );
        setState(() {
          _curIndex = 1;
        });
      }
    }
  }

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
        if (_isSignUpForm) {
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up user: $userId');
        } else {
          print('Signed in: $userId');
          // userId = await widget.auth.signIn(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          // print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isSignUpForm) {
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
                    "Sign Up",
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
              child: Form(
              key: _formKey,
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
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: IndexedStack(
                                    index: _curIndex,
                                    children: <Widget>[
                                      MaterialButton(
                                        color: Colors.white,
                                        shape: CircleBorder(),
                                        onPressed: () {
                                          _pickImage();
                                          
                                        },
                                        child: Icon(Icons.camera_alt),
                                      ),
                                      CircleAvatar(
                                          backgroundColor: Colors.grey[900],
                                          radius: 50,
                                          child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image:
                                                          new ExactAssetImage(
                                                              _pickedImage
                                                                  .path)))

                                          /*_pickedImage == null
                                        ? Text("?")
                                        : Image.file(_pickedImage),
                                        */
                                          ),
                                      )
                                    ]),
                                /*child: Row(
                                    children: <Widget>[
                                      Expanded(child: CircleAvatar(
                                backgroundColor: Colors.grey[900],
                                radius: 50,
                                child: _image == null ? Text("?") : Image.file(_image) ,
                              )),
                              Expanded(child: MaterialButton(
                                color: Colors.white,
                                shape: CircleBorder(),
                                onPressed: (){
                                  _pickImage();
                              },
                                child: Icon(Icons.camera_alt),
                              ))

                                    ]
                                  )*/
                              ),
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
                                  onSaved: (value) => _name = value,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Name",
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
                        SizedBox(
                          height: 40,
                        ),
                        //FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Colors.grey),)),
                        FlatButton(
                            onPressed: () {
                              final form = _formKey.currentState;
                              form.save();
                              // if (validateAndSave()) {
                              // validateAndSubmit();
                              widget.auth.signUp(_email, _password);
                              database.reference().child("Users").push().set({_name : _email});
                              // }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage(auth : new Auth()),),
                              );
                              // Validate will return true if is valid, or false if invalid.
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
                            )),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
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
