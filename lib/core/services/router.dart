import 'package:education_bloc_app/core/common/views/page_under_constructur.dart';
import 'package:education_bloc_app/core/extensions/context_extension.dart';
import 'package:education_bloc_app/core/services/injection_container.dart';
import 'package:education_bloc_app/src/auth/data/models/user_model.dart';
import 'package:education_bloc_app/src/auth/persentation/bloc/auth_bloc.dart';
import 'package:education_bloc_app/src/auth/persentation/views/sign_in_screen.dart';
import 'package:education_bloc_app/src/dashboard/persentation/views/dashboard.dart';
import 'package:education_bloc_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_bloc_app/src/on_boarding/persentation/cubit/on_boarding_cubit.dart';
import 'package:education_bloc_app/src/on_boarding/persentation/views/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      return _pageRouteBuilder(
        (context) {
          if (prefs.getBool(kFirstTimerKey) ?? true) {
            return BlocProvider(
              create: (context) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen(),
            );
          } else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;
            final localUser = LocalUserModel(
              uid: user.uid,
              email: user.email ?? '',
              fullName: user.displayName ?? '',
              points: 0,
            );

            context.userProvider.initUser(localUser);
            return const Dashboard();
          }

          return BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const SignInScreen(),
          );
        },
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
