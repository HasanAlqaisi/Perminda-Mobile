import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:perminda/presentation/features/forgot_password/pages/forgot_password_screen.dart';
import 'package:perminda/presentation/features/login/pages/login_screen.dart';
import 'package:perminda/presentation/features/nav/pages/home.dart';
import 'package:perminda/presentation/features/registration/pages/register_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(Perminda());
}

class Perminda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Home.route,
      routes: {
        LoginScreen.route: (context) => LoginScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
        ForgotPassScreen.route: (context) => ForgotPassScreen(),
        Home.route: (context) => Home(),
      },
    );
  }
}
