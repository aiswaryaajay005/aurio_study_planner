import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/utils/form_validation.dart';
import 'package:flutter/material.dart';

class ReusableTextFormField extends StatelessWidget {
  final String labelText;
  final bool? obscureText;
  final Icon? suffixIcon;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  const ReusableTextFormField({
    super.key,
    required this.labelText,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: ColorConstants.TextColor),
      validator: (value) => validator?.call(value),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: ColorConstants.TextColor),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.accentColor),
        ),
        errorStyle: TextStyle(color: ColorConstants.accentColor),
      ),
      obscureText: obscureText ?? false,
    );
  }
}
