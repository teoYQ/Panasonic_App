import 'package:flutter/material.dart';
import 'package:panasonic_v1/activities.dart';
import 'package:panasonic_v1/monitorpage.dart';
import 'package:panasonic_v1/widgets/buttons_.dart';
import 'package:panasonic_v1/widgets/tapbox.dart';
import 'package:panasonic_v1/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'analyticspage.dart';
import 'authentication.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bezier_chart/bezier_chart.dart';
import 'package:supercharged/supercharged.dart';

class DIYPage extends StatefulWidget {
  final BaseAuth auth;
  final String name;
  final int temp;
  final String incubatorname;
  final int dose;
  DIYPage(
      {Key key, this.auth, this.name, this.temp, this.dose, this.incubatorname})
      : super(key: key);
  @override
  _DIYPageState createState() =>
      _DIYPageState(auth, name, temp, dose, incubatorname);
}

class _DIYPageState extends State<DIYPage> {
  String _lights = 'Turn on the lights';
  String light = "On";
  String name;
  int temp;
  BaseAuth auth;
  int dose;
  final TextEditingController _controller = new TextEditingController();
  String incubatorname;
  _DIYPageState(this.auth, this.name, this.temp, this.dose, this.incubatorname);
  static FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    var userref = database.reference().child(name).child(incubatorname);
    var serie = [
      DataPoint<double>(value: 5, xAxis: 0),
      DataPoint<double>(value: 10, xAxis: 1),
      DataPoint<double>(value: 15, xAxis: 2),
      DataPoint<double>(value: 18, xAxis: 3),
      DataPoint<double>(value: 22, xAxis: 4),
      DataPoint<double>(value: 24, xAxis: 5),
      DataPoint<double>(value: 25, xAxis: 6),
    ];
    var gdata = [
      new growthPlot(0, 5),
      new growthPlot(1, 10),
      new growthPlot(2, 14),
      new growthPlot(3, 17),
      new growthPlot(4, 21),
      new growthPlot(5, 22)
    ];
    var series = [
      new charts.Series(
          id: "growth",
          data: gdata,
          colorFn: (_, __) => charts.MaterialPalette.black,
          domainFn: (growthPlot growthData, _) => growthData.day,
          measureFn: (growthPlot growthData, _) => growthData.surface_area),
    ];

    print("DIS IS MAH $incubatorname");
    bool _state = false;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: "#e0f0eb".toColor(),
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                auth
                    .getIncubatorMap(name, database)
                    .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnlyticsPage(
                                    auth: widget.auth,
                                    name: name,
                                    mapper: value,
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
          ]))*/
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: "#e0f0eb".toColor(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20,20,20,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    InkWell(
                      onTap: _showDialog,
                      child: Text(
                        "$incubatorname",
                        style:
                            TextStyle(color: "#4d4d4d".toColor(), fontSize: 40),
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      color: "#9ebebe".toColor(),
                    )
                  ]),
/*
                  Text(
                    " Days left to harvest: 24",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),*/
                  //FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(1),
                    child: Column(
                      children: <Widget>[
                        // SizedBox(height: 50),

                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(color: "#e0f0eb".toColor(),),
                          child:Column(
                            children : <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20,20,20,20),
                            child: Container(
                              decoration: BoxDecoration(color: "#e0f0eb".toColor(), ),
                              child: Text(
                                  "Surface Area (cm2) against Days Grown",
                                  style: TextStyle(color: "#177061".toColor())),
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                          child: Container(
                            width: 280,
                            height: 150,
                            decoration: BoxDecoration(),
                            child: BezierChart(
                              //bezierChartScale: BezierChartScale.CUSTOM,
                              bezierChartScale: BezierChartScale.CUSTOM,
                              xAxisCustomValues: const [0, 1, 2, 3, 4, 5, 6],
                              series: [
                                BezierLine(
                                  data: serie,
                                  lineColor: "#177061".toColor(),
                                ),
                              ],
                              config: BezierChartConfig(
                                
                                backgroundColor: "#e0f0eb".toColor(),
                                verticalIndicatorStrokeWidth: 3.0,
                                verticalIndicatorColor: "#177061".toColor(),
                                showVerticalIndicator: true,
                                xAxisTextStyle:
                                    TextStyle(color: "#177061".toColor()),
                                yAxisTextStyle:
                                    TextStyle(color: "#177061".toColor()),
                                //backgroundColor: Colors.red,
                                //updatePositionOnTap: true,
                                showDataPoints: true,
                                snap: false,
                                bubbleIndicatorColor: "#177061".toColor(),
                                bubbleIndicatorLabelStyle:
                                    TextStyle(color: Colors.white),
                                bubbleIndicatorValueStyle:
                                    TextStyle(color: Colors.white),
                                bubbleIndicatorTitleStyle:
                                    TextStyle(color: Colors.white),
                                displayDataPointWhenNoValue: true,

                                //displayYAxis: true
                                /*backgroundGradient: LinearGradient(
                                    colors: <Color>[
                                      Colors.green[900],
                                      Colors.green[800],
                                      Colors.green[400]
                                    ]),*/
                              ),
                            ),
                          ),
                        ),]
                          )),
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Stack(
                            children: <Widget>[
                              //# LIGHTS TEXT
                              Positioned(
                                left: 50,
                                top: 60,
                                child: Container(
                                    width: 50,
                                    height: 20,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Text(
                                      "Lights",
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                              // FERTILIZER TEXT
                              Positioned(
                                left: 50,
                                top: 130,
                                child: Container(
                                    width: 70,
                                    height: 20,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Text(
                                      "Fertilizer",
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                              // LIGHTS LOGO
                              Positioned(
                                left: 130,
                                top: 40,
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        
                                        border: Border.all(width: 2,
                                            color: "#177061".toColor())),
                                    child: Stack(children: <Widget>[
                                      light == "On"
                                          ? Image.asset(
                                              "assets/bulbon.png",
                                              width: 50,
                                              height: 50,
                                            )
                                          : Image.asset(
                                              "assets/bulboff.png",
                                              scale: 2,
                                            ),
                                      FlatButton(
                                        onPressed: () => {
                                          widget.auth
                                              .getIncubatorLight(
                                                  name, incubatorname, database)
                                              .then((val) => setState(() {
                                                    print(val);
                                                    (val == "On")
                                                        ? light = "Off"
                                                        : light = "On";
                                                    userref.update(
                                                        {"lights": light});
                                                  }))
                                        },
                                        child: null,
                                      ),
                                    ])),
                              ),
                              //FERTILIZER LOGO
                              Positioned(
                                left: 130,
                                top: 116,
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(width: 2,
                                            color: "#177061".toColor())),
                                    child: Stack(children: <Widget>[
                                    
                                     Image.asset("assets/dose.png",),
                                      FlatButton(
                                        onPressed:() => {
                                          widget.auth
                                              .getIncubatorDose(
                                                  name, incubatorname, database)
                                              .then((val) => setState(() {
                                                    print(val);
                                                    int inc_dose = val + 1;
                                                    print(inc_dose);

                                                    userref.update(
                                                        {"dose": inc_dose});
                                                  }))
                                        },
                                        
                                        child: null,
                                      ),
                                    ])),
                              ),
                              //TEMPERATURE ADJUSTER
                              Positioned(
                                right: 140,
                                top: 40,
                                child: Container(
                                    width: 50,
                                    height: 127,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(width: 2,
                                            color: "#177061".toColor())),
                                            child: Column(
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    Icon(Icons.arrow_drop_up,size: 50,color: "#177061".toColor(),),
                                                    FlatButton(onPressed: () => {
                                          widget.auth
                                              .getIncubatorTemp(
                                                  name, incubatorname, database)
                                              .then((val) => setState(() {
                                                    print(val);
                                                    int inc_temp = val + 1;
                                                    print(inc_temp);
                                                    temp = val + 1;
                                                    userref.update({
                                                      "temperature": inc_temp
                                                    });
                                                  }))
                                        }, child: null)
                                                  ]
                                                ),
                                                Text(temp.toString(),style: TextStyle(fontSize:20,color:"#5a856b".toColor() ),),
                                                Stack(
                                                  children: <Widget>[
                                                    Icon(Icons.arrow_drop_down,size: 50,color: "#177061".toColor(),),
                                                    FlatButton(onPressed: () => {
                                          widget.auth
                                              .getIncubatorTemp(
                                                  name, incubatorname, database)
                                              .then((val) => setState(() {
                                                    print(val);
                                                    int dec_temp = val - 1;
                                                    print(dec_temp);
                                                    temp = val - 1;
                                                    userref.update({
                                                      "temperature": dec_temp
                                                    });
                                                  }))
                                        }, child: null)
                                                  ]
                                                ),
                                              ],
                                            ),),
                              ),
                              //TEMPERATURE WORD
                              Positioned(
                                right: 40,
                                top: 90,
                                child: Container(
                                    width: 90,
                                    height: 20,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Text(
                                      "Temperature",
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      Container(
                          height: 30,
                          width: 310,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width:2,color:"#177061".toColor()),
                              color: Colors.white),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0) ,
                          child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MonitorPage()),
                                );
                              },
                              child: Text(
                                "View Plants",
                                style: TextStyle(color: "#4d4d4d".toColor()),
                              )),)
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

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: _controller,
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Incubator Name',
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                print("Cacnel");

                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Rename'),
              onPressed: () {
                print("RENAMIGN");
                print(incubatorname);

                print(_controller.text);
                database.reference().child(name).update({
                  _controller.text: {
                    "dose":
                        dose, //widget.auth.getIncubatorDose(name, incubatorname, database),
                    "lights":
                        light, //widget.auth.getIncubatorLight(name, incubatorname, database),
                    "temperature":
                        temp, //widget.auth.getIncubatorTemp(name, incubatorname, database)
                  }
                });

                //incubatorname = _controller.text;
                //Navigator.pop(context);
                database.reference().child(name).child(incubatorname).remove();
                auth
                    .getIncubatorTemp(name, _controller.text, database)
                    .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DIYPage(
                                    auth: widget.auth,
                                    name: name,
                                    dose: dose,
                                    temp: value,
                                    incubatorname: _controller.text,
                                  )),
                        ));
              })
        ],
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

class growthPlot {
  final int day;
  final int surface_area;
  growthPlot(this.day, this.surface_area);
}
