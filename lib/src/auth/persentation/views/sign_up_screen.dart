import 'package:education_bloc_app/core/common/app/providers/user_provider.dart';
import 'package:education_bloc_app/core/common/widgets/gradient_background.dart';
import 'package:education_bloc_app/core/common/widgets/rounded_button.dart';
import 'package:education_bloc_app/core/res/fonts.dart';
import 'package:education_bloc_app/core/res/media_res.dart';
import 'package:education_bloc_app/core/utils/core_utils.dart';
import 'package:education_bloc_app/src/auth/data/models/user_model.dart';
import 'package:education_bloc_app/src/auth/persentation/bloc/auth_bloc.dart';
import 'package:education_bloc_app/src/auth/persentation/views/sign_in_screen.dart';
import 'package:education_bloc_app/src/auth/persentation/widgets/sign_up_form.dart';
import 'package:education_bloc_app/src/dashboard/persentation/views/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedUp) {
            context.read<AuthBloc>().add(
                  SignUpEvent(
                    email: emailController.text.trim(),
                    fullName: fullNameController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user as LocalUserModel);
            Navigator.pushNamedAndRemoveUntil(
              context,
              Dashboard.routeName,
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          return GradientBackgroundWidget(
            image: MediaRes.authGradientBackground,
            child: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Text(
                      'Easy learn sql, discover more skills',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: Fonts.aeonik,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Sign up to your account',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            SignInScreen.routeName,
                          );
                        },
                        child: const Text(
                          'Already have an account?',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SignUpForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      formKey: formKey,
                      fullNameController: fullNameController,
                    ),
                    // SignInForm(
                    //   emailController: emailController,
                    //   passwordController: passwordController,
                    //   formKey: formKey,
                    // ),

                    const SizedBox(
                      height: 25,
                    ),
                    if (state is AuthLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      RoundedButton(
                        labelText: 'Sign Up',
                        onPressed: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();

                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    fullName: fullNameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
