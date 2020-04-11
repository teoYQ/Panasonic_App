import 'dart:ffi';

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String filename;
  final String text;
  final String price;
  ProductCard({this.filename, this.text, this.price});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.only(left: 1),
        child: Container(
            width: 175,
            height: 175,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                    child: Container(
                        width: 175,
                        height: 175,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right:15,
                  //alignment: Alignment.center,
                  child: Image.asset(filename,width:150,height:150)
                  ),
                Positioned(
                  left:30,
                  bottom: 25,
                  //alignment:Alignment.bottomLeft,
                  child: Text(text),),
                Positioned(
                  //alignment: Alignment.bottomCenter,
                  right: 30,
                  bottom: 25,
                  child: Text(price)
                ),
                Positioned(
                  //alignment: Alignment.bottomCenter,
                  top: 10,
                  right: 10,
                  child: Icon(Icons.add)
                )
              ],
            )));
  }
}
