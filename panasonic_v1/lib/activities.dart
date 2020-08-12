import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:panasonic_v1/achievements.dart';
import 'package:panasonic_v1/login_page.dart';
//import 'package:panasonic_v1/DIYpage.dart';
import 'package:panasonic_v1/analyticspage.dart';
import 'package:panasonic_v1/forum.dart';
//import 'package:panasonic_v1/monitorpage.dart';
import 'package:panasonic_v1/shoppage.dart';
import 'package:panasonic_v1/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:panasonic_v1/toggle_buttons.dart';
import 'package:supercharged/supercharged.dart';

class ActivitiesPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String email;
  final String name;
  String _imgUrl =
      "https://firebasestorage.googleapis.com/v0/b/capst0ned.appspot.com/o/profile%2Fscaled_f1062f2c-718c-4bd3-98d1-5c77673ffe2e5822050796730969480.jpg%7D?alt=media&token=412e3c50-5e35-4189-b7a3-46f29767e84c";
  ActivitiesPage(
      {Key key,
      this.auth,
      this.userId,
      @required this.email,
      this.name,
      this.logoutCallback})
      : super(key: key);

  @override
  _ActivitiesPageState createState() => _ActivitiesPageState(email, auth);
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  BaseAuth auth;
  // VoidCallback logoutCallback;
  // String userId;
  String email;
  static FirebaseDatabase database = FirebaseDatabase.instance;
  String name;
  String _imgUrl =
      "https://firebasestorage.googleapis.com/v0/b/capst0ned.appspot.com/o/profile%2Fscaled_f1062f2c-718c-4bd3-98d1-5c77673ffe2e5822050796730969480.jpg%7D?alt=media&token=412e3c50-5e35-4189-b7a3-46f29767e84c";
  // _ActivitiesPageState(this.email,this.auth);
  //String _imgUrl;// = "https://firebasestorage.googleapis.com/v0/b/capst0ned.appspot.com/o/profile%2FJackson?alt=media&token=996b6707-6ac0-4053-b225-21d7654e6b49";
  _ActivitiesPageState(this.email, this.auth) {
    auth.getName(email, database).then((val) => setState(() {
          name = val;
          print(name);
          display(email);
        }));

    //StorageReference storageReference = FirebaseStorage.instance.ref().child("profile/$name");
    //storageReference.getDownloadURL().then((val) => setState((){
    //   print(val);
    //_imgUrl = val;
    // }));
  }
  display(String name) async {
    print("hi");
    print(name);
    print(_imgUrl);
    String filepath = "profile/$name";
    await FirebaseStorage.instance
        .ref()
        .child(filepath)
        .getDownloadURL()
        .then((value) => setState(() {
              _imgUrl = value;
            }));
    print(_imgUrl);
    //setState(() {
    //_imgUrl = data;
    //});
  }

  @override
  String _lights = 'off';

  Widget build(BuildContext context) {
    // var name = widget.auth.getName(widget.email,database);
    print(_imgUrl);
    //display(name);
    print(_imgUrl);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: "#e0f0eb".toColor(),
        elevation: 0.0,
    iconTheme: IconThemeData(color: "#177061".toColor()),
   ),
      
      drawer: Drawer(
          
          child: ListView(children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
              color:"#e0f0eb".toColor() ),
          /*child: CircleAvatar(
              child: ClipRRect(
            borderRadius: new BorderRadius.circular(75),
            child: (_imgUrl ==
                    "https://firebasestorage.googleapis.com/v0/b/capst0ned.appspot.com/o/profile%2Fscaled_f1062f2c-718c-4bd3-98d1-5c77673ffe2e5822050796730969480.jpg%7D?alt=media&token=412e3c50-5e35-4189-b7a3-46f29767e84c")
                ? Image.asset("assets\coriander.png")
                : Image.network(
                    _imgUrl,
                    width: 150,
                    fit: BoxFit.fill,
                  ),
          )),*/
        ),
        CustomListTile(Icons.person, "Profile", () => {}),
        CustomListTile(Icons.settings, "Settings", () => {}),
        CustomListTile(Icons.exit_to_app, "Log Out", () => {Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage(auth : new Auth())),
                            )}),
      ])),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: "#e0f0eb".toColor(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                color: "#e0f0eb".toColor(),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hello!",
                      style:
                          TextStyle(color: "#4d4d4d".toColor(), fontSize: 45),
                      key: Key('Welcome'),
                    ),
                    SizedBox(
                      width: 30,
                      height: 50,
                    ),
                    Text("\nWhat would you like \nto do today?",
                        style: TextStyle(
                            color: "#5a856b".toColor(), fontSize: 14)),

                    //FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        /*
                        FlatButton(
                          child: Container(
                              height: 120,
                              width: 480,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset("assets/LiveMonitoring.png",
                                        height: 100, width: 100),
                                    Text("Monitor your plants")
                                  ])),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MonitorPage()),
                            );
                          },
                        ),*/
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            FlatButton(
                              child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      60,
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(5),color: "#e0f0eb".toColor()),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Image.asset("assets/incubator.png",
                                            height: 100, width: 100),
                                        Text("Incubators")
                                      ])),
                              onPressed: () {
                                auth
                                    .getIncubatorMap(name, database)
                                    .then((value) => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AnlyticsPage(
                                                    auth: widget.auth,
                                                    name: name,
                                                    mapper: value,
                                                  )),
                                        ));
                              },
                            ),
                            FlatButton(
                                child: Container(
                                    height: 150,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            60,
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                        color: "#e0f0eb".toColor()),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(height: 10),
                                          Image.asset("assets/shop.png",
                                              height: 100, width: 100),
                                          Text("Shop")
                                        ])),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShopPage()),
                                  );
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            FlatButton(
                              child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      60,
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(5),color: "#e0f0eb".toColor()),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Image.asset("assets/achievements.png",
                                            height: 100, width: 100),
                                        Text("Achievements")
                                      ])),
                              onPressed: () {
                                 auth
                                    .getAchievements(name, database)
                                    .then((value) => Navigator.push(
                                          context,
                                    MaterialPageRoute(
                                        builder: (context) => AchievementPage(value))));
                              },
                            ),
                            FlatButton(
                              child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      60,
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(5),color: "#e0f0eb".toColor()),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Image.asset("assets/forum.png",
                                            height: 100, width: 100),
                                        Text("Forum")
                                      ])),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForumPage()),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Stack(
            children: <Widget>[
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: "#e0f0eb".toColor(),
              ),)
          , Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: null,
                      child: Container(
                          width: MediaQuery.of(context).size.width / 3 - 40 ,
                          //margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text("Account",textAlign: TextAlign.right,))),
                   FlatButton(
                      onPressed: null,
                      child:Container(
                          width: MediaQuery.of(context).size.width / 3 ,
                          height: 80,
                          //margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
                          child: Image.asset("assets/home.png",scale: 1,))
                    ),
                    FlatButton(
                      onPressed: null,
                      child: Container(
                          width: MediaQuery.of(context).size.width / 3 - 70 ,
                          //margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text("Notifs",textAlign: TextAlign.left,))),
                    ],
              )],
            )

          ],
        ),
      ),
    );
  }

  Widget makeItem({image, tag, text}) {
    return Hero(
      tag: tag,
      child: GestureDetector(
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image:
                  DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[100],
                  //blurRadius: 10,
                  //offset: Offset(0,30)
                )
              ]),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Text(text,
                            style: TextStyle(
                                color: Colors.green[900],
                                fontSize: 30,
                                fontWeight: FontWeight.bold))
                      ]))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0), // <= NEW
                Text(
                  'What would you like to do today',
                  style: TextStyle(fontSize: 20),
                ),
                RaisedButton(
                    child: Text("Monitor Plants"),
                    onPressed: () {
                      print("looking at my plant");
                    }),
                    RaisedButton(
                    child: Text("Water plant"),
                    onPressed: () {
                      print("watering plant");
                    }),
                    TapboxA(),
                    RaisedButton(
                    child: Text("Is my crop ready to eat"),
                    onPressed: () {
                      print("No");
                    }),
                            ],
            ),
          ),
        ));
  }
}
*/

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: InkWell(
            onTap: onTap,
            child: Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Text(text)
                  ],
                ))));
  }
}
