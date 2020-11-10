import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const RectangleButton({this.text, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(text),
        onPressed: () {
          if (Form.of(context).validate()) {
            onPressed();
          }
        },
      ),
    );
  }
}
