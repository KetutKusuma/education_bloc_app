import 'package:education_bloc_app/core/extensions/context_extension.dart';
import 'package:education_bloc_app/core/res/colours.dart';
import 'package:education_bloc_app/core/res/fonts.dart';
import 'package:education_bloc_app/src/on_boarding/domain/page_content.dart';
import 'package:education_bloc_app/src/on_boarding/persentation/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({
    required this.pageContent,
    super.key,
  });

  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: context.height * .08,
        ),
        Image.asset(
          pageContent.image,
          height: context.height * .4,
        ),
        SizedBox(
          height: context.height * .03,
        ),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(
            bottom: 0,
          ),
          child: Column(
            children: [
              Text(
                pageContent.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: Fonts.aeonik,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  wordSpacing: 0,
                  letterSpacing: 0,
                  height: 0,
                ),
              ),
              SizedBox(
                height: context.height * .02,
              ),
              Text(
                pageContent.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  wordSpacing: 0,
                  letterSpacing: 0,
                  height: 0,
                ),
              ),
              SizedBox(
                height: context.height * .05,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 17,
                  ),
                  backgroundColor: Colours.primaryColour,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  // TODO:(Get-Started) implement this function
                  await context
                      .read<OnBoardingCubit>()
                      .checkIfUserIsFirstTimer();
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontFamily: Fonts.aeonik,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
