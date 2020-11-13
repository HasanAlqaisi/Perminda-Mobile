import 'package:flutter/material.dart';
import 'package:perminda/presentation/features/forgot_password/pages/forgot_password_screen.dart';

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
              Navigator.pushNamed(context, ForgotPassScreen.route);
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
