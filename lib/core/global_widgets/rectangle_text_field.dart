import 'package:flutter/material.dart';

class RectangleTextField extends StatelessWidget {
  final String hintText;
  final Function validateRules;
  final IconData prefixIcon;
  final String apiError;
  final double widthMargin;

  RectangleTextField(
      {this.hintText, this.validateRules, this.prefixIcon, this.apiError, this.widthMargin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widthMargin),
      child: TextFormField(
        validator: (value) {
          return validateRules(value);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          errorMaxLines: 2,
          errorText: apiError,
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
