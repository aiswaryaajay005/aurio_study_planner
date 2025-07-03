import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:aurio/core/utils/form_validation.dart';
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
      controller: controller,
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      validator: (value) => validator?.call(value),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      obscureText: obscureText ?? false,
    );
  }
}
