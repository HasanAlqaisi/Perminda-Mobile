import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:perminda/core/global_widgets/global_widgets.dart';
import 'package:perminda/core/validators/local/local_validators.dart';
import 'package:perminda/presentation/features/login/controller/login_controller.dart';
import 'package:perminda/presentation/features/login/widgets/widgets.dart';
import 'package:perminda/injection_container.dart' as di;

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

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: GetBuilder<LoginController>(
          init: di.sl<LoginController>(),
          builder: (_) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LogoImage(),
                RectangleTextField(
                  hintText: 'Username',
                  prefixIcon: FontAwesomeIcons.user,
                  widthMargin: 30.0,
                  validateRules: (value) {
                    _.username = value;
                    return LocalValidators.generalValidation(value);
                  },
                ),
                SizedBox(height: 30.0),
                PasswordField(
                  hintText: 'Password',
                  validateRules: (value) {
                    _.password = value;
                    return LocalValidators.generalValidation(value);
                  },
                ),
                ForgotPasswordButton(),
                RectangleButton(
                  childWidget: _.isLoading
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 3,
                        )
                      : Text('Login'),
                  onPressed: _.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState.validate()) {
                            _.onLoginClicked();
                          }
                        },
                ),
                RegisterButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}
