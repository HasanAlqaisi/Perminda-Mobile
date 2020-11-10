import 'package:flutter/material.dart';
import 'package:perminda/presentation/features/login/pages/login_screen.dart';
import 'package:perminda/presentation/features/registration/pages/register_screen.dart';

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
      initialRoute: LoginScreen.route,
      routes: {
        LoginScreen.route: (context) => LoginScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
      },
    );
  }
}
