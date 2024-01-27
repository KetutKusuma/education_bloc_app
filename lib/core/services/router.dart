import 'package:education_bloc_app/core/common/views/page_under_constructur.dart';
import 'package:education_bloc_app/src/on_boarding/persentation/cubit/on_boarding_cubit.dart';
import 'package:education_bloc_app/src/on_boarding/persentation/views/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnBoardingScreen.routeName:
      return _pageRouteBuilder(
        (p0) => BlocProvider(
          create: (context) => sl<OnBoardingCubit>(),
          child: const OnBoardingScreen(),
        ),
        settings: settings,
      );
    default:
      return _pageRouteBuilder(
        (p0) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageRouteBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
