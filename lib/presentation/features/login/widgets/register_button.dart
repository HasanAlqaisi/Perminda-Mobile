import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Don\'t have an account?',
                style: TextStyle(color: Colors.grey)),
            TextSpan(text: ' Register', style: TextStyle(color: Colors.blue))
          ],
        ),
      ),
      onPressed: () {
        //TODO: Navigate to register screen
      },
    );
  }
}
