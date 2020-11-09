import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) return 'Please Enter your password';
          return null;
        },
        obscureText: _obscureText,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(Icons.vpn_key),
          suffixIcon: GestureDetector(
            onTap: _toggle,
            child: Icon(
              _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
            ),
          ),
          hintText: 'Enter your password',
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
