import 'package:education_bloc_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_bloc_app/core/errors/exception.dart';

class MockSharedPrefences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnBoardingLocalDataSource localDataSource;

  setUp(() {
    prefs = MockSharedPrefences();
    localDataSource = OnBoardingLclDataSrcImpl(prefs);
  });

  group('cacheFirstTimer', () {
    test('should call [SharedPreferences] to cache data', () async {
      // arrange
      when(
        () => prefs.setBool(
          any(),
          any(),
        ),
      ).thenAnswer((invocation) async => true);
      // act
      await localDataSource.cacheFirstTimer();
      // assert
      verify(
        () => prefs.setBool(kFirstTimerKey, false),
      );
      verifyNoMoreInteractions(prefs);
    });
    test(
        'should throw a [ChacheException] when there '
        'is an error caching the data', () async {
      // arrange
      when(
        () => prefs.setBool(
          any(),
          any(),
        ),
      ).thenThrow(
        Exception(),
      );
      // act
      final methodCall = localDataSource.cacheFirstTimer;

      // assert
      expect(methodCall, throwsA(isA<CacheException>()));
      verify(
        () => prefs.setBool(kFirstTimerKey, false),
      );
      verifyNoMoreInteractions(prefs);
    });
  });

  group('checkIfUserIsFirstTimer', () {
    test(
        'should call [SharedPreferences] to check if user is first timer '
        'and return the right response from storage when data is exists',
        () async {
      // arrange
      when(
        () => prefs.getBool(
          any(),
        ),
      ).thenReturn(false);

      // act
      final result = await localDataSource.checkIfUserIsFirstTimer();
      // assert
      expect(result, false);
      verify(() => prefs.getBool(kFirstTimerKey));
      verifyNoMoreInteractions(prefs);
    });

    test(
      'should return true if there is no data in storage ',
      () async {
        // arrange
        when(
          () => prefs.getBool(any()),
        ).thenReturn(null);

        // act
        final result = await localDataSource.checkIfUserIsFirstTimer();

        // assert
        expect(result, true);
        verify(() => prefs.getBool(kFirstTimerKey));
        verifyNoMoreInteractions(prefs);
      },
    );

    test(
        'should throw a [CacheException] when there '
        'is an error retrieving the data', () async {
      // arrange
      when(
        () => prefs.getBool(any()),
      ).thenThrow(
        Exception(),
      );
      // act
      final methodCall = localDataSource.checkIfUserIsFirstTimer();

      // assert
      expect(methodCall, throwsA(isA<CacheException>()));
      verify(
        () => prefs.getBool(kFirstTimerKey),
      ).called(1);
      verifyNoMoreInteractions(prefs);
    });
  });
}
