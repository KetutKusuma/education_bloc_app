part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  log('route : ${settings.name}, settings : $settings');
  switch (settings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      return _pageRouteBuilder(
        (context) {
          log('uhuy : ${prefs.getBool(kFirstTimerKey)}');
          if (prefs.getBool(kFirstTimerKey) ?? false) // ini harusnya true
          {
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
    case SignInScreen.routeName:
      return _pageRouteBuilder(
        (p0) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case '/forgot-password':
      return _pageRouteBuilder(
        (p0) => Text('reset password'),
        settings: settings,
      );
    case SignUpScreen.routeName:
      return _pageRouteBuilder(
        (p0) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );
    case Dashboard.routeName:
      return _pageRouteBuilder(
        (p0) => const Dashboard(),
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
  // return PageRouteBuilder(
  //   settings: settings,
  //   transitionsBuilder: (_, animation, __, child) => FadeTransition(
  //     opacity: animation,
  //     child: child,
  //   ),
  //   pageBuilder: (context, _, __) => page(context),
  // );
  return PageRouteBuilder(
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0, 1);
      const end = Offset.zero;
      const curve = Curves.ease;
      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => page(context),
  );
}
