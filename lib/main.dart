import 'package:flutter/material.dart';
import 'package:perminda/presentation/features/login/pages/login_screen.dart';

void main() {
  runApp(Perminda());
}

class Perminda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'This is the start point of the app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
