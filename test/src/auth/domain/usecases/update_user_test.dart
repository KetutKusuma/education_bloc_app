import 'package:dartz/dartz.dart';
import 'package:education_bloc_app/core/enums/update_user.dart';
import 'package:education_bloc_app/src/auth/domain/repos/auth_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/update_user.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo authRepo;
  late UpdateUser updateUser;

  setUp(() {
    authRepo = MockAuthRepo();
    updateUser = UpdateUser(authRepo);
    registerFallbackValue(UpdateUserAction.displayName);
  });

  const tUpdateUser = UpdateUserParams(
    updateUserAction: UpdateUserAction.displayName,
    userData: 'Test User',
  );

  test(
    'should call [AuthRepo]',
    () async {
      when(
        () => authRepo.updateUser(
          updateUserAction: any(named: 'updateUserAction'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenAnswer(
        (invocation) async => const Right(null),
      );

      final result = await updateUser(tUpdateUser);

      expect(result, const Right<dynamic, void>(null));
      verify(
        () => updateUser(tUpdateUser),
      ).called(1);
      verifyNoMoreInteractions(authRepo);
    },
  );
}
