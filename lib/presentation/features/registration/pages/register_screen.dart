import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perminda/core/global_widgets/global_widgets.dart';
import 'package:perminda/core/validators/local/local_validators.dart';

class RegisterScreen extends StatelessWidget {
  static const route = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LogoImage(),
            RectangleTextField(
              hintText: 'Username',
              prefixIcon: FontAwesomeIcons.user,
              validateRules: (value) {
                return LocalValidators.usernameValidation(value);
              },
            ),
            SizedBox(height: 20.0),
            RectangleTextField(
              hintText: 'Email',
              prefixIcon: Icons.email,
              validateRules: (value) {
                return LocalValidators.emailValidation(value);
              },
            ),
            SizedBox(height: 20.0),
            PasswordField(hintText: 'Password'),
            SizedBox(height: 20.0),
            RectangleButton(
              text: 'Register',
              onPressed: () {
                //TODO: make a registration request
              },
            ),
          ],
        ),
      ),
    );
  }
}
