import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class ReusableHeader extends StatelessWidget {
  final String textContent;

  const ReusableHeader({super.key, required this.textContent});

  @override
  Widget build(BuildContext context) {
    return Text(
      textContent,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
