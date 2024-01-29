import 'package:dartz/dartz.dart';
import 'package:education_bloc_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late ForgotPassword usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = ForgotPassword(repo);
  });

  const tPassword = 'Test password';

  test(
    'should call [AuthRepo]',
    () async {
      when(
        () => repo.forgotPassword(any()),
      ).thenAnswer(
        (invocation) async => const Right(null),
      );
      final result = await usecase(tPassword);
      expect(result, const Right<dynamic, void>(null));
      verify(
        () => usecase(tPassword),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
