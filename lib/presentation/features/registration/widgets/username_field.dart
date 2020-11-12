import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perminda/core/validators/local/local_validators.dart';

class UsernameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        validator: (value) {
          return LocalValidators.generalValidation(value);
        },
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(FontAwesomeIcons.user),
          hintText: 'Username',
          contentPadding: EdgeInsets.only(left: 8),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
    );
  }
}
