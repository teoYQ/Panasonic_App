import 'package:flutter/material.dart';
import 'package:panasonic_v1/widgets/cartCard.dart';
import 'shoppage.dart';

class CartPage extends StatefulWidget {
  final List<Plants> cartlist;
  CartPage(this.cartlist);
  @override
  _CartPageState createState() => _CartPageState(cartlist);
}

class _CartPageState extends State<CartPage> {
  //@override
  List<Plants> cartlist;
  _CartPageState(this.cartlist);
  
  getTotalAmount() {
    double total = 0.0;
    for (int i = 0; i < cartlist.length; i++) {
      
        total += double.parse(cartlist[i].price);
    }
    return total;
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
          children: <Widget>[
             Text(
                        "Shopping Cart",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      SizedBox(height: 50,),
          Container(
                                  height: 500,
                                  child: ListView.builder(
                                      itemCount: cartlist.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        //var product = _plants[index];
                                        
                                        return InkWell(
                                          onTap:(){
                                            print("HI");
                                          },
                                          child: CartCard(
                                          text: cartlist[index].name,
                                          filename: cartlist[index].pic,
                                          price: cartlist[index].price,
                                          onTap: (){
                                            
                                            print('lol');
                                          },
                                        ));
                                      })),
                                      Container(
                      height: 50.0,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('Total: \$' + getTotalAmount().toStringAsFixed(2)),
                          SizedBox(width: 10.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: () {},
                              elevation: 0.5,
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'Pay Now',
                                ),
                              ),
                              textColor: Colors.white,
                            ),
                          )
                        ],
                      ))]
      ),
    ));
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
