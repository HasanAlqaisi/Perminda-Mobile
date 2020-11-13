import 'package:flutter/material.dart';
import 'package:perminda/presentation/features/forgot_password/pages/forgot_password_screen.dart';
import 'package:perminda/presentation/features/login/pages/login_screen.dart';
import 'package:perminda/presentation/features/registration/pages/register_screen.dart';
import 'injection_container.dart' as di;

void main() {
  di.init();
  runApp(Perminda());
}

class Perminda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginScreen.route,
      routes: {
        LoginScreen.route: (context) => LoginScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
        ForgotPassScreen.route: (context) => ForgotPassScreen(),
      },
    );
  }
}
