import 'package:flutter/material.dart';
import 'package:panasonic_v1/widgets/achievementCard.dart';
import 'package:supercharged/supercharged.dart';
class AchievementPage extends StatefulWidget {
  @override
  _AchievementPageState createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  List<Achievements> _achievements_1 = List<Achievements>();
  List<Achievements> _achievements_2 = List<Achievements>();
  @override
  String _lights = 'off';
  void _populateAchievements() {
    var col1 = <Achievements>[
      Achievements(name: "1st Harvest", pic: ("assets/1harvest.png"), complete: true),
      Achievements(name: "10th Harvest", pic: ("assets/10harvest.png"), complete: false),
      Achievements(name: "30th Harvest", pic: ("assets/30harvest.png"), complete: false)
    ];
var col2 = <Achievements>[
      Achievements(name: "Grow 2 Types \n  of Plants", pic: ("assets/2types.png"), complete: true),
      Achievements(name: "Grow 5 types \n  of Plants", pic: ("assets/5type.png"), complete: false),
      Achievements(name: "Connected to \n  Facebook", pic: ("assets/fb.png"), complete: false)
    ];
    setState(() {
      _achievements_1 = col1;
      _achievements_2 = col2;
      
    });
  }

  @override
  void initState() {
    super.initState();
    _populateAchievements();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: "#e0f0eb".toColor(),
        elevation: 0.0,
      ),/*
      drawer: Drawer(
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
            color :  "#e0f0eb".toColor()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            Padding(
              padding: EdgeInsets.fromLTRB(20,10,20,20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Achievements",
                        style: TextStyle(color: "#4d4d4d".toColor() , fontSize: 40),
                      ),
                    
                        
                      
                      
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  

                  //FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              
                              SizedBox(
                                height: 1,
                              ),
                              Container(
                                  height: 600,
                                  child: ListView.builder(
                                      itemCount: _achievements_1.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        //var product = _achievements[index];
                                        return InkWell(
                                          onTap:(){
                                            print("HI");
                                          },
                                          child: Row(children: <Widget>[
                                            SizedBox(width:30),AchievementCard(
                                          text: _achievements_1[index].name,
                                          filename: _achievements_1[index].pic,
                                          complete: _achievements_1[index].complete,
                                          onTap: (){
                                            print("idiwjed");
                                          },
                                        ),
                                        AchievementCard(
                                          text: _achievements_2[index].name,
                                          filename: _achievements_2[index].pic,
                                          complete: _achievements_2[index].complete,
                                          onTap: (){
                                            print("idiwjed");
                                          },
                                        )]));
                                      })),
                              SizedBox(
                                height: 1,
                              ),
                         
                            ]))),
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
                      onPressed: (){
                        Navigator.pop(context);
                      },
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
}

class Achievements {
  final String name;
  final String pic;
  final bool complete;
  Achievements({this.name, this.pic,this.complete});
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
                    child: Text("Monitor Achievements"),
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
