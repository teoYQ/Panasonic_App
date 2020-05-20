import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panasonic_v1/login_page.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import 'package:panasonic_v1/authentication.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.auth, this.loginCallback}) : super(key: key);
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
  String _uploadedUrl;
  int _curIndex = 0;
  Future getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  File _pickedImage = File("assets/shoppingcart.png");
  Future uploadFile(
    String email,
    String password,
  ) async {
    Auth userauth = new Auth();
    userauth.signIn(email, password);
    print(_pickedImage.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('profile/$email');
    // .child('profile/${Path.basename(_pickedImage.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_pickedImage);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedUrl = fileURL;
      });
    });
    userauth.signOut();
  }

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
        setState(() => _pickedImage = file);
        setState(() {
          _curIndex = 1;
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
                                    autovalidate: true,
                                    validator: (String value) {
                                      if (value.length == 0) {
                                        return "Required fill";
                                      }
                                      return value.contains('@')
                                          ? null
                                          : "Requires a valid email";
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                    autovalidate: true,
                                    validator: (String value) {
                                      bool result = true;
                                      if (value.length == 0) {
                                        return "Required fill";
                                      }
                                      if (value.contains(".") || (value.contains("\$")) || value.contains("[") || value.contains("]") || value.contains("#") || value.contains("/") ){
                                        result = false;
                                      }
                                      

                                      return result
                                          ? null
                                          : "No special characters allowed" ;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Name",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                    autovalidate: true,
                                    validator: (String value) {
                                      return value.length < 6
                                          ? "Minimum Password length is 6 characters"
                                          : null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                database
                                    .reference()
                                    .child("Users")
                                    .update({_name: _email});
                                database.reference().update({
                                  _name: {
                                    "dose": 0,
                                    "lights": "off",
                                    "temperature": 25
                                  }
                                });
                                // widget.auth.signIn("ngjenyang@gmail.com", "capstone");
                                uploadFile(_email, _password);
                                // widget.auth.signOut();
                                // }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LoginPage(auth: new Auth()),
                                  ),
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
