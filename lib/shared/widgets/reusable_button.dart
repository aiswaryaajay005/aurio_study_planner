import 'dart:developer';

import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  String btnText;
  final VoidCallback? onValidSubmit;
  ReusableButton({
    super.key,
    required this.btnText,
    this.formKey,
    this.onValidSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onPressed: () {
        if (formKey != null) {
          final isValid = formKey!.currentState?.validate() ?? false;
          if (isValid) {
            log("Form is valid");
            onValidSubmit?.call();
          } else {
            log("Form is invalid");
          }
        } else {
          onValidSubmit?.call();
        }
      },
      child: Text(
        btnText,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
