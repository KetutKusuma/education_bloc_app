import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_bloc_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_bloc_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_bloc_app/src/on_boarding/persentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnBoardingCubit onBoardingCubit;

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
    onBoardingCubit = OnBoardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
    );
  });

  test('initial state should be [OnBoardingInital]', () {
    // assert
    expect(onBoardingCubit.state, const OnBoardingInitial());
  });
  group('cacheFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emits [CachingFirstTimer, UserCached] when it is successful',
      build: () {
        when(
          () => cacheFirstTimer(),
        ).thenAnswer(
          (invocation) async => const Right(
            null,
          ),
        );
        return onBoardingCubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => const <OnBoardingState>[
        CachingFirstTimer(),
        UserCached(),
      ],
    );
  });
}
