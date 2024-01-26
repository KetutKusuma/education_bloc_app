import 'package:dartz/dartz.dart';
import 'package:education_bloc_app/core/errors/failures.dart';
import 'package:education_bloc_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:education_bloc_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CheckIfUserIsFirstTimer(repo);
  });

  test('should get a response from the [MockOnBoardingRepo]', () async {
    // arrange
    when(
      () => repo.checkIfUserIsFirstTimer(),
    ).thenAnswer(
      (_) async => const Right(true),
    );

    // act
    final result = await usecase();

    // assert
    expect(
      result,
      equals(
        const Right<dynamic, bool>(true),
      ),
    );
    verify(
      () => repo.checkIfUserIsFirstTimer(),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
  test(
    'should call the [OnBoardingRepo.CheckIfUserIsFirstTimer] '
    'and return right data',
    () async {
      // arrange
      when(
        () => repo.checkIfUserIsFirstTimer(),
      ).thenAnswer(
        (_) async => Left(
          ServerFailure(
            message: 'Unknown Error Occured',
            statusCode: 500,
          ),
        ),
      );

      // act
      final result = await usecase();
      // assert
      expect(
        result,
        equals(
          Left<ServerFailure, dynamic>(
            ServerFailure(
              message: 'Unknown Error Occured',
              statusCode: 500,
            ),
          ),
        ),
      );

      verify(
        () => repo.cacheFirstTimer(),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
