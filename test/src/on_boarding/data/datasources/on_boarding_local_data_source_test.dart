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
        'should return a [ChacheException] when there '
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
      expect(methodCall, throwsA(isA<ChaceException>()));
      verify(
        () => prefs.setBool(kFirstTimerKey, false),
      );
      verifyNoMoreInteractions(prefs);
    });
  });
}
