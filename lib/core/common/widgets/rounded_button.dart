import 'package:education_bloc_app/core/res/colours.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.labelText,
    required this.onPressed,
    super.key,
    this.buttonColor,
    this.labelColor,
  });

  final String labelText;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? Colours.primaryColour,
        foregroundColor: labelColor ?? Colors.white,
        minimumSize: const Size(
          double.maxFinite,
          50,
        ),
      ),
      child: Text(
        labelText,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
