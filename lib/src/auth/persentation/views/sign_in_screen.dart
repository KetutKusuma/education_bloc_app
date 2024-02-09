import 'dart:developer';

import 'package:education_bloc_app/core/common/app/providers/user_provider.dart';
import 'package:education_bloc_app/core/common/widgets/gradient_background.dart';
import 'package:education_bloc_app/core/common/widgets/rounded_button.dart';
import 'package:education_bloc_app/core/res/fonts.dart';
import 'package:education_bloc_app/core/res/media_res.dart';
import 'package:education_bloc_app/core/utils/core_utils.dart';
import 'package:education_bloc_app/src/auth/data/models/user_model.dart';
import 'package:education_bloc_app/src/auth/persentation/bloc/auth_bloc.dart';
import 'package:education_bloc_app/src/auth/persentation/views/sign_up_screen.dart';
import 'package:education_bloc_app/src/auth/persentation/widgets/sign_in_form.dart';
import 'package:education_bloc_app/src/dashboard/persentation/views/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          log('uhuy state signin : $state');
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user as LocalUserModel);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
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
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign in to your account',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Baseline(
                          baseline: 100,
                          baselineType: TextBaseline.alphabetic,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                SignUpScreen.routeName,
                              );
                            },
                            child: const Text(
                              'Register account?',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SignInForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      formKey: formKey,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: const Text(
                          'Forgot Password',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    if (state is AuthLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      RoundedButton(
                        labelText: 'Sign In',
                        onPressed: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          log('signin - 2');

                          if (formKey.currentState!.validate()) {
                            log('signin');
                            context.read<AuthBloc>().add(
                                  SignInEvent(
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
