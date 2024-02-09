import 'package:education_bloc_app/core/res/colours.dart';
import 'package:flutter/material.dart';

class CoreUtils {
  const CoreUtils._();

  /// private

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          backgroundColor: Colours.primaryColour,
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
  }
}
