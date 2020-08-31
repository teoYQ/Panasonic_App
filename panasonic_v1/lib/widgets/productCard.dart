

import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class ProductCard extends StatelessWidget {
  final String filename;
  final String text;
  final String price;
  final bool chi;
  Function onTap;
  ProductCard({this.chi,this.filename, this.text, this.price,this.onTap});
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
            width: 155,
            height: 145,
            
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                    child: Container(
                        width: 135,
                        height: 145,
                        decoration: BoxDecoration(
                          border: Border.all(width:2,color: "#e0f0eb".toColor()
            ,),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  right:20,
                  //alignment: Alignment.center,
                  child: Image.asset(filename,width:chi ? 110 :120,height:110)
                  ),
                Positioned(
                  left:30,
                  bottom: 25,
                  //alignment:Alignment.bottomLeft,
                  child: Text(text),),
                Positioned(
                  //alignment: Alignment.bottomCenter,
                  right: 9,
                  bottom: 20,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 135,
                        height: 30,
                        decoration: BoxDecoration(color:"#e0f0eb".toColor(),
                        borderRadius: BorderRadius.circular(8)),
                      ),
                      //Text(price)
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        
                        child:Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                           SizedBox(width: 7),
                          Text(text,textAlign: TextAlign.center,),
                          SizedBox(width: (8 + 7.5*(10-text.length)).toDouble()),
                          Text('\$' + price)
                        ]
                      ))
                      ])
                ),
                Positioned(
                  //alignment: Alignment.bottomCenter,
                  top: 1,
                  right: 1,
                  child: IconButton(icon: Icon(Icons.add,color:"#e0f0eb".toColor(),), onPressed: onTap),
                  
                
                )
              ],
            ))));
  }
}
