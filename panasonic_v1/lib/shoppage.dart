import 'package:flutter/material.dart';
import 'package:panasonic_v1/cartpage.dart';
import 'package:panasonic_v1/widgets/productCard.dart';
import 'package:supercharged/supercharged.dart';
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
      Plants(name: "Rosemary", pic: ("assets/rosemary.png"), price: "1.48"),
      Plants(name: "Mint", pic: ("assets/mint.png"), price: "1.48"),
      Plants(name: "Coriander", pic: ("assets/coriander.png"), price: "2.48")
    ];
    var chinese = <Plants>[
      Plants(name: "Lettuce", pic: ("assets/lettuce.png"), price: "1.48"),
      Plants(name: "Mizuna", pic: ("assets/mizuna.png"), price: "1.48")
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
        backgroundColor: "#e0f0eb".toColor(),
        elevation: 0.0,
            iconTheme: IconThemeData(color: "#177061".toColor()),

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
                        "Shop",
                        style: TextStyle(color: "#4d4d4d".toColor() , fontSize: 40),
                      ),
                       GestureDetector(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Padding(

                            padding: EdgeInsets.only(left:MediaQuery.of(context).size.width - 219),
                              child:
                             Image.asset("assets/cart.png",width: 70,height: 70,)
                          )
                            ,
                            if (_cartList.length > 0)
                              Padding(
                                padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width - 210,20,0,0),
                                child: CircleAvatar(
                                  radius: 8.0,
                                  backgroundColor: "#177061".toColor(),
                                  foregroundColor: Colors.white,
                                  child: Text(
                                    _cartList.length.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          if (_cartList.isNotEmpty)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CartPage(_cartList),
        ),
      );
                        },
                      )
                      
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
                decoration: BoxDecoration(color: Colors.white),
                child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                "Herbs",
                                style: TextStyle(
                                    color: "#4d4d4d".toColor(), fontSize: 30),
                              )),
                              SizedBox(
                                height: 1,
                              ),
                              Container(
                                  height: 170,
                                  child: ListView.builder(
                                      itemCount: _plants.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        //var product = _plants[index];
                                        return InkWell(
                                          onTap:(){
                                          },
                                          child: ProductCard(
                                          chi: false,
                                          text: _plants[index].name,
                                          filename: _plants[index].pic,
                                          price: _plants[index].price,
                                          onTap: (){
                                            setState(() {
                                              _cartList.add(_plants[index]);
                                            });
                                            
                                          },
                                        ));
                                      })),
                              SizedBox(
                                height: 1,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                "Chinese Vegetables",
                                style: TextStyle(
                                    color: "#4d4d4d".toColor(), fontSize: 30),
                              )),
                              Container(
                                  height: 170,
                                  child: ListView.builder(
                                      itemCount: _chinese.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        var chineseplants = _chinese[index];
                                        return ProductCard(
                                          chi: true,
                                          text: _chinese[index].name,
                                          filename: _chinese[index].pic,
                                          price: _chinese[index].price,
                                          onTap: (){
                                            setState(() {
                                              _cartList.add(_chinese[index]);
                                            });
                                            
                                          },
                                        );
                                      }))
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

class Plants {
  final String name;
  final String pic;
  final String price;
  Plants({this.name, this.pic, this.price,});
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
                    }),
                    RaisedButton(
                    child: Text("Water plant"),
                    onPressed: () {
                    }),
                    TapboxA(),
                    RaisedButton(
                    child: Text("Is my crop ready to eat"),
                    onPressed: () {
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
