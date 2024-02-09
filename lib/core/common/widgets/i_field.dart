import 'package:flutter/material.dart';

class IField extends StatelessWidget {
  const IField({
    required this.textEditingController,
    this.filled = false,
    this.obsecureText = false,
    this.readyOnly = false,
    this.overrideValidator = false,
    this.validator,
    this.fillColour,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
    super.key,
  });

  final String? Function(String?)? validator;
  final TextEditingController textEditingController;
  final bool filled;
  final bool obsecureText;
  final bool readyOnly;
  final Color? fillColour;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool overrideValidator;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      validator: overrideValidator
          ? validator
          : (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return '';
            },
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      keyboardType: keyboardType,
      obscureText: obsecureText,
      readOnly: readyOnly,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        // overwriting the default padding helps with puffy look
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        filled: filled,
        fillColor: fillColour,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: hintStyle ??
            const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }
}
