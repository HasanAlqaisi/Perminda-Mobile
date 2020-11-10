import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
            highlightColor: Colors.white,
            onPressed: () {
              //TODO: Navigate to forgot password screen
            },
            child: Text(
              'Forgot password?',
              style: TextStyle(
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                  fontSize: 13.0),
            )),
      ),
    );
  }
}
