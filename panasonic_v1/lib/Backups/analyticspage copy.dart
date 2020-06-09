import 'package:flutter/material.dart';
import 'package:panasonic_v1/widgets/incubators.dart';

class AnlyticsPage extends StatefulWidget {
  final List list;
  AnlyticsPage({this.list});
  @override
  _AnlyticsPageState createState() => _AnlyticsPageState(list);
}

class _AnlyticsPageState extends State<AnlyticsPage> {
  _AnlyticsPageState(list){
    _incubators = list;
  }
  @override
  String _lights = 'off';
  final TextEditingController _controller = new TextEditingController();
  List<Incubators> _incubators = List<Incubators>();
  var list = <Incubators>[];
  void _addIncubator(String name) {
    list.add(Incubators(name: name));
  }
  @override
  void initState() {
    super.initState();
    _incubators = list;
  }
  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
      ),
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
      ])),
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
                    "Track Your Plants",
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
                                          _addIncubator(_controller.text);
                                          auth.getTemp(name, database).then((value) => 
                                          debugPrint(_controller.text);
                                          setState((){
                                            _incubators = list;
                                          });
                                          
                                        })),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height - 100,
                            child: ListView.builder(
                                itemCount: _incubators.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  var product = _incubators[index];
                                  return InkWell(
                                      onTap: () {
                                        print("HI");
                                      },
                                      child: IncubatorCard(
                                        text: _incubators[index].name,
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

class Incubators {
  final String name;
  Incubators({this.name});
}
