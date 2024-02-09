import 'package:education_bloc_app/core/common/widgets/i_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.fullNameController,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController fullNameController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obsecurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            textEditingController: widget.fullNameController,
            hintText: 'Full Name',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: 15,
          ),
          IField(
            textEditingController: widget.emailController,
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 15,
          ),
          IField(
            textEditingController: widget.passwordController,
            hintText: 'Password',
            keyboardType: TextInputType.visiblePassword,
            obsecureText: obsecurePassword,
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                obsecurePassword = !obsecurePassword;
              }),
              icon: Icon(
                obsecurePassword ? IconlyLight.show : IconlyLight.hide,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          IField(
            textEditingController: widget.confirmPasswordController,
            hintText: 'Confirm Password',
            keyboardType: TextInputType.visiblePassword,
            obsecureText: obsecurePassword,
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                obsecurePassword = !obsecurePassword;
              }),
              icon: Icon(
                obsecurePassword ? IconlyLight.show : IconlyLight.hide,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
