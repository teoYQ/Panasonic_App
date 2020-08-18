

import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class AchievementCard extends StatelessWidget {
  final String filename;
  final String text;
  final bool complete;
  Function onTap;
  AchievementCard({this.complete,this.filename, this.text,this.onTap});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkResponse(
      onTap:(){
        print(text);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 6),
        child: Opacity(
          opacity: complete ? 1.0 : 0.5,
          child: Container(
            width: 135,
            height: 135,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
                          border: Border.all(width:2,color: "#ddb926".toColor()
            ,),
                            color: "eee09c".toColor(),
                            borderRadius: BorderRadius.circular(8)),
            child: Stack(
              children: <Widget>[
                
                Positioned(
                  bottom: 25,
                  left:5,
                  //alignment: Alignment.center,
                  child: Image.asset(filename,width:120,height:110,scale: filename =="assets/fb.png"? 2.5 : 1)
                  ),
                Positioned(
                  left:  text.length < 12 ?  26 : 18 ,
                  bottom: text.length < 14 ?  10 : 5,
                  //alignment:Alignment.bottomLeft,
                  child: Text(text,textAlign: TextAlign.center,),)
                /*Positioned(
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
                      ),                    //Text(price)
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        
                        child:Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                           SizedBox(width: 7),
                          Text(text,textAlign: TextAlign.center,),
                        ]
                      ))
                      ])
                ),*/
               
              ],
            )))));
  }
}
