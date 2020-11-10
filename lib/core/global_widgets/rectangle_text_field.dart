import 'package:flutter/material.dart';

class RectangleTextField extends StatelessWidget {
  final String hintText;
  final Function validateRules;
  final IconData prefixIcon;

  RectangleTextField({this.hintText, this.validateRules, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        validator: (value) {
          return validateRules(value);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(prefixIcon),
          hintText: hintText,
          contentPadding: EdgeInsets.only(left: 8),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
    );
  }
}
