import 'package:education_bloc_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_bloc_app/src/on_boarding/data/repos/on_boarding_repo.impl.dart';
import 'package:education_bloc_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:education_bloc_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_bloc_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_bloc_app/src/on_boarding/persentation/cubit/on_boarding_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
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