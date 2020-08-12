import 'package:flutter/material.dart';
// import 'package:panasonicv1/authservice.dart'
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:panasonic_v1/activities.dart';
import 'package:panasonic_v1/signup_page.dart';
import 'package:panasonic_v1/authentication.dart';
import 'package:supercharged/supercharged.dart';
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
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
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
//         setState(() {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           
            Container(
              height: 270,
              width: double.infinity,
              decoration: BoxDecoration(
                    color: "#5a856b".toColor(),
                   // image: Image.asset("assets/logo.png");
                    ),
              child:Column(children:<Widget>[SizedBox(height:40), Image.asset("assets/logo.png",scale: 1,),
              ])
              /*child: Positioned(
                  
                  //alignment: Alignment.center,
                  child: Image.asset("assets/logo.png")
                  ),*/
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20,10,20,10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome!",
                    style: TextStyle(color: "#5a856b".toColor() , fontSize: 40),
                  ),
                  //FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        

                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              /*boxShadow: [
                                BoxShadow(
                                    color: Colors.green[100],
                                    blurRadius: 20,
                                    offset: Offset(0, 10))*/)
                            ,
                          child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20,25,10,0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.white))),
                                child: TextFormField(
                                  onSaved: (value) => _email = value,
                                  validator: (String value) {
                                      return value.length < 6
                                          ? "Required"
                                          : null;
                                    },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      hintText: "Email or Phone number",
                                      hintStyle: TextStyle(color: Colors.grey[500]),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20,10,20,10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.white))),
                                child: TextFormField(
                                  onSaved: (value) => _password = value,
                                  obscureText: true,
                                  validator: (String value) {
                                      return value.length < 6
                                          ? "Required"
                                          : null;
                                    },
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey[500]),
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Colors.white),)),
                        FlatButton(
                          //color: "#5a856b".toColor(),
                            onPressed: () {
                              final form = _formKey.currentState;
                              if (validateAndSave()) {
                      //        widget.auth.signIn("$_email", "$_password");
                                // database.reference().child("Users").equalTo("$_email");
                                var _name = widget.auth.getName("$_email",database);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActivitiesPage(auth: widget.auth, email : "$_email", name : "$_name")),
                                );
                              }
                              /*form.save();

                              // Validate will return true if is valid, or false if invalid.
                              if (form.validate()) {
                                _auth.signInWithEmailAndPassword(
                                    email: "$_email", password: "$_password");
                                FirebaseDatabase database =
                                    FirebaseDatabase.instance;
                                DatabaseReference myRef = database.reference();
                                DateTime current_time = DateTime.now();
                                myRef.set(
                                    "user $_email with password $_password logged it at $current_time");
                                _auth.signOut();
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
                                  color: "#5a856b".toColor()),
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
                        Stack(children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height - 400,
                          decoration: BoxDecoration(
                                  color:"#5a856b".toColor() ),

                        ),
                        Positioned(
                          top: 20,
                          child:  FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage(auth: widget.auth)),
                              );
                            },
                            child: Container(
                              width: 280,
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: "#5a856b".toColor() ,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )))],)
                      ],
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
