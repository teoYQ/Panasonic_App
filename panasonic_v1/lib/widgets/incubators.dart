import 'package:flutter/material.dart';
import 'package:panasonic_v1/authentication.dart';
import 'package:panasonic_v1/DIYpage2.dart';
import 'package:supercharged/supercharged.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
               if(fertilizer == 0){
                                    Fluttertoast.showToast(
        msg: "Please add some fertiliser to the tank",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: "#4d4d4d".toColor(),
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1
    );
                                  }
                                   if(sensor == 0){
                                    Fluttertoast.showToast(
        msg: "Please top up water to the tank",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: "#4d4d4d".toColor(),
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1
    );
                                  }
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
                        width: 30,
                        height: 26,
                       // margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        decoration:BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 3),
                        Text( temp.toString() + "°", style: TextStyle(color: Colors.grey[400]),textAlign: TextAlign.center,),
                          ]))
                    ),
                    Positioned(
                      right: 30,
                      top: 10,
                      //alignment:Alignment.bottomLeft,
                     child: Container(
                        width: 30,
                        height: 30,
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
                      right: 65,
                      top: 10,
                      //alignment:Alignment.bottomLeft,
                     child: Container(
                        width: 30,
                        height: 30,
                        decoration:BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        ),
                        //a ? b : c evaluates to b if a is true and evaluates to c if a is false.
                        child: fertilizer == 1 ? Image.asset("assets/highfertilizer.png") : Image.asset("assets/lowFertilizer.png") 
                        //Text(lights.toString(), style: TextStyle(color: Colors.grey[400]),textAlign: TextAlign.center,),
                      )
                    ),
                    Positioned(
                     right: 65,
                      bottom: 30,

                      //alignment:Alignment.bottomLeft,
                      child: Container(
                        width: 30,
                        height: 26,
                        decoration:BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        ),
                        child: sensor == 1 ? Image.asset("assets/highwater.png") : Image.asset("assets/lowwater.png"),
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
