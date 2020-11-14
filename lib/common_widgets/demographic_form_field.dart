import 'package:flutter/material.dart';

class DemographicFormField extends StatelessWidget {
  DemographicFormField(
      {this.hintText, this.helperText, this.keyboardType, this.controller});
  @required
  final String hintText;
  @required
  final String helperText;
  @required
  final TextInputType keyboardType;
  @required
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white, fontFamily: "Futura"),
        helperText: helperText,
        helperStyle: TextStyle(color: Colors.white, fontFamily: "Futura", fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Futura',
      ),
      controller: controller,
    );
  }
}
