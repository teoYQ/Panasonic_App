import 'package:flutter/material.dart';
import 'package:panasonic_v1/authentication.dart';
import 'package:panasonic_v1/DIYpage2.dart';
class IncubatorCard extends StatelessWidget {
  final String text;
  final String temp;
  final String lights;
  final String name;
  final BaseAuth auth;


  IncubatorCard({this.text, this.temp, this.lights,this.auth,this.name});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkResponse(
        onTap: () {
          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DIYPage(auth : this.auth, name : name, temp : int.parse(temp),incubatorname: this.text)),
                            );
        },
        child: Padding(
            padding: EdgeInsets.only(left: 1),
            child: Container(
                width: 125,
                height: 125,
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    Positioned(
                        //alignment: Alignment.center,
                        width: 100,
                        height: 80,
                        left: 30,
                        top: 10,
                        child: Image.asset(
                          "assets/incub.png",
                          scale: 0.5,
                        )),
                    
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      top: 20,
                      //alignment:Alignment.bottomLeft,
                      child: Text(text),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 + 30,
                      top: 40,
                      //alignment:Alignment.bottomLeft,
                      child: Text(temp),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      top: 40,

                      //alignment:Alignment.bottomLeft,
                      child: Text("temperature:"),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      top: 60,

                      //alignment:Alignment.bottomLeft,
                      child: Text("lights:"),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 ,
                      top: 60,
                      //alignment:Alignment.bottomLeft,
                      child: Text(lights),
                    ),
                  ],
                ))));
  }
}
