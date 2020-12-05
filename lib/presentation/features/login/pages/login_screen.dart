import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perminda/core/constants/constants.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/global_widgets/global_widgets.dart';
import 'package:perminda/core/validators/local/local_validators.dart';
import 'package:perminda/presentation/features/login/bloc/login_bloc.dart';
import 'package:perminda/presentation/features/login/widgets/widgets.dart';
import 'package:perminda/injection_container.dart' as di;
import 'package:perminda/presentation/features/nav/pages/home.dart';

class LoginScreen extends StatelessWidget {
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => di.sl<LoginBloc>(),
        child: SafeArea(
          child: Center(
            child: LoginForm(),
          ),
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
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(CheckAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is AuthedState) {
          Navigator.pushNamedAndRemoveUntil(
              context, Home.route, (route) => false);
        } else if (state is LoginError) {
          if (state.failure is NonFieldsFailure) {
            Fluttertoast.showToast(
                msg: (state.failure as NonFieldsFailure)?.errors?.first);
          } else if (state.failure is UnknownFailure) {
            Fluttertoast.showToast(msg: unknownErrorMessage);
          } else if (state.failure is NoInternetFailure) {
            Fluttertoast.showToast(msg: noInternetMessage);
          }
        } else if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, Home.route, (route) => false);
        }
      },
      builder: (context, state) {
        if (state is LoginInProgress)
          return _buildForm(inProgress: true);
        else
          return _buildForm(inProgress: false);
      },
    );
  }

  Widget _buildForm({bool inProgress}) {
    String username, password;

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
              widthMargin: 30.0,
              validateRules: (value) {
                username = value;
                return LocalValidators.generalValidation(value);
              },
            ),
            SizedBox(height: 30.0),
            PasswordField(
              hintText: 'Password',
              validateRules: (value) {
                password = value;
                return LocalValidators.generalValidation(value);
              },
            ),
            ForgotPasswordButton(),
            RectangleButton(
              childWidget: inProgress
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 3,
                    )
                  : Text('Login'),
              onPressed: inProgress
                  ? null
                  : () {
                      if (_formKey.currentState.validate()) {
                        context
                            .read<LoginBloc>()
                            .add(LoginClicked(username, password));
                      }
                    },
            ),
            RegisterButton(),
          ],
        ),
      ),
    );
  }
}
