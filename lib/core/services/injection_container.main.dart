part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initAuth();
}

Future<void> _initAuth() async {
  sl
    ..registerFactory(
      () => AuthBloc(
          signIn: sl(), signUp: sl(), updateUser: sl(), forgotPassword: sl()),
    )
    ..registerLazySingleton(
      () => SignIn(authRepo: sl()),
    )
    ..registerLazySingleton(
      () => SignUp(sl()),
    )
    ..registerLazySingleton(
      () => UpdateUser(sl()),
    )
    ..registerLazySingleton(
      () => ForgotPassword(sl()),
    )
    ..registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(sl()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
          authClient: sl(), cloudStoreClient: sl(), dbClient: sl()),
    )
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance);
}

Future<void> _initOnBoarding() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
        () => OnBoardingLclDataSrcImpl(sl()))
    ..registerLazySingleton(() => prefs);
}
