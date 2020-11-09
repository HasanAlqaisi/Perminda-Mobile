import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text('Login'),
        onPressed: () {
          if (Form.of(context).validate()) {
            //TODO: Make a login request
          }
        },
      ),
    );
  }
}
