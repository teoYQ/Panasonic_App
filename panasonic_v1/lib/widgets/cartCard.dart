

import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  final String filename;
  final String text;
  final String price;
  final Function onTap;
  CartCard({this.filename, this.text, this.price,this.onTap});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkResponse(
      onTap:(){
        print(text);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 1),
        child: Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                    child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 175,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left:15,
                  //alignment: Alignment.center,
                  child: Image.asset(filename,width:100,height:80)
                  ),
                Positioned(
                  left:120,
                  top: 15,
                  //alignment:Alignment.bottomLeft,
                  child: Text(text),),
                Positioned(
                  //alignment: Alignment.bottomCenter,
                  left: 120,
                  top: 35,
                  child: Text(price)
                ),
                Positioned(
                  //alignment: Alignment.bottomCenter,
                  top: 10,
                  right: 20,
                  child: IconButton(icon: Icon(Icons.delete), onPressed: onTap),
                  
                
                )
              ],
            ))));
  }
}
