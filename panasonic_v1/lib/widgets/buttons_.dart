

import 'package:flutter/material.dart';

class ButtonActivity extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  ButtonActivity(this.icon, this.text, this.onTap);
  bool _state = false;
  @override

  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 0, 8.0, 0),
        child: Material(
          child: Ink(decoration: BoxDecoration(
            color: Colors.white,
          ),
          child:InkWell( 
            onTap: onTap,
            child: Container(
                height: 150,
                width: 150,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                    ),
                    IconTheme(data: new IconThemeData(color: Colors.green[900]),
                    child: new Icon(icon),),
                    //Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                    ),
                    Text(text)
                  ],
                ))))));
  }
}
