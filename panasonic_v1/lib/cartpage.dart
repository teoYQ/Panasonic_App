import 'package:flutter/material.dart';
import 'package:panasonic_v1/widgets/cartCard.dart';
import 'shoppage.dart';
import 'package:supercharged/supercharged.dart';

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
List<bool> seedlings = [];
  getTotalAmount() {
    double total = 0.0;
    for (int i = 0; i < cartlist.length; i++) {
      total += double.parse(cartlist[i].price);
      seedlings.add(true);
    }
    return total;
  }
  refresh() {
  setState(() {});
}
  
  Widget build(BuildContext context) {
    

    return Scaffold(
        appBar: AppBar(
          backgroundColor: "#e0f0eb".toColor(),
          elevation: 0.0,
          iconTheme: IconThemeData(color: "#177061".toColor()),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: "#e0f0eb".toColor(),
          ),
          child: Column(children: <Widget>[
            Text(
              "Shopping Cart",
              style: TextStyle(color: "#4d4d4d".toColor(), fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                decoration: BoxDecoration(color: Colors.white),
                height: MediaQuery.of(context).size.height - 300,
                child: ListView.builder(
                    itemCount: cartlist.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var product = cartlist[index];

                      return InkWell(
                          onTap: () {
                          },
                          child: CartCard(
                            text: cartlist[index].name,
                            filename: cartlist[index].pic,
                            price: cartlist[index].price,
                            onTap: () {
                              setState(() {
                                cartlist.remove(product);
                              });
                          
                            },
                           
                            
                          )
                          );
                          
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
                        color: "#177061".toColor(),
                        child: Center(
                          child: Text(
                            'Pay Now',
                          ),
                        ),
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ))
          ]),
        ));
  }
}



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
