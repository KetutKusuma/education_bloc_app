import 'package:education_bloc_app/src/auth/domain/entities/user.dart';
import 'package:education_bloc_app/src/auth/domain/repos/auth_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:education_bloc_app/src/auth/domain/usecases/forgot_password.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late ForgotPassword usecase;

  const tEmail = 'Test Email';
  const tPassword = 'Test Password';

  setUp(() {
    repo = MockAuthRepo();
    usecase = ForgotPassword(repo);
  });

  const tUser = LocalUser.empty();

  test(
    'should return [LocalUser] from the [AuthRepo]',
    () {
      when(
        () => repo,
      );
    },
  );
}
