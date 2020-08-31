import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panasonic_v1/login_page.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import 'package:panasonic_v1/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:supercharged/supercharged.dart';

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
  bool _newimg = false;
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
          _newimg = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: "#5a856b".toColor(),
      ),
      body:Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(children: <Widget>[
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                    color: "#5a856b".toColor(),
                  
                   // image: Image.asset("assets/logo.png");
                    ),
              ),
              Positioned(
                bottom: 25,
                left: 20,
                child: Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 40),)
                )
                ],)
        ,
            
            Expanded(
              child: Form(
                key: _formKey,
                child: Container(
                  width: double.infinity,
              
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10,10,10,0),
                      child: Column(
                        
                        children: <Widget>[
                    
                          Container(
                            
                            child: Column(
                              children: <Widget>[
                                Container(child: SizedBox(height: 100,)),
                                /* Container(
                                  width: double.infinity,
                                  
                                        child: Padding(padding: EdgeInsets.fromLTRB(250, 0, 0, 0),
                                        child:IndexedStack(
                                      index: _curIndex,
                                      children: <Widget>[
                                         FlatButton(
                                        
                                          onPressed: () {
                                            _pickImage();
                                          },
                                          child: Image.asset("assets/cam.PNG",width: 50,height: 50,),
                                        ),
                                        CircleAvatar(
                                          
                                          backgroundColor: Colors.grey[900],
                                          radius: 50,
                                          child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: new BoxDecoration(
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image:
                                                          new ExactAssetImage(
                                                              _pickedImage
                                                                  .path)))

                                              _pickedImage == null
                                        ? Text("?")
                                        : Image.file(_pickedImage),
                                        
                                              ),
                                        )
                                      ]))),*/
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
                                
                                Container(
                                  padding: EdgeInsets.fromLTRB(10,0,10,0),
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
                              onPressed:(){
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
                                  _name: {"Incubator 1" :{
                                    "dose": 0,
                                    "lights": "off",
                                    "temperature": 25
                                  }}
                                });
                                // widget.auth.signIn("ngjenyang@gmail.com", "capstone");
                                //uploadFile(_email, _password);
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
                                    color:  "#5a856b".toColor()),
                                child: Center(
                                  child: Text(
                                    "Complete",
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
