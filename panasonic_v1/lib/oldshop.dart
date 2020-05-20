import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Plants> _plants = List<Plants>();
  List<Plants> _cartList = List<Plants>();
  @override
  String _lights = 'off';
  void _populatePlants() {
    var list = <Plants>[
      Plants(name: "rosemary", pic: Image.asset("assets/rosemary.png")),
      Plants(name: "lettuce", pic: Image.asset("assets/lettuce.png"))
    ];
    setState(() {
      _plants = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _populatePlants();
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
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Shop",
                    style: TextStyle(color: Colors.white, fontSize: 40),
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
                          height: 30,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              MaterialButton(
                                child: Container(
                                    height: 20,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        //borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[Text("Herbs")])),
                                onPressed: () {},
                              ),
                              FlatButton(
                                child: Container(
                                    height: 20,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        //borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Leafy Greens")
                                        ])),
                                onPressed: () {},
                              ),
                              FlatButton(
                                child: Container(
                                    height: 20,
                                    width: 160,
                                    decoration: BoxDecoration(
                                        //borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Chinese Vegetables")
                                        ])),
                                onPressed: () {},
                              ),
                              FlatButton(
                                child: Container(
                                    height: 20,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        //borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[Text("Fruits")])),
                                onPressed: () {},
                              ),
                            ])),
                        Row(children: <Widget>[
                          Container(
                            height: 160,
                            width: MediaQuery.of(context).size.width / 2 - 10,
                            decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: Stack(
                              children: <Widget>[
                                Image.asset("assets/rosemary.png"),
                                Positioned.fill(
                                    child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text("Rosemary"),
                                ))
                              ],
                            ),
                          )
                        ])
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

class Plants {
  final String name;
  final Image pic;
  Plants({this.name, this.pic});
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
