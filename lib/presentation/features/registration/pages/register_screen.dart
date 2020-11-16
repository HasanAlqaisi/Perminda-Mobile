import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perminda/core/constants/constants.dart';
import 'package:perminda/core/errors/failure.dart';
import 'package:perminda/core/global_widgets/global_widgets.dart';
import 'package:perminda/core/validators/local/local_validators.dart';
import 'package:perminda/injection_container.dart' as di;
import 'package:perminda/presentation/features/registration/bloc/register_bloc.dart';

class RegisterScreen extends StatelessWidget {
  static const route = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => di.sl<RegisterBloc>(),
        child: SafeArea(
          child: Center(
            child: RegisterForm(),
          ),
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
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          //TODO: Navigate to home screen
        }
        if (state is RegisterError) {
          if (state.failure is UnknownFailure) {
            Fluttertoast.showToast(msg: unknownErrorMessage);
          } else if (state.failure is NoInternetFailure) {
            Fluttertoast.showToast(msg: noInternetMessage);
          }
        }
      },
      builder: (context, state) {
        if (state is RegisterError) {
          if (state.failure is FieldsFailure) {
            return _buildForm(state: state, inProgress: false);
          } else {
            return _buildForm(state: null, inProgress: false);
          }
        } else if (state is RegisterInProgress) {
          return _buildForm(state: null, inProgress: true);
        } else {
          return _buildForm(state: null, inProgress: false);
        }
      },
    );
  }

  Widget _buildForm({RegisterError state, bool inProgress}) {
    String firstName, lastName, username, email, phone, password;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LogoImage(),
            RectangleTextField(
              hintText: 'First name',
              prefixIcon: FontAwesomeIcons.user,
              widthMargin: 30.0,
              validateRules: (value) {
                firstName = value;
                return LocalValidators.generalValidation(value);
              },
              apiError: (state?.failure as FieldsFailure)?.firstName?.first,
            ),
            SizedBox(height: 20),
            RectangleTextField(
              hintText: 'Last name',
              prefixIcon: FontAwesomeIcons.user,
              widthMargin: 30.0,
              validateRules: (value) {
                lastName = value;
                return LocalValidators.generalValidation(value);
              },
              apiError: (state?.failure as FieldsFailure)?.lastName?.first,
            ),
            SizedBox(height: 20.0),
            RectangleTextField(
              hintText: 'Username',
              prefixIcon: FontAwesomeIcons.user,
              widthMargin: 30.0,
              validateRules: (value) {
                username = value;
                return LocalValidators.generalValidation(value);
              },
              apiError: (state?.failure as FieldsFailure)?.userName?.first,
            ),
            SizedBox(height: 20.0),
            RectangleTextField(
              hintText: 'Email',
              prefixIcon: Icons.email,
              widthMargin: 30.0,
              validateRules: (value) {
                email = value;
                return LocalValidators.emailValidation(value);
              },
              apiError: (state?.failure as FieldsFailure)?.email?.first,
            ),
            SizedBox(height: 20.0),
            RectangleTextField(
              hintText: '+7...',
              prefixIcon: FontAwesomeIcons.phone,
              widthMargin: 30.0,
              validateRules: (value) {
                phone = LocalValidators.phoneHandledValidation(value);
                return LocalValidators.generalValidation(value);
              },
              apiError: (state?.failure as FieldsFailure)?.lastName?.first,
            ),
            SizedBox(height: 20.0),
            PasswordField(
              hintText: 'Password',
              apiError: (state?.failure as FieldsFailure)?.password?.first,
              validateRules: (value) {
                password = value;
                return LocalValidators.generalValidation(value);
              },
            ),
            SizedBox(height: 20.0),
            RectangleButton(
              childWidget: inProgress
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white, strokeWidth: 3)
                  : Text('Register'),
              onPressed: inProgress
                  ? null
                  : () {
                      if (_formKey.currentState.validate()) {
                        context.read<RegisterBloc>().add(RegisterClicked(
                              firstName: firstName,
                              lastName: lastName,
                              username: username,
                              email: email,
                              phone: phone,
                              password: password,
                            ));
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
