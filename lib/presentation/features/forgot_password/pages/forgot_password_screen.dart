import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perminda/core/constants/constants.dart';
import 'package:perminda/core/global_widgets/global_widgets.dart';
import 'package:perminda/core/validators/local/local_validators.dart';
import 'package:perminda/presentation/features/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:perminda/injection_container.dart' as di;

class ForgotPassScreen extends StatelessWidget {
  static const route = '/forgot';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('retrieve your account'),
        leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => di.sl<ForgotPasswordBloc>(),
          child: ForgotPassDesign(),
        ),
      ),
    );
  }
}

class ForgotPassDesign extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
      if (state is Success) {
        Fluttertoast.showToast(msg: 'Check your email to reset your password!');
      } else if (state is Error) {
        Fluttertoast.showToast(msg: unknownErrorMessage);
      }
    }, builder: (context, state) {
      if (state is Loading) {
        return _buildForm(context: context, inProgress: true);
      } else {
        return _buildForm(context: context, inProgress: false);
      }
    });
  }

  Widget _buildForm({BuildContext context, bool inProgress}) {
    String email;
    return Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'We will send you an email so you can get to work again 😀',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              RectangleTextField(
                hintText: 'Email',
                prefixIcon: Icons.email,
                widthMargin: 30.0,
                validateRules: (value) {
                  email = value;
                  return LocalValidators.emailValidation(value);
                },
              ),
              SizedBox(height: 10),
              RectangleButton(
                childWidget: inProgress
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 3,
                      )
                    : Text('Confirm'),
                onPressed: inProgress
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          context
                              .read<ForgotPasswordBloc>()
                              .add(ConfirmClicked(email: email));
                        }
                      },
              )
            ],
          ),
        ),
      ),
    );
  }
}
