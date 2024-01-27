import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_bloc_app/core/errors/failures.dart';
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

  final tFailure = CacheFailure(
    message: 'Insufficient storage permission',
    statusCode: 4032,
  );
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
      verify: (_) {
        verify(
          () => cacheFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
    //
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emits [CachingFirstTimer, OnBoardingError] '
      'when it is unsuccessful',
      build: () {
        when(
          () => cacheFirstTimer(),
        ).thenAnswer(
          (invocation) async => Left(tFailure),
        );
        return onBoardingCubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => <OnBoardingState>[
        const CachingFirstTimer(),
        OnBoardingError(
          tFailure.errorMessage,
        ),
      ],
      verify: (_) {
        verify(
          () => cacheFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
    //
  });
  //

  group('checkIfUserIsFirstTimer', () {
    //
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emits [CheckingIfUserIsFirstTimer, OnBoardingStatus(false)] '
      'when it is successful',
      build: () {
        when(
          () => checkIfUserIsFirstTimer(),
        ).thenAnswer(
          (invocation) async => const Right(true),
        );
        return onBoardingCubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => const <OnBoardingState>[
        CheckingIfUserIsFirstTimer(),
        OnBoardingStatus(
          isFirstTimer: true,
        ),
      ],
      verify: (_) {
        verify(
          () => checkIfUserIsFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
    //

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emits [CheckingIfUserIsFirstTimer, OnBoardingStatus(true)] '
      'when it is unsuccessful',
      build: () {
        when(
          () => checkIfUserIsFirstTimer(),
        ).thenAnswer(
          (invocation) async => Left(tFailure),
        );
        return onBoardingCubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => const <OnBoardingState>[
        CheckingIfUserIsFirstTimer(),
        OnBoardingStatus(
          isFirstTimer: true,
        ),
      ],
      verify: (_) {
        verify(
          () => checkIfUserIsFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
