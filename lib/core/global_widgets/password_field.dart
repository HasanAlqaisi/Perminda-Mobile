import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perminda/core/validators/local/local_validators.dart';

class PasswordField extends StatefulWidget {
  final String hintText;
  final String apiError;
  final Function validateRules;

  const PasswordField({this.hintText, this.apiError, this.validateRules});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        validator: (value) {
          return widget.validateRules(value);
        },
        obscureText: _obscureText,
        decoration: InputDecoration(
          errorText: widget.apiError,
          isDense: true,
          prefixIcon: Icon(Icons.vpn_key),
          suffixIcon: GestureDetector(
            onTap: _toggle,
            child: Icon(
              _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
            ),
          ),
          hintText: widget.hintText,
          contentPadding: EdgeInsets.only(left: 8),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
