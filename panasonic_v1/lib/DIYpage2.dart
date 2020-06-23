import 'package:flutter/material.dart';
import 'package:panasonic_v1/monitorpage.dart';
import 'package:panasonic_v1/widgets/buttons_.dart';
import 'package:panasonic_v1/widgets/tapbox.dart';
import 'package:panasonic_v1/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'analyticspage.dart';
import 'authentication.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bezier_chart/bezier_chart.dart';

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
          colorFn: (_, __) => charts.MaterialPalette.white,
          domainFn: (growthPlot growthData, _) => growthData.day,
          measureFn: (growthPlot growthData, _) => growthData.surface_area),
    ];
    /*var chart = new charts.LineChart(
      series,
      behaviors: [
        /*new charts.ChartTitle('Surface Area against Time',

            //subTitle: 'Top sub-title text',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 18),
        new charts.ChartTitle('Days Planted',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('Surface Area',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),*/
        charts.LinePointHighlighter(
          drawFollowLinesAcrossChart: true,
          showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.all,
        )
      ],

      defaultRenderer:
          new charts.LineRendererConfig(includeArea: true, includePoints: true),
      animate: true,
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
          renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 10, color: charts.MaterialPalette.white))),
secondaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
          renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 10, color: charts.MaterialPalette.white))),
      
      //domainAxis: new charts.NumericAxisSpec(tickProviderSpec: charts.),
    );*/
    print("DIS IS MAH $incubatorname");
    bool _state = false;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[900],
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
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.green[900],
          Colors.green[800],
          Colors.green[400]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    InkWell(
                      onTap: _showDialog,
                      child: Text(
                        "$incubatorname",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                    )
                  ]),

                  Text(
                    " Days left to harvest: 24",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  //FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Column(
                      children: <Widget>[
                        // SizedBox(height: 50),

                        /*SizedBox(
                          height: 180,
                          child: chart,
                        ),*/
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: Text("Surface Area against Days Grown",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            height: 200,
                            child: BezierChart(
                              //bezierChartScale: BezierChartScale.CUSTOM,
                              bezierChartScale: BezierChartScale.CUSTOM,
                              xAxisCustomValues: const [0, 1, 2, 3, 4, 5, 6],
                              series: [
                                BezierLine(data: serie),
                              ],
                              config: BezierChartConfig(
                                verticalIndicatorStrokeWidth: 3.0,
                                verticalIndicatorColor: Colors.black26,
                                showVerticalIndicator: true,
                                //backgroundColor: Colors.red,
                                //updatePositionOnTap: true,
                                showDataPoints: true,
                                snap: false,
                                bubbleIndicatorColor: Colors.white,
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
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                            child: Row(
                          children: <Widget>[
                            SizedBox(
                                width: 180,
                                child: ButtonActivity(
                                    Icons.lightbulb_outline,
                                    " Switch Lights \n Status : $light",
                                    () => {
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
                                        })),
                            //ButtonActivity(Icons.lightbulb_outline, _state ? 'Turn x lights' : 'Turn on lights', () => {_state = !_state}),
                            SizedBox(
                                //width: 180,
                                child: ButtonActivity(
                                    Icons.wb_sunny,
                                    " Increase \n temperature : $temp",
                                    () => {
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
                                        }))
                          ],
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                                width: 180,
                                child: ButtonActivity(
                                    Icons.local_drink,
                                    "Dose Fertilizer",
                                    () => {
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
                                        })),
                            SizedBox(
                                width: 180,
                                child: ButtonActivity(
                                    Icons.wb_cloudy,
                                    " Decrease \n temperature : $temp",
                                    () => {
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
                                        }))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 40,
                          width: 350,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
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
                                style: TextStyle(color: Colors.green[900]),
                              )),
                        )
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
                    labelText: 'Full Name', hintText: 'eg. John Smith'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
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
