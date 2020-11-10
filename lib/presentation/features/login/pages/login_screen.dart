import 'package:flutter/material.dart';
import 'package:perminda/core/global_widgets/global_widgets.dart';
import 'package:perminda/core/validators/local/local_validators.dart';
import 'package:perminda/presentation/features/login/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
              hintText: 'Enter your email',
              prefixIcon: Icons.email,
              validateRules: (value) {
                return LocalValidators.emailValidation(value);
              },
            ),
            SizedBox(height: 30.0),
            PasswordField(hintText: 'Enter your password'),
            ForgotPasswordButton(),
            RectangleButton(
              text: 'Login',
              onPressed: () {
                //TODO: Make a logining request
              },
            ),
            RegisterButton(),
          ],
        ),
      ),
    );
  }
}
