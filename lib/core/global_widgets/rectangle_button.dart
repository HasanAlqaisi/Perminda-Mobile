import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final Function onPressed;
  final Widget childWidget;

  const RectangleButton({this.onPressed, this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: childWidget,
        onPressed: () {
          onPressed?.call();
        },
      ),
    );
  }
}
