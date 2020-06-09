import 'package:flutter/material.dart';
import 'package:panasonic_v1/widgets/productCard.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Plants> _plants = List<Plants>();
  List<Plants> _chinese = List<Plants>();
  List<Plants> _cartList = List<Plants>();
  @override
  String _lights = 'off';
  void _populatePlants() {
    var list = <Plants>[
      Plants(name: "rosemary", pic: ("assets/rosemary.png"), price: "1.48"),
      Plants(name: "mint", pic: ("assets/mint.png"), price: "1.48"),
      Plants(name: "coriander", pic: ("assets/coriander.png"), price: "2.48")
    ];
    var chinese = <Plants>[
      Plants(name: "lettuce", pic: ("assets/lettuce.png"), price: "1.48"),
      Plants(name: "leek", pic: ("assets/leek.png"), price: "1.48")
    ];
    setState(() {
      _plants = list;
      _chinese = chinese;
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
          //Colors.green[400]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Shop",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      FlatButton(
                          onPressed: null,
                          child: Padding(

                            padding: EdgeInsets.only(left:MediaQuery.of(context).size.width - 190),
                              child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          )))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
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
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search",
                              suffixIcon: Icon(Icons.search)),
                        ),
                      ),
                    ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text(
                                "Herbs",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              )),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  height: 200,
                                  child: ListView.builder(
                                      itemCount: _plants.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        //var product = _plants[index];
                                        return InkWell(
                                          onTap:(){
                                            print("HI");
                                          },
                                          child: ProductCard(
                                          text: _plants[index].name,
                                          filename: _plants[index].pic,
                                          price: _plants[index].price,
                                        ));
                                      })),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  child: Text(
                                "Chinese Vegetables",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              )),
                              Container(
                                  height: 200,
                                  child: ListView.builder(
                                      itemCount: _chinese.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        var chineseplants = _chinese[index];
                                        return ProductCard(
                                          text: _chinese[index].name,
                                          filename: _chinese[index].pic,
                                          price: _chinese[index].price,
                                        );
                                      }))
                            ]))),
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
  final String pic;
  final String price;
  Plants({this.name, this.pic, this.price});
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
