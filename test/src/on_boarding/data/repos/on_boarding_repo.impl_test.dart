import 'package:dartz/dartz.dart';
import 'package:education_bloc_app/core/errors/exception.dart';
import 'package:education_bloc_app/core/errors/failures.dart';
import 'package:education_bloc_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_bloc_app/src/on_boarding/data/repos/on_boarding_repo.impl.dart';
import 'package:education_bloc_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSrc extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSrc();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  test('should be a subclass of [OnBoardingRepo]', () {
    // arrange

    // act

    // assert
    expect(repoImpl, isA<OnBoardingRepo>());
  });

  group('cacheFirstTimer', () {
    test('should complete successfully when call to local data source',
        () async {
      // arrange
      when(
        () => localDataSource.cacheFirstTimer(),
      ).thenAnswer(
        (_) async => Future.value(),
      );
      // act
      final result = await repoImpl.cacheFirstTimer();
      // assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => localDataSource.cacheFirstTimer(),
      ).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test(
      'should return [Cache Failure] when call to local data '
      'source is unsucessfull',
      () async {
        // arrange
        when(
          () => localDataSource.cacheFirstTimer(),
        ).thenThrow(
          const CacheException(
            message: 'Insufficient storage',
          ),
        );

        final result = await repoImpl.cacheFirstTimer();

        expect(
          result,
          Left<CacheFailure, dynamic>(
            CacheFailure(
              message: 'Insufficient storage',
              statusCode: 500,
            ),
          ),
        );

        verify(
          () => localDataSource.cacheFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );
  });
}
