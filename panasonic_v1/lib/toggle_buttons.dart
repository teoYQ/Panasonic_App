import 'package:flutter/material.dart';
class TapboxA extends StatefulWidget {
  TapboxA({Key key}) : super(key: key);

  @override
  _TapboxAState createState() => _TapboxAState();
}

class _TapboxAState extends State<TapboxA> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
      print("switched light");
    });
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            _active ? 'Turn off lights' : 'Turn on lights',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        width: 200,
        height: 30,
        // to color buttons add the following
        decoration: BoxDecoration(
          color: _active ?  Colors.grey[600]:Colors.lightGreen[700],
       ),
      ),
    );
  }
}