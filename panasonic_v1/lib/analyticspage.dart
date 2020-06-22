import 'package:flutter/material.dart';
import 'package:panasonic_v1/activities.dart';
import 'package:panasonic_v1/widgets/incubators.dart';

import 'package:panasonic_v1/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:panasonic_v1/DIYpage.dart';
import 'authentication.dart';

class AnlyticsPage extends StatefulWidget {
  final BaseAuth auth;
  final String name;
  final Map mapper;
  AnlyticsPage({Key key, this.auth, this.name, this.mapper}) : super(key: key);
  @override
  _AnlyticsPageState createState() => _AnlyticsPageState(auth, name, mapper);
}

class _AnlyticsPageState extends State<AnlyticsPage> {
  String _lights = 'Turn on the lights';
  String name;
  BaseAuth auth;
  List _list;

  Map mapper;
  _AnlyticsPageState(this.auth, this.name, this.mapper);
  static FirebaseDatabase database = FirebaseDatabase.instance;
  bool new_inc = false;
  bool temp_bool = false;
  int itemcount = 0;
  final TextEditingController _controller = new TextEditingController();
  List _incubators;
  List active;

  /*void _addIncubator(String name) {
    _list.add(Incubators(name: name));
  }*/
  bool ready = false;
  List templist = [];
  @override
  void initState() {
    print(_list);
    super.initState();
    auth.getIncubators(name, database).then((value) => setState(() {
          print("hi");
          _incubators = value;
          itemcount = _incubators.length;
          /*for (var item in _list) {
        _addIncubator(item);
      }*/
          print(_incubators);
        }));
    print("sadiwqojd");
    //auth.getIncubatorMap(name, database).then((value) => mapper = value);
    auth.getActiveIncubators(name, database).then((value) => active = value);
    ready = true;
  }

  Widget build(BuildContext context) {
    print("dewdsadasDIS IS MAH $name");
    print(_list);
    /*setState(() {
      _incubators = _list;
    });*/
    print("hello");
    print(_incubators);
    print("mapper");
    print(mapper);
    print("printing acitve");
    print(active);
    var userref = database.reference().child("Active Incubators");

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[900],
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                auth.getEmail(name, database).then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivitiesPage(
                                auth: widget.auth,
                                name: name,
                                email: value,
                              )),
                    ));
              })),
      /*drawer: Drawer(
          child: ListView(children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Colors.green[900],
            Colors.green[800],
            Colors.green[400]
          ])),
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
          ),
        ),
        CustomListTile(Icons.person, "Profile", () => {}),
        CustomListTile(Icons.settings, "Settings", () => {}),
        CustomListTile(Icons.exit_to_app, "Log Out", () => {}),
      ])),*/
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
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Incubators",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 50,
                          //margin: EdgeInsets.symmetric(horizontal:10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.12),
                                  offset: Offset(0, 10),
                                  blurRadius: 30,
                                )
                              ]),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 18, right: 22),
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Add an incubator",
                                    suffixIcon: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          //auth.getTemp(name, database).then((value) =>
                                          //templist.add(value));
                                          if (_incubators.length > 3) {
                                            showAlertDialog(context);
                                          } else {
                                            if (active != null &&
                                                active[1].contains(
                                                    _controller.text)) {
                                              print("exists");
                                              print(_controller.text);
                                              int index = active[1]
                                                  .indexOf(_controller.text);
                                              _incubators.add(active[0][index]);
                                              database
                                                  .reference()
                                                  .child(name)
                                                  .update({
                                                active[0][index]: {
                                                  "dose": 0,
                                                  "lights": "off",
                                                  "temperature": 25
                                                }
                                              });
                                              new_inc = true;
                                              //print(new_inc);
                                              debugPrint(_controller.text);
                                              userref
                                                  .child(active[0][index])
                                                  .remove();

                                              auth
                                                  .getIncubatorMap(
                                                      name, database)
                                                  .then((value) =>
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AnlyticsPage(
                                                                  auth: widget
                                                                      .auth,
                                                                  name: name,
                                                                  mapper: value,
                                                                )),
                                                      ));
                                            } else {
                                              showAlertDialog2(context);
                                            }
                                          }

                                          /* setState((){
                                            _incubators = ;
                                          });*/
                                        })),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height - 100,
                            child: ListView.builder(
                                itemCount:
                                    itemcount, //mapper.keys.toList().length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  //var product = _incubators[index];
                                  if ((index == _incubators.length - 1) &&
                                      new_inc) {
                                    temp_bool = new_inc;
                                    new_inc = false;
                                    print("iejjiodew");
                                  }

                                  return InkWell(
                                      onTap: () {
                                        print("go to diy page");
                                      },
                                      //a ? b : c evaluates to b if a is true and evaluates to c if a is false.
                                      child: IncubatorCard(
                                        text: _incubators[index],
                                        temp: (index >
                                                (mapper.keys.toList().length -
                                                    1))
                                            ? "25"
                                            : (mapper[_incubators[index]]
                                                    ["temperature"])
                                                .toString(),
                                        lights: (index >
                                                (mapper.keys.toList().length -
                                                    1))
                                            ? "off"
                                            : (mapper[_incubators[index]]
                                                    ["lights"])
                                                .toString(),
                                        auth: widget.auth,
                                        dose: (index >
                                                (mapper.keys.toList().length -
                                                    1))
                                            ? 0
                                            : (mapper[_incubators[index]]
                                                    ["dose"]),
                                        name:
                                            name, //mapper.keys.toList()[index],
                                        /*temp: ((index ==
                                                    _incubators.length - 1) &&
                                                temp_bool)
                                            ? "25"
                                            : (mapper[_incubators[index]]
                                                    ["temperature"])
                                                .toString(),
                                        lights: ((index ==
                                                    _incubators.length - 1) &&
                                                temp_bool)
                                            ? "off"
                                            : mapper[_incubators[index]]
                                                ["lights"],*/
                                      ));
                                
                                })),
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

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text("You can only have up to 4 incubators"),
    actions: [
      cancelButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog2(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text("Invalid Password"),
    actions: [
      cancelButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
