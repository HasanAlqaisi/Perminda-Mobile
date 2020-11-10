import 'package:flutter/material.dart';
import 'package:perminda/core/constants/constants.dart';

class LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: kHeroAnimLogoTag,
      child: Padding(
        padding: EdgeInsets.all(60.0),
        child: Image.asset(
          'images/logo.jpeg',
          width: 150.0,
          height: 150.0,
        ),
      ),
    );
  }
}
