import 'package:dartz/dartz.dart';
import 'package:education_bloc_app/src/auth/domain/entities/user.dart';
import 'package:education_bloc_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignIn usecase;

  const tEmail = 'Test Email';
  const tPassword = 'Test Password';

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignIn(
      authRepo: repo,
    );
  });

  const tUser = LocalUser.empty();

  test(
    'should return [LocalUser] from the [AuthRepo]',
    () async {
      when(
        () => repo.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (invocation) async => const Right(tUser),
      );

      final result = await usecase(
        const SignInParams(
          email: tEmail,
          password: tPassword,
        ),
      );

      expect(
        result,
        const Right<dynamic, LocalUser>(tUser),
      );
      verify(
        () => usecase(
          const SignInParams(email: tEmail, password: tPassword),
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
  // no negatif test ???
}
