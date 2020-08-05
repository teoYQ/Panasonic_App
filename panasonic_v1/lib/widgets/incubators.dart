import 'package:flutter/material.dart';
import 'package:panasonic_v1/authentication.dart';
import 'package:panasonic_v1/DIYpage2.dart';
import 'package:supercharged/supercharged.dart';

class IncubatorCard extends StatelessWidget {
  final String text;
  final String temp;
  final String lights;
  final String name;
  final BaseAuth auth;
  final int dose;
  final int ind;
  final int sensor;
  final int fertilizer;

  IncubatorCard({this.text, this.temp, this.lights,this.auth,this.name, this.dose,this.ind,this.fertilizer,this.sensor});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkResponse(
        onTap: () {
          print(lights);
          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DIYPage(auth : this.auth, name : name, temp : int.parse(temp),dose: dose,lights: this.lights,incubatorname: this.text)),
                            );
        },
        child: Padding(
            padding: EdgeInsets.only(left: 1),
            child: Container(
                width: 125,
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
                            height: 125,
                            decoration: BoxDecoration(
                color: "#e0f0eb".toColor(),
                                borderRadius: BorderRadius.circular(5))),
                      ),
                    ),
                    Positioned(
                        //alignment: Alignment.center,
                        width: 100,
                        height: 80,
                        left: 40,
                        top: 10,
                        child: Text(ind.toString(),style: TextStyle(fontSize:50,color:Colors.white),)),
                    
                    Positioned(
                      left:100,
                      top: 22,
                      //alignment:Alignment.bottomLeft,
                      child: Text(text,style: TextStyle(fontSize:26,color:"#5a856b".toColor()),)),
                    /*,
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 + 30,
                      top: 40,
                      //alignment:Alignment.bottomLeft,
                      child: Text(temp),
                    )*/
                    Positioned(
                     right: 30,
                      bottom: 30,

                      //alignment:Alignment.bottomLeft,
                      child: Container(
                        width: 40,
                        height: 20,
                        decoration:BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(temp.toString(), style: TextStyle(color: Colors.grey[400]),textAlign: TextAlign.center,),
                      )
                    ),
                    Positioned(
                      right: 30,
                      top: 10,
                      //alignment:Alignment.bottomLeft,
                     child: Container(
                        width: 40,
                        height: 35,
                        decoration:BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        ),
                        //a ? b : c evaluates to b if a is true and evaluates to c if a is false.
                        child: lights == "On" ? Image.asset("assets/bulbon.png") : Image.asset("assets/bulboff.png") 
                        //Text(lights.toString(), style: TextStyle(color: Colors.grey[400]),textAlign: TextAlign.center,),
                      )
                    ),
                    //fertilizer logo here
                    Positioned(
                      right: 80,
                      top: 10,
                      //alignment:Alignment.bottomLeft,
                     child: Container(
                        width: 40,
                        height: 35,
                        decoration:BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        ),
                        //a ? b : c evaluates to b if a is true and evaluates to c if a is false.
                        child: fertilizer == 1 ? Image.asset("assets/bulbon.png") : Image.asset("assets/bulboff.png") 
                        //Text(lights.toString(), style: TextStyle(color: Colors.grey[400]),textAlign: TextAlign.center,),
                      )
                    ),
                    Positioned(
                     right: 80,
                      bottom: 30,

                      //alignment:Alignment.bottomLeft,
                      child: Container(
                        width: 40,
                        height: 20,
                        decoration:BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(sensor.toString(), style: TextStyle(color: Colors.grey[400]),textAlign: TextAlign.center,),
                      )
                    ),
                    /*Positioned(
                      left: MediaQuery.of(context).size.width / 2 ,
                      top: 60,
                      //alignment:Alignment.bottomLeft,
                      child: Text(lights),
                    ),*/
                  ],
                ))));
  }
}
