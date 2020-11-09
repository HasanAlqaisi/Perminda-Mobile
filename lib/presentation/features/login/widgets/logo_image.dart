import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(60.0),
      child: Image.asset(
        'images/logo.jpeg',
        width: 150.0,
        height: 150.0,
      ),
    );
  }
}
