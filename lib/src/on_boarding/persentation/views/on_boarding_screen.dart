import 'package:education_bloc_app/core/common/views/loading_view.dart';
import 'package:education_bloc_app/core/common/widgets/gradient_background.dart';
import 'package:education_bloc_app/core/res/colours.dart';
import 'package:education_bloc_app/core/res/media_res.dart';
import 'package:education_bloc_app/src/on_boarding/domain/page_content.dart';
import 'package:education_bloc_app/src/on_boarding/persentation/cubit/on_boarding_cubit.dart';
import 'package:education_bloc_app/src/on_boarding/persentation/widgets/on_boarding_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();
  List<Widget> listWidgetPage = const [
    OnBoardingBody(pageContent: PageContent.first()),
    OnBoardingBody(pageContent: PageContent.second()),
    OnBoardingBody(pageContent: PageContent.third()),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    // context.read
    return Scaffold(
      body: GradientBackgroundWidget(
        image: MediaRes.onBoardingBackground,
        child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
          listener: (context, state) {
            if (state is OnBoardingStatus && !state.isFirstTimer) {
              Navigator.pushReplacementNamed(context, '/home');
            }

            if (state is UserCached) {
              //TODO: (User cached handler) : push to apporociter screen
            }
          },
          builder: (context, state) {
            if (state is CheckingIfUserIsFirstTimer ||
                state is CachingFirstTimer) {
              return const LoadingView();
            }
            return GradientBackgroundWidget(
              image: MediaRes.onBoardingBackground,
              child: Stack(
                children: [
                  PageView(
                    controller: pageController,
                    children: listWidgetPage,
                  ),
                  Align(
                    alignment: const Alignment(0, .04),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: listWidgetPage.length,
                      onDotClicked: (index) {
                        pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      effect: const WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 40,
                        activeDotColor: Colours.primaryColour,
                        dotColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
