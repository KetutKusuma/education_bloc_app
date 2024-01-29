import 'package:dartz/dartz.dart';
import 'package:education_bloc_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/sign_up.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignUp usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
  });

  const tParams = SignUpParams(
    fullName: 'Test Full Name',
    email: 'Test Email',
    password: 'Test Password',
  );

  test(
    'should call [AuthRepo]',
    () async {
      // arrange
      when(
        () => repo.signUp(
          fullName: any(named: 'fullName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (invocation) async => const Right(null),
      );

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, const Right<dynamic, void>(null));
      verify(
        () => usecase(tParams),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
