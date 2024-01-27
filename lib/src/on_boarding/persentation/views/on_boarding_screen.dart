import 'package:education_bloc_app/src/on_boarding/persentation/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    // context.read
    return BlocListener<OnBoardingCubit, OnBoardingState>(
      listener: (context, state) {
        if (state is OnBoardingStatus) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
    );
  }
}
