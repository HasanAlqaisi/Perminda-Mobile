import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) return 'Please Enter your email';
          if (!value.contains('@')) return 'Enter a valid email';
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(Icons.email),
          hintText: 'Enter your email',
          contentPadding: EdgeInsets.only(left: 8),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
    );
  }
}
